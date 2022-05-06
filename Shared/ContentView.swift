//
//  ContentView.swift
//  Shared
//
//  Created by KET on 03/05/2022.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Tasky")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
