//
//  AppLoadingPage.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/23/24.
//

import SwiftUI

/// `AppLoadingPage` is a SwiftUI view that displays a loading indicator while the app is initializing.

struct AppLoadingPage: View {
    @StateObject var pageModel: AppLoadingPageModel

    var body: some View {
        ProgressView()
    }
}
