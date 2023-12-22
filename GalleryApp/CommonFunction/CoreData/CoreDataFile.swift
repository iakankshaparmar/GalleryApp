//
//  CoreDataFile.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 21/12/23.
//

import Foundation
import CoreData

class CoreDataFunc{
    
    static let shared = CoreDataFunc()
    
    let context = ContextConstant.context
    let persistentContainer = ContextConstant.persistentContainer
    
    func save(){
        do{
            try self.context.save()
            print("Save data")
        }catch{
            print("Errror when saving item")
        }
    }
    
    func  fetchDataFromDB(_ modelName:String) -> [NSFetchRequestResult]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        do {
            let fetchedResults = try context.fetch(fetchRequest) 
            return fetchedResults
        } catch {
            print("Fetch error: \(error)")
        }
        return [NSFetchRequestResult]()
    }
}
