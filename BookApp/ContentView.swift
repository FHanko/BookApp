//
//  ContentView.swift
//  BookApp
//
//  Created by user276637 on 4/30/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
