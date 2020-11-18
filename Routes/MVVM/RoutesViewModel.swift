//
//  RoutesViewModel.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import RxSwift

class RoutesViewModel {
    var router: RoutesRouter!
    let disposeBag = DisposeBag()
    let offsetSubject = PublishSubject<Bool>()
    var fetchSubject = PublishSubject<[Route]>()
    var routesArray = [Route(), Route()]
    let fetcher = DataFetcher()
    var isUpdating = false
    
    init() {
        fetcher.fetchData(url: "https://murmansk.travel/api/trips") { [weak self] (routes) in
            self?.routesArray = []
            self?.fetchSubject.onNext(routes)
        }
    }
    
    func subscribeToUpdates(completion: @escaping (() -> Void)) {
        fetchSubject.subscribe(onNext: { [weak self] (routes) in
            self?.routesArray.append(contentsOf: routes)
            completion()
            self?.isUpdating = false
        }).disposed(by: disposeBag)
    }
    
    func needToUpdate() {
        guard let nextURL = self.fetcher.nextPage else {
            return
        }
        isUpdating = true
        self.fetcher.fetchData(url: nextURL) { [weak self] (routes) in
            self?.fetchSubject.onNext(routes)
        }
    }
    
    func numberOfItemsInSection() -> Int {
        return routesArray.count
    }
    
    func cellViewModel(indexPath: IndexPath) -> RoutesCellViewModel {
        return RoutesCellViewModel(route: routesArray[indexPath.row])
    }
    
}
