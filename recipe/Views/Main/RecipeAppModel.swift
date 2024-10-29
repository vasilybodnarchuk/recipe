//
//  RecipeAppModel.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import Foundation
import Combine
import SwiftUI

/// `RecipeAppModel` is an observable object that serves as the main view model for the Recipe app.

final class RecipeAppModel: ObservableObject {
    private(set) var isCoreLoading = true
    @Published var showingAlert = false
    @MainActor @Published var rootPage: AnyView = AnyView(EmptyView())

    private(set) var alertState = AlertState.noMessages

    private var cancellables = [AnyCancellable]()
    private var core: Corable!

    init() {
        Task { [weak self] in
            guard let self = self else { return }
            self.core = await Core()
            await self.core.events
                .sink { _ in
                    // Do not need completion
                } receiveValue: { result in
                    switch result {
                    case let .routerEvent(routerEvent):
                        switch routerEvent {
                        case let .showAlert(error):
                            self.showAlert(state: .error(error: error))
                        case .render(let page):
                            self.updateRootPage(newPage: page)
                        }

                    }
                }
                .store(in: &cancellables)
            self.isCoreLoading = false
            await core.initApp()
        }
    }

    func updateRootPage(newPage: AnyView) {
        Task { @MainActor [weak self] in
            self?.rootPage = AnyView(newPage)
        }
    }
}

// MARK: Alert

extension RecipeAppModel {
    enum AlertState {
        case noMessages
        case error(error: Error)

        var title: String {
            switch self {
            case .noMessages: return ""
            case .error: return "Error"
            }
        }

        var message: String {
            switch self {
            case .noMessages: return ""
            case let .error(error): return error.localizedDescription
            }
        }

        var showAlert: Bool {
            switch self {
            case .noMessages: return false
            case .error: return true
            }
        }
    }

    func showAlert(state: AlertState) {
        alertState = state
        Task {
            await MainActor.run { [weak self] in
                self?.showingAlert = state.showAlert
            }
        }
    }
}
