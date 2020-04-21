//
//  TableRequestManger.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

enum TableRequestMangerError: Error {
    case notFound
    case unexpectedError
}

protocol TableRequestServiceProtocol: class {
    func fetchTable(selectedTable: String, completion: @escaping (Result<Table, TableRequestMangerError>) -> Void)
}

class TableRequestService: TableRequestServiceProtocol {
    let httpHandler: HTTPHandlerProtocol
    
    init(httpHandler: HTTPHandlerProtocol = HttpHandler()) {
        self.httpHandler = httpHandler
    }
    
    func fetchTable(selectedTable: String, completion: @escaping (Result<Table, TableRequestMangerError>) -> Void) {
        let request = TableRequest(selectedTable: selectedTable)
        httpHandler.make(request: request) { (result: Result<[Table], Error>) in
            switch result {
            case.failure(let error):
                if case HTTPHandlerError.wrongStatusCode(let code) = error {
                    switch code {
                    case 404:
                        completion(Result.failure(.notFound))
                    default:
                        completion(Result.failure(.unexpectedError))
                    }
                }
                
                print(error.localizedDescription)
            case .success(let value):
                guard let table = value.first else { completion(.failure(.notFound)); return }
                completion(Result.success(table))
            }
        }
    }
    
}
