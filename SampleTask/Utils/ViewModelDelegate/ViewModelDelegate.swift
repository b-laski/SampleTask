//
//  ViewModelDelegate.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func showMessage(title: String, body: String)
}
