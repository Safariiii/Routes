//
//  CacheService.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 18.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class CacheService {
    
    static let shared = CacheService()
    private init() {
        
    }
    
    private var images: [String: Foundation.Data] = [:]
    
    func saveImage(url: String, data: Foundation.Data) {
        images[url] = data
    }
    
    func loadImage(url: String) -> Foundation.Data? {
        return images[url]
    }
}
