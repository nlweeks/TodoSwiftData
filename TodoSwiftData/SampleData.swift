//
//  SampleData.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import SwiftData
import SwiftUI

struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Todo.self,
            configurations: config
        )
        SampleData.createSampleData(into: container.mainContext)
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
          content.modelContainer(context)
    }
    
    static func createSampleData(into modelContext: ModelContext) {
        Task { @MainActor in
            let sampleDataTodo: [Todo] = Todo.sampleTodos
            let sampleData: [any PersistentModel] = sampleDataTodo
            sampleData.forEach {
                modelContext.insert($0)
            }
            
            try? modelContext.save()
        }
    }
}

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}

