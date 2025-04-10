//
//  Todo.swift
//  TodoSwiftData
//
//  Created by Noah Weeks on 4/9/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Todo {
    #Index<Todo> ([\.title])
    #Unique<Todo> ([\.title])
    
    var title: String
    var notes: String?
    var completed: Bool = false
    var dueDate: Date?
    
    init(title: String, notes: String? = nil, dueDate: Date? = nil) {
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
    }
    
    var notesBinding: Binding<String> {
        Binding(
            get: { self.notes ?? "" },
            set: { self.notes = $0 }
        )
    }
}

extension Todo {
    static let sampleTodos: [Todo] = [
        Todo(
            title: "Buy groceries",
            notes: "Milk, eggs, bread, bananas",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())
        ),
        Todo(
            title: "Call mom",
            notes: "Wish her a happy birthday",
            dueDate: Calendar.current.date(byAdding: .hour, value: 5, to: Date())
        ),
        Todo(
            title: "Finish SwiftUI project",
            notes: "Work on layout and animations",
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())
        ),
        Todo(
            title: "Water the plants"
        ),
        Todo(
            title: "Schedule dentist appointment",
            notes: "Try to get an afternoon slot next week"
        ),
        Todo(
            title: "Submit timesheet",
            dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) // overdue
        ),
        Todo(
            title: "Workout",
            notes: "Focus on core and cardio",
            dueDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())
        ),
        Todo(
            title: "Read 'Atomic Habits'",
            notes: "Chapter 4 today",
            dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
        ),
        {
            let todo = Todo(title: "Clean the apartment")
            todo.completed = true
            return todo
        }(),
        {
            let todo = Todo(title: "Reply to client emails")
            todo.completed = true
            return todo
        }()
    ]
}
