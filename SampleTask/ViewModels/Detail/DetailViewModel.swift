//
//  DetailViewModel.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

protocol DetailViewModelDelegate: ViewModelDelegate {
    func reloadChart()
}

class DetailViewModel {
    
    // MARK: - Public variables -
    let currencyService: CurrencyServiceProtocol = DIContainter.resolve()
    var currencyDate: Table?
    
    weak var delegate: DetailViewModelDelegate?
    
    // MARK: - Inits -
    init(delegate: DetailViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Public methods -
    func fetchCurrencyData(tableType: String, code: String, startDate: String, endDate: String) {
        currencyService.fetchCurrency(tableType: tableType,
                                      code: code,
                                      startDate: startDate,
                                      endDate: endDate) { [weak self] (result: Result<Table, CurrencyServiceError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.delegate?.showMessage(title: "Error", body: error.localizedDescription)
            case .success(let data):
                strongSelf.currencyDate = data
                strongSelf.delegate?.reloadChart()
            }
        }
    }
}
