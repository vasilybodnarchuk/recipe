//
//  Factory.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import SwiftUI

/// The `Factory` actor is the centralized creator and provider of all pages, components,
/// and services required by the app. It ensures that all dependencies are properly
/// initialized, configured, and accessible, promoting consistency and control over
/// app-wide resources.

final actor Factory {
    let serviceFactory: ServiceFactoryable = ServiceFactory()
    private var _pageFactory: PageFactoryable!
    private var _systemRouter: SystemRouterable!
    private var _pageRouter: PageRouter!

    init() {
        self._pageFactory = PageFactory(serviceFactory: serviceFactory)
    }
}

// MARK: Factoryable

extension Factory: Factoryable {
    var pageFactory: any PageFactoryable {
        get async {
            _pageFactory
        }
    }

    var systemRouter: SystemRouterable {
        if let router = _systemRouter { return router }
        _systemRouter = SystemRouter(factory: self)
        return _systemRouter!
    }

    var pageRouter: any PageRouterable {
        if let pageRouter = _pageRouter { return pageRouter }
        _pageRouter = PageRouter(systemRouter: systemRouter)
        return _pageRouter!
    }
}
