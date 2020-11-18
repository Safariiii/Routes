//
//  RoutesCell.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let ratingImageStr = "star"
fileprivate let clockImageStr = "clock"

import UIKit

class RoutesCell: UICollectionViewCell {
    
    var viewModel: RoutesCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            initViewModel(viewModel: viewModel)
        }
    }

    func initViewModel(viewModel: RoutesCellViewModel) {
        backgroundColor = .white
        setupStackView()
        typeLabel.text = viewModel.routeType
        cityLabel.text = viewModel.city
        titleLabel.text = viewModel.title
        ratingLabel.text = ("\(viewModel.rating)")
        imageView.image = viewModel.image
        clockLabel.text = viewModel.duration
        setupShadow()
        viewModel.subscribeToImageLoad { [weak self] in
            self?.imageView.image = viewModel.image
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, bottomView])
        stackView.axis = .vertical
        return stackView
    }()
    
    func setupStackView() {
        contentView.addSubview(stackView)
        stackView.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        setupTypeLabel()
        for view in stackView.arrangedSubviews {
            stackView.sendSubviewToBack(view)
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    lazy var bottomView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityLabel, titleLabel, ratingView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 11, left: 15, bottom: 15, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingView: UIStackView = {
        let firstView = UIStackView(arrangedSubviews: [ratingImage, ratingLabel])
        firstView.spacing = 5
        let secondView = UIStackView(arrangedSubviews: [clockImage, clockLabel])
        secondView.spacing = 5
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let spaceView = UIStackView(arrangedSubviews: [spacer])
        let stackView = UIStackView(arrangedSubviews: [firstView, secondView, spaceView])
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var ratingImage: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .default)
        let imageView = UIImageView(image: UIImage(systemName: ratingImageStr, withConfiguration: imageConfig))
        imageView.tintColor = .orange
        return imageView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var clockImage: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .default)
        let imageView = UIImageView(image: UIImage(systemName: clockImageStr, withConfiguration: imageConfig))
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var clockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var typeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .systemGray5
        label.alpha = 0.8
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    func setupTypeLabel() {
        imageView.addSubview(typeLabel)
        typeLabel.setupAnchors(top: imageView.topAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 12, bottom: 0, right: 0))
    }
}


