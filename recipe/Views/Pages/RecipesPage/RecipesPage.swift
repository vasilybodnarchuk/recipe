//
//  RecipesPage.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import SwiftUI

/// `RecipesPage` is a SwiftUI view that displays a list of recipes

struct RecipesPage: View {
    @StateObject var pageModel: RecipesPageModel

    var body: some View {
        NavigationView {
            List {
                switch pageModel.viewState.value {
                case let .loading(viewId):
                    renderLoadingState()
                        .id(viewId)
                case let .error(viewId, text):
                    render(errorText: text)
                        .id(viewId)
                case let .list(sections):
                    renderList(sections: sections)
                case .noData:
                    renderNoDataState()
                }
            }
            .refreshable { [weak pageModel] in
                pageModel?.reloadRecipes()
            }
            .toolbar {
                Button { [weak pageModel] in
                    pageModel?.changeGrouping()
                } label: { [weak pageModel] in
                    if let grouping = pageModel?.grouping.value {
                        Image(systemName: grouping.iconSystemImageName)
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationTitle(Text("Recipes"))
        }
    }
}

// MARK: Render Views

private extension RecipesPage {

    @ViewBuilder func renderLoadingState() -> some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    @ViewBuilder func renderNoDataState() -> some View {
        HStack {
            Spacer()
            VStack {
                Text("No Data")
                    .fontWeight(.bold)
                Spacer()
                renderReloadButton()
            }
            Spacer()

        }
        .padding()
    }

    @ViewBuilder func render(errorText: String) -> some View {
        VStack {
            Text("ERROR")
                .fontWeight(.bold)
            Text(errorText)
                .multilineTextAlignment(.center)
                .padding(16)
            renderReloadButton()
        }
        .padding()
    }

    @ViewBuilder func renderReloadButton() -> some View {
        Button("Reload") { [weak pageModel] in
            pageModel?.reloadRecipes()
        }
    }
}

// MARK: Render List

private extension RecipesPage {

    @ViewBuilder func renderList(sections: [RecipesPageState.List.Section]) -> some View {
        ForEach(sections) { section in
            switch section {
            case let .regular(_, title, items):
                Section(title) {
                    renderList(items: items)
                }
            }
        }
    }

    @ViewBuilder func renderList(items: [RecipesPageState.List.Section.Item]) -> some View {
        ForEach(items) { item in
            switch item {
            case let .recipe(viewId, recipe):
                render(recipe: recipe, viewId: viewId)
            }
        }
    }

    @ViewBuilder func render(recipe: RecipesPageState.List.Section.Item.Recipe,
                             viewId: String) -> some View {
        HStack {
            switch recipe.imageStatus {
            case .doesNotExist: EmptyView()
            case let .needToLoad(url):
                ProgressView()
                    .onAppear { [weak pageModel] in
                        pageModel?.getImageFor(viewId: viewId, imageURL: url)
                    }
            case let .uiImage(uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(recipe.name)
                HStack {
                    Text("Cuisine:")
                        .foregroundStyle(.gray)
                        .fontWeight(.light)
                    Text(recipe.cuisine)
                }
            }
        }
    }
}

// MARK: Preview

#Preview {
    final class TestViewModel: ObservableObject {
        private let factory: Factoryable = Factory()
        @Published private(set) var pageModal: RecipesPageModel?

        func setup() async {
            pageModal = await RecipesPageModel(pageRouter: factory.pageRouter,
                                               recipeService: factory.serviceFactory.getRecipeService(),
                                               imageService: factory.serviceFactory.getImageService())
            objectWillChange.send()
        }
    }

    struct TestView: View {
        @StateObject private var viewModel = TestViewModel()

        var body: some View {
            if let pageModal = viewModel.pageModal {
                RecipesPage(pageModel: pageModal)
            } else {
                ProgressView()
                    .task { [weak viewModel] in
                        await viewModel?.setup()
                    }
            }
        }
    }

    return TestView()
}
