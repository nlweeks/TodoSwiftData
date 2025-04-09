//
//  TodoSwiftDataApp.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import SwiftUI

@main
struct TodoSwiftDataApp: App {
    let modelContainer = DataSource.shared.modelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
