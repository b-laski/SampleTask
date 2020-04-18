//
//  Assembler.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 18/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Swinject

extension Assembler {
    private static let sharedAssembler: Assembler = {
        let container = Container()
        let assembler = Assembler([
            MainViewModelAssembly(),
            DeatilViewModelAssembly()
        ], container: container)
        
        return assembler
    }()
    
    static var mainViewModelAssembly: TableRequestServiceProtocol {
         return sharedAssembler.resolver.resolve(TableRequestServiceProtocol.self)!
    }
    
    static var detailViewModelAssembly: CurrencyServiceProtocol {
        return sharedAssembler.resolver.resolve(CurrencyServiceProtocol.self)!
    }
}
