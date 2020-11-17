//
//  RoutesCellViewModel.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class RoutesCellViewModel {
    var routeType: String
    var image: UIImage
    var city: String
    var title: String
    var rating: String
    var duration: String
    
    init(routeType: String, city: String, title: String, rating: String, duration: String, image: UIImage) {
        self.routeType = routeType
        self.city = city
        self.title = title
        self.rating = rating
        self.duration = duration
        self.image = image
    }
}
