//
//  Route.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

struct Route {
    var routeType: RouteType = .excursion
    var image: UIImage = UIImage()
    var city: String = ""
    var title: String = ""
    var rating: String = ""
    var duration: String = ""
    var isReal: Bool = false
}

enum RouteType: String {
    case excursion = "excursion"
    
    var titile: String {
        switch self {
        case .excursion:
            return "Экскурсия"
        }
    }
}
