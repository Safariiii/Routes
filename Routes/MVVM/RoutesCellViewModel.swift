//
//  RoutesCellViewModel.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class RoutesCellViewModel {
    var routeType: String
    var city: String
    var title: String
    var rating: Int
    var duration: String
    let route: Route
    var image: UIImage?
    let imageSubject = PublishSubject<Bool>()
    let disposeBag = DisposeBag()
    
    init(route: Route) {
        self.route = route
        self.city = route.city
        self.title = route.title
        self.rating = route.rating
        self.duration = route.duration
        self.routeType = route.routeType.title
        fetchImage()
    }
    
    func subscribeToImageLoad(completion: @escaping(() -> Void)) {
        imageSubject.subscribe(onNext: { (result) in
            if result {
                completion()
            }
        }).disposed(by: disposeBag)
    }
    
    func fetchImage() {
        DataFetcher.getImage(url: self.route.imageURL, completion: { [weak self] data in
            self?.image = UIImage(data: data)
            self?.imageSubject.onNext(true)
        })
    }
}
