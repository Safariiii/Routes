//
//  RoutesViewModel.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData
import RxSwift

class RoutesViewModel {
    var router: RoutesRouter!
    let imageSubject = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var jsonResponse: JSON?
    var latestIndex: Int = 0
    var openItems = [Int]()
    var scrollSubject = PublishSubject<Int>()
    var routesArray = [Route(), Route()]
    
    func fetchData(reloadCell: @escaping ((Int) -> Void), completion: @escaping (() -> Void)) {
        guard let url = URL(string: "https://murmansk.travel/api/trips") else {
            return
        }
        subscribeToImages(completion: reloadCell)
        subscribeToScroll(completion: reloadCell)
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            guard let self = self else {
                return
            }
            if response.result.isSuccess {
                self.routesArray = []
                self.jsonResponse = JSON(response.result.value!)
                for _ in self.jsonResponse!["data"] {
                    self.routesArray.append(Route())
                }
                completion()
                for item in self.openItems {
                    DispatchQueue.main.async {
                        self.scrollSubject.onNext(item)
                    }
                }
            }
        }
    }
    
    private func subscribeToScroll(completion: @escaping ((Int) -> Void)) {
        scrollSubject.subscribe(onNext: { (index) in
            self.addCell(index: index, completion: completion)
        }).disposed(by: disposeBag)
    }
    
    private func subscribeToImages(completion: @escaping ((Int) -> Void)) {
        imageSubject.subscribe(onNext: { (index) in
            completion(index)
            if let context = self.context {
                do {
                    try context.save()
                } catch {
                    print("image error:", error.localizedDescription)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func addCell(index: Int, completion: @escaping ((Int) -> Void)) {
        guard let jsonResponse = jsonResponse else { return }
        var newRoute = Route()
        if let routeType = RouteType(rawValue: jsonResponse["data"][index]["type"].stringValue) {
            newRoute.routeType = routeType
        }
        newRoute.title = jsonResponse["data"][index]["title"].stringValue
        newRoute.rating = jsonResponse["data"][index]["rating"].stringValue
        newRoute.city = jsonResponse["data"][index]["city"]["title"].stringValue
        newRoute.duration = jsonResponse["data"][index]["duration"].stringValue
        newRoute.isReal = true
        let responseImage = jsonResponse["data"][index]["images"][0].stringValue
        
        if let context = context {
            if let image = self.getCoreDataImage(context: context, url: responseImage) {
                if let imageData = image.image, let finalImage =  UIImage(data: imageData) {
                    newRoute.image = finalImage
                }
            } else {
                let queue = DispatchQueue(label: "\(index)")
                let newImage = Images(context: context)
                newImage.url = responseImage
                queue.async {
                    Alamofire.request(URL(string: responseImage)!, method: .get).responseData { [weak self] (data) in
                        newImage.image = data.data
                        self?.routesArray[index].image = UIImage(data: newImage.image!)!
                        DispatchQueue.main.async {
                            self?.imageSubject.onNext(index)
                        }
                    }
                }
            }
        }
        self.routesArray[index] = newRoute
        completion(index)
    }
    
    private func getCoreDataImage(context: NSManagedObjectContext, url: String) -> Images? {
        let request: NSFetchRequest<Images> = Images.fetchRequest()
        request.predicate = NSPredicate(format: "url CONTAINS[cd] %@", url)
        var result: [Images] = []
        do {
            result = try context.fetch(request)
        } catch {
            print("2image error:", error.localizedDescription)
        }
        if result.count == 1 {
            return result[0]
        } else {
            return nil
        }
    }
    
    func numberOfItemsInSection() -> Int {
        return routesArray.count
    }
    
    func cellViewModel(indexPath: IndexPath) -> RoutesCellViewModel {
        let route = routesArray[indexPath.row]
        if indexPath.item > latestIndex {
            latestIndex = indexPath.item
            DispatchQueue.main.async {
                self.scrollSubject.onNext(self.latestIndex)
            }
        }
        if !route.isReal {
            openItems.append(indexPath.item)
            self.scrollSubject.onNext(indexPath.item)
        }
        let cellViewModel = RoutesCellViewModel(routeType: route.routeType.titile, city: route.city, title: route.title, rating: route.rating, duration: route.duration, image: route.image)
        return cellViewModel
    }
    
}
