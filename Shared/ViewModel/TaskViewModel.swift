//
//  TaskViewModel.swift
//  Tasky (iOS)
//
//  Created by KET on 03/05/2022.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    
    @Published var currentTab = "Today"
    
    @Published var openEditTask = false
    @Published var taskTitle = ""
    @Published var taskColor = "Yellow"
    @Published var taskDeadline = Date()
    @Published var taskType = "Basic"
    @Published var showDatePicker = false
    
    @Published var editTask: Task?
    
    var newTaskUnvalid: Bool {
        return taskTitle.isEmpty
    }
    
    func addTask(context: NSManagedObjectContext) -> Bool {
        let task = Task(context: context)
        
        task.id = UUID()
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    func editTask(context: NSManagedObjectContext) {
        var task: Task!
        if let editTask = editTask {
            task = editTask
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        try? context.save()
        editTask = nil
    }
    
    func resetTaskData() {
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
    
    func setupTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}
