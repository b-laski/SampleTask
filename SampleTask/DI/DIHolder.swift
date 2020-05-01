//
//  DIHolder.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 01/05/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import Foundation
import Swinject

final class DIHolder {
    private static let shared: Assembler = {
        let container = Container()
        let assembler = Assembler([
            MainAssembly(),
            DeatilAssembly()
        ], container: container)
        
        return assembler
    }()
    
    static func resolve<T>() -> T {
        return shared.resolver.resolve(T.self)!
    }
}
