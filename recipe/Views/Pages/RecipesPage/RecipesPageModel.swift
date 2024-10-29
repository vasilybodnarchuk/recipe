//
//  RecipesPageModel.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/24/24.
//

import Foundation
import Combine

final class RecipesPageModel {
    private(set) var pageRouter: any PageRouterable
    private let recipeService: RecipeServiceable
    private weak var imageService: ImageServiceable!

    private(set) var viewState = MainActorIsolatedValue<RecipesPageState>(value: .loading)
    private(set) var grouping = MainActorIsolatedValue<RecipesPageListGrouping>(value: .none)

    struct ImageRequest {
        let url: URL
        let viewId: String
    }

    init(pageRouter: any PageRouterable,
         recipeService: RecipeServiceable,
         imageService: ImageServiceable) {
        self.pageRouter = pageRouter
        self.recipeService = recipeService
        self.imageService = imageService

        Task { [weak self] in
            await self?._reloadRecipes()
        }
    }
}

// MARK: ObservableObject

extension RecipesPageModel: ObservableObject {}

// MARK: Data Loading

extension RecipesPageModel {

    func reloadRecipes() {
        Task { [weak self] in
            await self?.setLoadingViewState()
            // Delay to make smooth view reloading
            try? await Task.sleep(for: .milliseconds(300))
            await self?._reloadRecipes()
        }
    }

    private func _reloadRecipes() async {
        switch await recipeService.loadRecipes() {
        case let .success(data):
            if data.isEmpty {
                await update(viewState: .noData)
            } else {
                await update(viewState: .list(sections: sections(from: data)))
            }
        case let .failure(error):
            await update(viewState: .error(text: error.localizedDescription))
        }
    }
}

// MARK: Image Loading

extension RecipesPageModel {

    func getImageFor(viewId: String, imageURL: URL) {
        Task(priority: .background) {
            await self._getImageFor(viewId: viewId, imageURL: imageURL)
        }
    }

    private func _getImageFor(viewId: String, imageURL: URL) async {
        switch await imageService.uiImage(from: imageURL) {
        case let .success(uiImage):
            switch await viewState.value {
            case .loading, .error, .noData: return
            case let .list(sections):
                for section in sections {
                    switch section {
                    case let .regular(_, _, items):
                        for item in items {
                            switch item {
                            case let .recipe(recipeViewId, recipe):
                                if viewId == recipeViewId {
                                    recipe.imageStatus = .uiImage(uiImage)
                                    break
                                }
                            }
                        }
                    }
                }
            }
            await refreshPage()
        case .failure:
            break
        }
    }
}

// MARK: Section Calculations

private extension RecipesPageModel {
    typealias Section = RecipesPageState.List.Section
    typealias SectionItem = Section.Item

    func updateItemsBySections<Value: RecipeViewRepresentable>(with item: Value,
                                                               itemsBySections: inout [String: Node<SectionItem>],
                                                               grouping: RecipesPageListGrouping) {
        let listItem = SectionItem.recipe(recipe: .init(name: item.name,
                                                        cuisine: item.cuisine,
                                                        imageStatus: item.imageStatus))
        let sectionTitle = switch grouping {
        case .none: "All"
        case .byCuisineAscending: item.sectionTitle
        }

        if let node = itemsBySections[sectionTitle] {
            node.append(value: listItem)
        } else {
            itemsBySections[sectionTitle] = .init(value: listItem)
        }
    }

    func updateItemsBySections<Value: RecipeViewRepresentable>(with data: [Value],
                                                               itemsBySections: inout [String: Node<SectionItem>],
                                                               grouping: RecipesPageListGrouping) {
        data.forEach { item in
            updateItemsBySections(with: item, itemsBySections: &itemsBySections, grouping: grouping)
        }
    }

    func sections<Value: RecipeViewRepresentable>(from data: [Value]) async -> [Section] {
        var itemsBySections = [String: Node<SectionItem>]()
        updateItemsBySections(with: data,
                              itemsBySections: &itemsBySections,
                              grouping: await grouping.value)
        return await sections(from: &itemsBySections)
    }

    func sections(from sections: [Section]) async -> [Section] {
        let grouping = await grouping.value
        var itemsBySections = [String: Node<SectionItem>]()
        for section in sections {
            switch section {
            case let .regular(_, _, items):
                for item in items {
                    switch item {
                    case let .recipe(_, recipe):
                        updateItemsBySections(with: recipe,
                                              itemsBySections: &itemsBySections,
                                              grouping: grouping)
                    }

                }
            }
        }
        return await self.sections(from: &itemsBySections)
    }

    func sections(from itemsBySections: inout [String: Node<SectionItem>]) async -> [RecipesPageState.List.Section] {
        itemsBySections.keys.sorted().compactMap { sectionTitle in
            guard let sectionItems = itemsBySections[sectionTitle] else { return nil }
            let items = sectionItems.toArray().sorted {
                switch ($0, $1) {
                case let (.recipe(_, recipe1), .recipe(_, recipe2)):
                    recipe1.name < recipe2.name
                }
            }
            return .regular(title: sectionTitle, items: items)
        }
    }
}

// MARK: View Update

private extension RecipesPageModel {

    func setLoadingViewState() async {
        await update(viewState: .loading)
    }

    @MainActor func update(viewState: RecipesPageState) async {
        self.viewState.set(value: viewState)
        refreshPage()
    }

    @MainActor func refreshPage() {
        objectWillChange.send()
    }
}

// MARK: Grouping

extension RecipesPageModel {
    func changeGrouping() {
        Task {
            await _changeGrouping()
        }
    }

    private func _changeGrouping() async {
        await grouping.update { currentValue in
            .set(newValue: currentValue.next)
        }
        await refreshPage()

        switch await viewState.value {
        case .error, .loading, .noData: break
        case let .list(sections):
            await update(viewState: .list(sections: self.sections(from: sections)))
        }
    }

    private func reloadListSections() async {
        switch await viewState.value {
        case .error, .loading, .noData: break
        case let .list(sections):
            await update(viewState: .list(sections: self.sections(from: sections)))
        }
    }
}
