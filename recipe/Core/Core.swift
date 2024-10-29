//
//  Core.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import SwiftUI
import Combine

/// The `Core` class is responsible for initializing and configuring
/// the essential components needed for launching the app.
/// This includes setup for services, managers, and any foundational
/// dependencies required by the application at startup.

final actor Core {
    private let factory: Factoryable = Factory()
    private let eventsPassthroughSubject = PassthroughSubject<CoreEvent, CoreError>()
    private var cancellables = [AnyCancellable]()

    init() async {
        await factory
            .systemRouter
            .events
            .sink { _ in
                // do nothing
            } receiveValue: { event in
                Task { [weak self] in
                    await self?.eventsPassthroughSubject.send(.routerEvent(event))
                }
            }
            .store(in: &cancellables)

    }
}

// MARK: Corable

extension Core: Corable {

    var events: AnyPublisher<CoreEvent, CoreError> {
        eventsPassthroughSubject.eraseToAnyPublisher()
    }

    func initApp() async {
        await factory.systemRouter.showAppLoadingPage()
    }
}
