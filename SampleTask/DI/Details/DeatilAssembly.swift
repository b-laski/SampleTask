//
//  DeatilAssembly.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 18/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Swinject

class DeatilAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HTTPHandlerProtocol.self) { _ in HttpHandler() }
        
        container.register(CurrencyServiceProtocol.self, factory: { resolver in
            guard let httpHandler = resolver.resolve(HTTPHandlerProtocol.self) else { fatalError("HTTPHandlerProtocol assambly does not exist.") }
            return CurrencyService(httpHandler: httpHandler)
        })
    }
}
