//
//  BookModel.swift
//  Library
//
//  Created by IrisDarka on 18/01/23.
//

import Foundation
class BookModel: ObservableObject{
    @Published var books = [Book]()
    init(){
        self.books = DataService.getDataService()
    }
}
