//
//  Router.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import Combine
import SwiftUI

/// The `SystemRouter` component handles navigation and presentation logic,
/// including transitioning between screens, showing alerts, and switching tabs.
/// This component is isolated within the `Core` class, meaning it is not
/// accessible outside `Core`, ensuring a controlled and consistent navigation flow
/// throughout the app.

final class SystemRouter {
    private weak var factory: Factoryable!
    private let eventsPassthroughSubject = PassthroughSubject<RouterEvent, RouterError>()

    var events: AnyPublisher<RouterEvent, RouterError> {
        eventsPassthroughSubject.eraseToAnyPublisher()
    }

    init(factory: Factoryable) {
        self.factory = factory
    }
}

// MARK: Routerable

extension SystemRouter: SystemRouterable {
    func showGlobalAlert(error: Error) {
        eventsPassthroughSubject.send(.showAlert(error: error))
    }

    func showAppLoadingPage() async {
        let page = await self.factory.pageFactory.createAppLoadingPage(pageRouter: self.factory.pageRouter)
        eventsPassthroughSubject.send(.render(page: page))
    }

    func showRecipesPage() async {
        let page = await self.factory.pageFactory.createRecipesPage(pageRouter: self.factory.pageRouter)
        eventsPassthroughSubject.send(.render(page: page))
    }
}
