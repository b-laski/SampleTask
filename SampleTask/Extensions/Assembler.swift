//
//  Assembler.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 18/04/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Swinject

extension Assembler {
    private static let shared: Assembler = {
        let container = Container()
        let assembler = Assembler([
            MainViewModelAssembly(),
            DeatilViewModelAssembly()
        ], container: container)
        
        return assembler
    }()
    
    static func resolve<T>() -> T {
        return shared.resolver.resolve(T.self)!
    }
}
