//
//  TaskyApp.swift
//  Shared
//
//  Created by KET on 03/05/2022.
//

import SwiftUI

@main
struct TaskyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
