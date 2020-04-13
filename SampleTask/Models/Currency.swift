//
//  Currency.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 10/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

struct Currency: Codable {
    let currency: String?
    let code: String?
    let no: String?
    let effectiveDate: String?
    let bid: Double?
    let ask: Double?
    let mid: Double?
}

extension Currency {
    func average() -> Double? {
        if let bid = bid, let ask = ask {
            return (bid+ask) / 2
        }
        return nil
    }
}
