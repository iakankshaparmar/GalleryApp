//
//  CommonConstants.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 21/12/23.
//
import UIKit

var isApiCallOneTime = false

struct UserDefaultKeyStringConstant {
    static var apiCallOneTime = "apiCallOneTime"
}

struct ContextConstant {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
}

struct DBTablesName{
    static let image = "Image"
}
