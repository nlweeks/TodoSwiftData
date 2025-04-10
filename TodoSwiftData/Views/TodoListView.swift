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
    @Environment(\.editMode) private var editMode
    
    @Query(sort: \Todo.dueDate, order: .forward)
    var todos: [Todo]
    
    @Binding var todoCount: Int
    @FocusState private var focusedTodoID: PersistentIdentifier?
    
    @State private var newTodoTitle: String = ""
    @State private var newTodoNotes: String = ""
    
    init(todoCount: Binding<Int>, searchText: String) {
        let predicate = #Predicate<Todo> {
            searchText.isEmpty ? true : $0.title.contains(searchText)
        }
        _todoCount = todoCount
        _todos = Query(filter: predicate, sort: \Todo.dueDate)
    }
    
    var body: some View {
        VStack {
            List() {
                ForEach(todos) { todo in
                    ListRow(todo: todo)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteTodo(todo)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.insetGrouped)
        }
        .environment(\.editMode, editMode)
        .navigationTitle("Todos")
        .overlay {
            if todos.isEmpty {
                ContentUnavailableView {
                    Label("Add new todo above", systemImage: "checkmark.circle")
                } description: {
                    Text("You're a doer. Add a todo and track your progress!")
                }
            }
        }
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
        modelContext.delete(todo)
    }
}

struct ListRow: View {
    @Bindable var todo: Todo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Title", text: $todo.title)
                .font(.body)
            TextField("Notes", text: todo.notesBinding)
                .font(.caption)
                .padding(.leading)
                .foregroundStyle(.secondary)
        }
        
    }
}

struct NewTodoRow: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newTodoTitle: String = ""
    @State private var newTodoNotes: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Title", text: $newTodoTitle)
                .font(.body)
            TextField("Notes", text: $newTodoNotes)
                .font(.caption)
                .padding(.leading)
                .foregroundStyle(.secondary)
        }
        .onSubmit {
            addTodo()
            newTodoNotes = ""
            newTodoTitle = ""
        }
    
    }
    
    private func addTodo() {
        let todo = Todo(title: newTodoTitle, notes: newTodoNotes)
        modelContext.insert(todo)
    }
}
