//
//  AlertBuilder.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 12/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

struct AlertBuilder {
    private var alert: UIAlertController?
    
    func build() -> UIAlertController {
        guard let alert = alert else {
            fatalError("Trying to use variable before being initialized")
        }
        return alert
    }
    
    mutating func content(title: String, message: String) -> AlertBuilder {
        alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        return self
    }
    
    func addAction( title: String,
                    style: UIAlertAction.Style = .default,
                    preferred: Bool = false,
                    _ handler: (() -> Void)? = nil) -> AlertBuilder {

        let action = UIAlertAction(title: title, style: style) { _ in
            handler?()
        }

        alert?.addAction(action)

        if preferred {
            alert?.preferredAction = action
        }

        return self
    }
    
    static func acceptAlert(title: String, message: String) -> UIAlertController {
        var builder = AlertBuilder()
        return builder
            .content(title: title, message: message)
            .addAction(title: "OK")
            .build()
    }
}
