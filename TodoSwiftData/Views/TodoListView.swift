//
//  TodoListView.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Todo.dueDate, order: .forward)
    var todos: [Todo]
    
    @Binding var selection: Todo?
    @Binding var todoCount: Int
    
    init(selection: Binding<Todo?>, todoCount: Binding<Int>, searchText: String) {
        let predicate = #Predicate<Todo> {
            searchText.isEmpty ? true : $0.title.contains(searchText)
        }
        _selection = selection
        _todoCount = todoCount
        _todos = Query(filter: predicate, sort: \Todo.dueDate)
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(todos) { todo in
                NavigationLink(value: todo, label: {
                    Text(todo.title)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteTodo(todo)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                })
            }
            .onDelete(perform: deleteTodos)
        }
        .navigationTitle("Todos")
        .onAppear {
            todoCount = todos.count
        }
        .onChange(of: todos) {
            todoCount = todos.count
        }
    }
}

extension TodoListView {
    private func deleteTodos(at offsets: IndexSet) {
        withAnimation {
            offsets.map { todos[$0] }.forEach(deleteTodo)
        }
    }
    
    private func deleteTodo(_ todo: Todo) {
        if todo.persistentModelID == todo.persistentModelID {
            selection = nil
        }
        modelContext.delete(todo)
    }
}
