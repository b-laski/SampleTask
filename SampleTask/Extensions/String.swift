//
//  String.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatType.yyyyMMdd.rawValue
        return dateFormatter.date(from: self)
    }
}
