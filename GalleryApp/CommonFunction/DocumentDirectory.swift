//
//  ImageCollectionViewCell.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 21/12/23.
//

import Foundation
import UIKit

class DocumentDirectoryClass{
    
    static let shared = DocumentDirectoryClass()
    private let fileManager = FileManager.default
    
    func loadImageFromDocumentDirectory(filname:String) -> UIImage? {
        guard let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let  filePath = tDocumentDirectory.appendingPathComponent("\(filname)")
        
        print("filePath",filePath)
        
        do{
            let imageData = try Data(contentsOf: filePath)
            let image = UIImage(data: imageData)
            return image
        }
        catch(let error){
            print("error:-",error)
            return nil
        }
    }
    
    func deleteFileDocumnetDirectory(_ url:URL){
        
        do {
            try fileManager.removeItem(at: url)
            print("Delete successfully")
        } catch {
            print(error.localizedDescription)
        }
    }
    

}
