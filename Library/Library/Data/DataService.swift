//
//  DataService.swift
//  Library
//
//  Created by IrisDarka on 18/01/23.
//

import Foundation

class DataService{
    
    static func getDataService() ->[Book]{
        let pathString = Bundle.main.path(forResource: "Data", ofType: "json")
        guard pathString != nil else{
            return [Book]()
        }
        // Create a url object
        let url = URL(fileURLWithPath: pathString!)
        // Create a data object
        do{
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            do{
                let bookData = try decoder.decode([Book].self, from: data)
                for book in bookData{
                    book.uuid = UUID()
                }
                return bookData
            }catch{
                print(error)
            }
        }catch{
            print(error)
        }
        return [Book]()
    }
}
