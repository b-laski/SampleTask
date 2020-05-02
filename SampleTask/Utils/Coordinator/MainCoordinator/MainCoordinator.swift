//
//  MainCoordinator.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 02/05/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit
import RxSwift

protocol MainCoordinatorActions: class {
    func showCurrencyDetail(tableType: String, currency: Currency)
}

class MainCoordinator: BaseCoordinator {
    private let bag = DisposeBag()
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
    }
    
    override func start() {
        let viewController = MainViewController()
        viewController.viewmModel = viewModel
        
        viewModel.showDetails
            .subscribe(
                onNext: { [weak self] currency in
                    let tableType = viewController.viewmModel.table.value.table
                    self?.showCurrencyDetail(tableType: tableType, currency: currency)
                }, onDisposed: {
                    print("showDetails disposed")
                }
            ).disposed(by: bag)
        
        navigationController.viewControllers = [viewController]
    }
}

extension MainCoordinator: MainCoordinatorActions {
    func showCurrencyDetail(tableType: String, currency: Currency) {
        let detailViewController = DetailViewController(tableType: tableType, currency: currency)
        navigationController.show(detailViewController, sender: nil)
    }
}
