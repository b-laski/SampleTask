//
//  TableRequest.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 11/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

struct TableRequest: HTTPHandlerRequestProtocol {
    let selectedTable: String
    
    init(selectedTable: String) {
        self.selectedTable = selectedTable
    }
    
    var endpoint: String {
        return "exchangerates/tables/\(selectedTable)"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameters: Encodable?
    
    var queryParameters: [String: String]?
    
    var headers: [String: String] {
        return defaultHeader()
    }
    
}
