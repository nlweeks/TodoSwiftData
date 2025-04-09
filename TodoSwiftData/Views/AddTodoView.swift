//
//  AddTodoView.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var dueDate: Date? = nil
    
    private var dueDateBinding: Binding<Date> {
        Binding<Date>(
            get: { self.dueDate ?? Date() },
            set: { self.dueDate = $0 }
        )
    }
    
    
    var body: some View {
        Form {
            Section(header: Text("Todo Title")) {
                TextField("Enter a title", text: $title)
            }
            Section(header: Text("Todo Notes")) {
                TextField("Enter notes", text: $notes)
                
            }
            .opacity(notes.isEmpty ? 0.3 : 1)
            Section(header: Text("Due Date")) {
                DatePicker("Due Date", selection: dueDateBinding, displayedComponents: .date)
            }
            .opacity(dueDate == nil ? 0.3 : 1)
            
        }
        .navigationTitle(Text("Add Todo"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    addTodo()
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

extension AddTodoView {
    private func addTodo() {
        let todo = Todo(title: title, notes: notes, dueDate: dueDate)
        modelContext.insert(todo)
    }
}

#Preview {
    NavigationStack {
        AddTodoView()
    }
}
