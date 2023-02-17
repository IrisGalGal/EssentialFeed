//
//  ContentView.swift
//  Library
//
//  Created by IrisDarka on 18/01/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model:BookModel
    var body: some View {
        NavigationView{
            VStack{
                Text("All Recipes")
                    .bold()
                    .font(.title)
            }
            ScrollView{
                LazyVStack{
                    ForEach(model.books){ book in
                        VStack{
                            Text(book.title)
                                .font(.headline)
                            Text(book.author)
                                .font(.title3)
                            Image("cover\(book.id)")
                        }
                    }
                }
            }
        }
        .environmentObject(BookModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
