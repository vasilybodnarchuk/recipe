//
//  CoreEvent.swift
//  recipe
//
//  Created by Vasily Bodnarchuk on 10/28/24.
//

import Foundation

/// The `CoreEvent` enum defines the types of events associated with the `Core` component.
/// These events encapsulate actions or states that `Core` can represent or trigger,
/// providing a structured way to categorize core-related events within the app.

enum CoreEvent {
    case routerEvent(RouterEvent)
}
