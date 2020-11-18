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
    var errorSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var routesArray = [Route(), Route()]
    let fetcher = DataFetcher()
    var isUpdating = false
    
    init() {
        fetcher.fetchData(url: "https://murmansk.travel/api/trips", completion: { [weak self] (routes) in
            self?.routesArray = []
            self?.fetchSubject.onNext(routes)
        }, error: { [weak self] in
            self?.errorSubject.onNext(true)
        })
    }
    
    func subscribeToErrors(completion: @escaping (() -> Void)) {
        errorSubject.subscribe(onNext: { (error) in
            completion()
        }).disposed(by: disposeBag)
        
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
        self.fetcher.fetchData(url: nextURL, completion: { [weak self] (routes) in
            self?.fetchSubject.onNext(routes)
            }, error: { [weak self] in
                self?.errorSubject.onNext(true)
        })
    }
    
    func numberOfItemsInSection() -> Int {
        return routesArray.count
    }
    
    func cellViewModel(indexPath: IndexPath) -> RoutesCellViewModel {
        return RoutesCellViewModel(route: routesArray[indexPath.row])
    }
    
}
