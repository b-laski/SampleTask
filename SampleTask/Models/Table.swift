//
//  TableModel.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 10/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

struct Table: Codable {
    let table: String
    let no: String?
    let tradingDate: String?
    let effectiveDate: String?
    let currency: String?
    let code: String?
    let rates: [Currency]
}
