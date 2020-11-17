//
//  RoutesRouter.swift
//  Routes
//
//  Created by Руслан Сафаргалеев on 15.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class RoutesRouter {
    weak var nc: UINavigationController?
    
    static func showModule(nc: UINavigationController) {
        let configurator = RoutesConfigurator()
        
        if let vc = configurator.view {
            nc.pushViewController(vc, animated: true)
            configurator.router?.nc = nc
        }
    }
}

class RoutesConfigurator {
    var viewModel: RoutesViewModel?
    var router: RoutesRouter?
    var view: RoutesViewController?
    
    init() {
        viewModel = RoutesViewModel()
        view = RoutesViewController()
        router = RoutesRouter()
        viewModel?.router = router
        view?.viewModel = viewModel
    }
}
