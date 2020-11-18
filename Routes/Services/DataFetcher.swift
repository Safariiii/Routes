//
//  DataFetcher.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 17.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire

class DataFetcher {
    
    var nextPage: String?

    func fetchData(url: String, completion: @escaping (([Route]) -> Void)) {
        if isConnected(url: url) {
            guard let url = URL(string: url) else {
                return
            }
            Alamofire.request(url, method: .get).responseData { (response) in
                if response.result.isSuccess {
                    if let responseData = response.result.value {
                        guard let routes = self.parseJSON(responseData) else {
                            return
                        }
                        completion(routes)
                    }
                }
            }
        } else {
            print("no connection")
        }
    }
    
    func parseJSON(_ data: Foundation.Data) -> [Route]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RouteData.self, from: data)
            nextPage = decodedData.links?.next
            var routes: [Route] = []
            if let dataArray = decodedData.data {
                for item in dataArray {
                    var routeType = RouteType.excursion
                    if let type = RouteType(rawValue: item.type ?? "excursion") {
                        routeType = type
                    }
                    let imageURL = item.images?[0] ?? ""
                    let city = item.city?.title ?? ""
                    let title = item.title ?? ""
                    let rating = item.rating ?? 0
                    let duration = item.duration ?? ""
                    let id = item.id ?? 0
                    let newRoute = Route(id: id, routeType: routeType, imageURL: imageURL, city: city, title: title, rating: rating, duration: duration)
                    routes.append(newRoute)
                }
            }
            return routes
        } catch {
            return nil
        }
    }
    
    static func getImage(url: String, completion: @escaping ((Foundation.Data) -> Void)){
        if let cache = CacheService.shared.loadImage(url: url) {
            completion(cache)
        } else {
            let queue = DispatchQueue(label: url)
            queue.async {
                guard let url = URL(string: url) else {
                    return
                }
                Alamofire.request(url, method: .get).responseData { (data) in
                    if let data = data.data {
                        completion(data)
                        CacheService.shared.saveImage(url: url.absoluteString, data: data)
                    }
                }
            }
        }
    }
    
    func isConnected(url: String) -> Bool {
        guard let networkManager = NetworkReachabilityManager(host: url) else {
            return false
        }
        return networkManager.isReachable
    }
}
