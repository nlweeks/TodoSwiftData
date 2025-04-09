//
//  DataSource.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import Foundation
import SwiftUI
import SwiftData

actor DataSource {
    static let shared = DataSource()
    
    nonisolated let modelContainer: ModelContainer
    
    private init () {
        do {
            self.modelContainer = try ModelContainer(for: Todo.self)
        } catch {
            fatalError("Failed to initialize model container: \(error.localizedDescription)")
        }
    }
}
