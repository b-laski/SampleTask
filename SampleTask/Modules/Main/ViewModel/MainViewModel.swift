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

protocol MainViewModelInputsProtocol: class {
    var showDetails: PublishSubject<Currency> { get }
}

protocol MainViewModelOutputsProtocol: class {
    var table: BehaviorRelay<Table> { get }
    var currencies: PublishSubject<[Currency]> { get }
    var segments: BehaviorRelay<[MenuBarViewItemAttribute]> { get }
    
    var error: PublishSubject<TableRequestMangerError> { get }
}

class MainViewModel: MainViewModelInputsProtocol, MainViewModelOutputsProtocol {
    // MARK: - INPUTS -
    var showDetails: PublishSubject<Currency>
    
    // MARK: - OUTPUT -
    var table: BehaviorRelay<Table>
    var currencies: PublishSubject<[Currency]>
    var segments: BehaviorRelay<[MenuBarViewItemAttribute]>
    var error: PublishSubject<TableRequestMangerError>
    
    // MARK: - Public variables -
    var tableRequestManager: TableRequestServiceProtocol = DIHolder.resolve()
    // MARK: - Inits -
    init() {
        showDetails = PublishSubject()
        
        table = BehaviorRelay(value: Table())
        currencies = PublishSubject()
        segments = BehaviorRelay(value: [MenuBarViewItemAttribute(color: .systemBackground, text: "A"),
                                         MenuBarViewItemAttribute(color: .systemBackground, text: "B"),
                                         MenuBarViewItemAttribute(color: .systemBackground, text: "C")])
        
        error = PublishSubject()
    }
    
    // MARK: - Public methods -
    func fetchSelectedTable(tableName: String) {
        tableRequestManager.fetchTable(selectedTable: tableName) { [weak self] (result: Result<Table, TableRequestMangerError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.error.onNext(error)
            case .success(let value):
                strongSelf.table.accept(value)
                strongSelf.currencies.onNext(value.rates)
            }
        }
    }
}
