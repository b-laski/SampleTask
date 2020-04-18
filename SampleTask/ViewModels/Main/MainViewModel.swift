//
//  MainViewModel.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation
import Swinject

protocol MainViewModelDelegate: ViewModelDelegate {
    func reloadData()
}

class MainViewModel {
    
    // MARK: - Public variables -
    var tableRequestManager: TableRequestServiceProtocol = Assembler.mainViewModelAssembly
    var tableData: Table?
    
    weak var delegate: MainViewModelDelegate?
    
    // MARK: - Inits -
    init(delegate: MainViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Public methods -
    func fetchSelectedTable(tableName: String) {
        tableRequestManager.fetchTable(selectedTable: tableName) { [weak self] (result: Result<[Table], TableRequestMangerError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.delegate?.showMessage(title: "Error", body: error.localizedDescription)
            case .success(let value):
                if let value = value.first {
                    strongSelf.tableData = value
                    strongSelf.delegate?.reloadData()
                }
            }
        }
    }
    
    func clearTableData() {
        tableData = nil
        delegate?.reloadData()
    }
}
