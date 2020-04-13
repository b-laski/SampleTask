//
//  HTTPHandlerRequestProtocol.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 10/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

protocol HTTPHandlerRequestProtocol {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: Encodable? { get }
    var queryParameters: [String: String]? { get }
    var headers: [String: String] { get }
}

extension HTTPHandlerRequestProtocol {
    func defaultHeader() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
}
