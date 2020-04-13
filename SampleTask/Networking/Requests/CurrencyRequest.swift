//
//  CurrencyRequest.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

struct CurrencyRequest: HTTPHandlerRequestProtocol {
    
    let table: String
    let code: String
    let startData: String
    let endData: String
    
    var endpoint: String {
        return "exchangerates/rates/\(table)/\(code)/\(startData)/\(endData)/"
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var parameters: Encodable?
    
    var queryParameters: [String : String]?
    
    var headers: [String : String] {
        return defaultHeader()
    }
    
}
