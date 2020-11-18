//
//  Route.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

struct Route {
    var id: Int = 0
    var routeType: RouteType = .excursion
    var imageURL: String = ""
    var city: String = ""
    var title: String = ""
    var rating: Int = 0
    var duration: String = ""
}



enum RouteType: String {
    case excursion = "excursion"
    case route = "route"
    
    var title: String {
        switch self {
        case .excursion:
            return "Экскурсия"
        case .route:
            return "Маршрут"
        }
    }
}
