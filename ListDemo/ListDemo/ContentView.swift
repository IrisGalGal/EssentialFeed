//
//  ContentView.swift
//  ListDemo
//
//  Created by IrisDarka on 04/01/23.
//

import SwiftUI

struct ContentView: View {
    var array = ["Element 1", "Element 2", "Element 3", "Element 4", "Element 5", "Element 6"]
    var body: some View {
        
        NavigationView{
            List(array, id: \.self){ arrayElement in
                NavigationLink(destination: Text("Destination")) {
                    Text(arrayElement)
                }
            }
            .navigationTitle("My List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
