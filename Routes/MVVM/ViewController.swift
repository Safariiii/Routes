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

import UIKit

class RoutesViewController: UIViewController {
    
    var viewModel: RoutesViewModel?
    var maxBarHeight: CGFloat?
    let minBarHeight = UINavigationController().navigationBar.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initViewModel()
        setupNavBar()
        maxBarHeight = navigationController?.navigationBar.frame.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = navigationController?.navigationBar.frame.height
        guard let currentHeight = height, let maxHeight = maxBarHeight else {
            return
        }
        if height == minBarHeight {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .default)
            rightBarButton.setPreferredSymbolConfiguration(imageConfig, forImageIn: .normal)
        } else if Float(currentHeight) >= Float(maxHeight) {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold, scale: .default)
            rightBarButton.setPreferredSymbolConfiguration(imageConfig, forImageIn: .normal)
        }
    }
    
    func initViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.fetchData(reloadCell: { [weak self] index in
            DispatchQueue.main.async {
                self?.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
            }, completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
        })
    }
    
    func setupNavBar() {
        guard let bar = navigationController?.navigationBar else {
            return
        }
        title = vcTitle
        bar.prefersLargeTitles = true
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
        collectionView.delegate = self
        collectionView.dataSource = self
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
