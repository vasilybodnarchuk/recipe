//
//  Factoryable.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import SwiftUI

/// The `Factoryable` protocol defines the interface for a factory that can create
/// and provide access to essential app components.

protocol Factoryable: Actor {
    var serviceFactory: ServiceFactoryable { get async }
    var pageFactory: PageFactoryable { get async }
    var systemRouter: SystemRouterable { get async }
    var pageRouter: any PageRouterable { get async }
}
