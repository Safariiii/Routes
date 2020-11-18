//
//  ViewController.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let cellID = "cell"
fileprivate let vcTitle = "Маршруты"
fileprivate let filterImage = "slider.horizontal.3"
fileprivate let errorText = "Не удалось загрузить данные. Проверьте соединение и повторите попытку позже."

import UIKit

class RoutesViewController: UIViewController {
    
    var viewModel: RoutesViewModel?
    var maxBarHeight: CGFloat?
    let minBarHeight = UINavigationController().navigationBar.frame.height
    let minSizeImageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .default)
    let maxSizeImageConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold, scale: .default)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initViewModel()
        setupNavBar()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = navigationController?.navigationBar.frame.height
        guard let currentHeight = height, let maxHeight = maxBarHeight else {
            return
        }
        if height == minBarHeight {
            rightBarButton.setPreferredSymbolConfiguration(minSizeImageConfig, forImageIn: .normal)
        } else if Float(currentHeight) >= Float(maxHeight) {
            rightBarButton.setPreferredSymbolConfiguration(maxSizeImageConfig, forImageIn: .normal)
        }
        guard let viewModel = viewModel else { return }
        if viewModel.isUpdating {
            return
        }
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height - scrollView.frame.size.height : 0
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset < UIScreen.main.bounds.height * 2 {
            viewModel.needToUpdate()
        }
    }
    
    func initViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.subscribeToErrors { [weak self] in
            self?.setupErrorMessage()
        }
        viewModel.subscribeToUpdates { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func setupNavBar() {
        guard let bar = navigationController?.navigationBar else {
            return
        }
        title = vcTitle
        bar.prefersLargeTitles = true
        maxBarHeight = bar.frame.height
        bar.addSubview(rightBarButton)
        rightBarButton.setupAnchors(top: nil, leading: nil, bottom: bar.bottomAnchor, trailing: bar.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -15, right: -15))
    }
    
    lazy var rightBarButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: filterImage)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .default)
        
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(imageConfig, forImageIn: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonPressed() {
        print("Кнопка нажата")
    }
    
    lazy var collectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth-30, height: screenHeight/2)
        layout.minimumLineSpacing = 25
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(RoutesCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    lazy var errorMessage: PaddingLabel = {
        let label = PaddingLabel()
        label.text = errorText
        label.numberOfLines = 0
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    func setupErrorMessage() {
        view.addSubview(errorMessage)
        errorMessage.setupAnchors(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, padding: .init(top: 0, left: 40, bottom: 0, right: -40))
        errorMessage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.errorMessage.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.errorMessage.alpha = 0
            }) { _ in
                self.errorMessage.removeFromSuperview()
            }
        }
    }
}

extension RoutesViewController: UICollectionViewDelegate {
    
}

extension RoutesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 2
        }
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? RoutesCell, let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.cellViewModel(indexPath: indexPath)
        return cell
    }
}
