//
//  DetailViewModel.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import RxCocoa

class DetailViewModel {
    
    // MARK: - Private variables -
    private let tableType: String
    private let currency: Currency
    
    // MARK: - Public variables -
    var currencyService: CurrencyServiceProtocol = Assembler.resolve()
    let startDate: BehaviorRelay = BehaviorRelay(value: "")
    let endDate: BehaviorRelay = BehaviorRelay(value: "")
    
    let didLoadData: PublishSubject<Table> = PublishSubject()
    let didFailLoadData: PublishSubject<Error> = PublishSubject()
    
    // MARK: - Inits -
    init(tableType: String, currency: Currency) {
        self.tableType = tableType
        self.currency = currency
    }
    
    // MARK: - Public methods -
    func fetchCurrencyData() {
        guard let code = currency.code else { return }
        
        currencyService.fetchCurrency(tableType: tableType,
                                      code: code,
                                      startDate: startDate.value,
                                      endDate: endDate.value) { [weak self] (result: Result<Table, CurrencyServiceError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.didFailLoadData.onNext(error)
            case .success(let data):
                strongSelf.didLoadData.onNext(data)
            }
        }
    }
}
