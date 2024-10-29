//
//  ViewWithAsyncViewModelInit.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import SwiftUI

/// `ViewWithAsyncViewModelInit` is a SwiftUI view that handles the asynchronous
/// initialization of a view model and provides a flexible way to display different views
/// depending on the loading state. It displays a loading view initially and then renders
/// the content view once the view model has been asynchronously created.

struct ViewWithAsyncViewModelInit<ViewModel, LoadingView, Content>:
    View where Content: View, LoadingView: View {

    @State private var viewModel: ViewModel?
    let viewModelCreatingClosure: () async -> ViewModel
    @ViewBuilder let viewOnLoading: () -> LoadingView
    @ViewBuilder let viewWhenLoaded: (ViewModel) -> Content

    var body: some View {
        VStack {
            if let viewModel = viewModel {
                viewWhenLoaded(viewModel)
            } else {
                viewOnLoading()
                    .onAppear {
                        Task(priority: .userInitiated) {
                            guard self.viewModel == nil else { return }
                            self.viewModel = await viewModelCreatingClosure()
                        }
                    }
            }
        }
    }
}
