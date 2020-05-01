//
//  MainViewModel.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import RxCocoa

class MainViewModel {
    
    // MARK: - Public variables -
    var tableRequestManager: TableRequestServiceProtocol = DIHolder.resolve()
    var table: Table?
    var currencies: PublishSubject<[Currency]>
    var segments: BehaviorRelay<[MenuBarViewItemAttribute]>
    
    // MARK: - Inits -
    init() {
        self.currencies = PublishSubject()
        self.segments = BehaviorRelay(value: [MenuBarViewItemAttribute(color: .systemBackground, text: "A"),
                                              MenuBarViewItemAttribute(color: .systemBackground, text: "B"),
                                              MenuBarViewItemAttribute(color: .systemBackground, text: "C")])
    }
    
    // MARK: - Public methods -
    func fetchSelectedTable(tableName: String) {
        tableRequestManager.fetchTable(selectedTable: tableName) { [weak self] (result: Result<Table, TableRequestMangerError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.currencies.onError(error)
            case .success(let value):
                strongSelf.table = value
                strongSelf.currencies.onNext(value.rates)
            }
        }
    }
}
