//
//  CNU_LinkerApp.swift
//  CNU_Linker
//
//  Created by Kimyaehoon on 31/08/2021.
//

import SwiftUI

@main
struct CNU_LinkerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
//                .preferredColorScheme(.light)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
