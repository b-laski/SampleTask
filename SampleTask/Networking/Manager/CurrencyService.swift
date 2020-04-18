//
//  CurrencyService.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation
import Swinject

enum CurrencyServiceError: LocalizedError {
    case badRequest
    case notFound
    case unexpectedError
    
    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "Błędny zakres dat"
        case .notFound:
            return "Dane nie znalezione"
        case .unexpectedError:
            return "Coś poszło nie tak"
        }
    }
}

protocol CurrencyServiceProtocol: class {
    func fetchCurrency(tableType: String,
                       code: String,
                       startDate: String,
                       endDate: String,
                       completion: @escaping (Result<Table, CurrencyServiceError>) -> Void)
}

class CurrencyService: CurrencyServiceProtocol {
    let httpHandler: HTTPHandlerProtocol
    
    init(httpHandler: HTTPHandlerProtocol = HttpHandler()) {
        self.httpHandler = httpHandler
    }
    
    func fetchCurrency(tableType: String,
                       code: String,
                       startDate: String,
                       endDate: String,
                       completion: @escaping (Result<Table, CurrencyServiceError>) -> Void) {
        let request = CurrencyRequest(table: tableType, code: code, startData: startDate, endData: endDate)
        
        httpHandler.make(request: request) { (response: Result<Table, Error>) in
            switch response {
            case .failure(let error):
                if case HTTPHandlerError.wrongStatusCode(let code) = error {
                    switch code {
                    case 400:
                        completion(.failure(.badRequest))
                    case 404:
                        completion(.failure(.notFound))
                    default:
                        completion(.failure(.unexpectedError))
                    }
                }
            case .success(let value):
                completion(.success(value))
            }
        }
    }
}
