//
//  RouteData.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 17.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

struct RouteData: Decodable {
    let data: [Routes.Data]?
    let links: Links?
}

struct Data: Decodable {
    let title: String?
    let rating: Int?
    let duration: String?
    let city: City?
    let images: [String]?
    let id: Int?
    let type: String?
}

struct Links: Decodable {
    let prev: String?
    let next: String?
}

struct City: Decodable {
    let title: String?
}
