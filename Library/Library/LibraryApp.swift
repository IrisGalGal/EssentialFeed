//
//  LibraryApp.swift
//  Library
//
//  Created by IrisDarka on 18/01/23.
//

import SwiftUI

@main
struct LibraryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BookModel())
        }
    }
}
