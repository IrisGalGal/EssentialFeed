//
//  Book.swift
//  Library
//
//  Created by IrisDarka on 18/01/23.
//

import Foundation
class Book: Identifiable, Decodable{
    var uuid: UUID?
    var title: String
    var author: String
    var isFavourite: Bool
    var currentPage: Int
    var rating: Int
    var id:Int
    var content: [String]
}
