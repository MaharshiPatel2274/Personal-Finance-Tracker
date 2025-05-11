//
//  Homework2App.swift
//  Homework2
//
//  Created by mpate125 on 4/3/25.
//

import SwiftUI
import SwiftData

@main
struct Homework2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: FinanceEntry.self)
        }
    }
}

