//
//  ContentView.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var selection: Todo?
    @State private var todoCount = 0
    @State private var showAddTodo: Bool = false
    
    var body: some View {
        NavigationSplitView {
            TodoListView(selection: $selection,
                         todoCount: $todoCount,
                         searchText: searchText)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                            .disabled(todoCount == 0)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddTodo = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        } detail: {
            if let selection {
                NavigationStack {
                    TodoDetailView(todo: selection)
                }
            }
        }
        .searchable(text: $searchText, placement: .sidebar)
        .sheet(isPresented: $showAddTodo) {
            NavigationStack {
                AddTodoView()
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
