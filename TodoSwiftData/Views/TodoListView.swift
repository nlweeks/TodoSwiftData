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
    
    @Binding var selection: Set<Todo>
    @Binding var todoCount: Int
    @FocusState private var focusedTodoID: PersistentIdentifier?
    
    @State private var newTodoTitle: String = ""
    @State private var newTodoNotes: String = ""
    
    init(selection: Binding<Set<Todo>>, todoCount: Binding<Int>, searchText: String) {
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
                TextField("Title", text: Bindable(todo).title)
                    .focused($focusedTodoID, equals: todo.persistentModelID)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteTodo(todo)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
//            .onDelete(perform: deleteTodos)
            TextField("New Todo", text: $newTodoTitle)
                .onSubmit {
                    addTodo()
                    newTodoNotes = ""
                    newTodoTitle = ""
                }
        }
        .environment(\.editMode, editMode)
        .listStyle(.insetGrouped)
        .navigationTitle("Todos")
        .overlay {
            if todos.isEmpty {
                ContentUnavailableView {
                    Label("No todos found", systemImage: "checkmark.circle")
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
        .onChange(of: editMode?.wrappedValue) { _, mode in
            if mode == .active {
                focusedTodoID = nil
            }
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
            selection = Set<Todo>()
        }
        modelContext.delete(todo)
    }
    
    private func addTodo() {
        let todo = Todo(title: newTodoTitle, notes: newTodoNotes)
        modelContext.insert(todo)
    }
}
