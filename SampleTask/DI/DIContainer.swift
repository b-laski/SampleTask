//
//  DIContainer.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Dip

class DIContainter {
    static var container = DependencyContainer { container in
        registerDefinitions(on: container)
    }
    
    static func resolve<T>(tag: DependencyTagConvertible? = nil) -> T {
        do {
            return try container.resolve(tag: tag)
        } catch {
            fatalError("DI error:\(error)")
        }
    }
}

private extension DIContainter {
    static func registerDefinitions(on container: DependencyContainer) {
        container.register { TableRequestService() as TableRequestServiceProtocol }
        container.register { CurrencyService() as CurrencyServiceProtocol }
        container.register { HttpHandler() as HTTPHandlerProtocol}
    }
}
