//
//  MainViewModelAssembly.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 13/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Swinject

class MainViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HTTPHandlerProtocol.self) { _ in HttpHandler() }
        
        container.register(TableRequestServiceProtocol.self) { resolver in
            guard let httpHandler = resolver.resolve(HTTPHandlerProtocol.self) else { fatalError("HTTPHandlerProtocol assambly does not exist.") }
            return TableRequestService(httpHandler: httpHandler)
        }
    }
}
