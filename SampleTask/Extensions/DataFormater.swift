//
//  DataFormater.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case yyyyMMdd = "yyyy-MM-dd"
}

extension DateFormatter {
    static private func newInstance(dateFormat: DateFormatType) -> DateFormatter {
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = dateFormat.rawValue
        return dataFormater
    }
    
    static var ddMMyyyyDashes: DateFormatter {
        return newInstance(dateFormat: .yyyyMMdd)
    }
    
}
