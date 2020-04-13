//
//  HTTPHandlerError.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 10/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

enum HTTPHandlerError: Error {
    case wrongStatusCode(code: Int)
    case incorectRequest
    case incorectUrl
}
