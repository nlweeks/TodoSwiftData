//
//  ContentView.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var selection = Set<Todo>()
    @State private var todoCount = 0
    @State private var showAddTodo: Bool = false
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        NavigationStack {
            TodoListView(selection: $selection,
                         todoCount: $todoCount,
                         searchText: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                        .disabled(todoCount == 0)
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        Button {
                            showAddTodo = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                    }
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
