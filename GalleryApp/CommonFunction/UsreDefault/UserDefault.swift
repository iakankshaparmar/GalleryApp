//
//  UserDefault.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 21/12/23.
//

import Foundation
class UserDefaultClass{
    
    static let shared = UserDefaultClass()
    
    func  getIsApiCallOneTime() {
        isApiCallOneTime = UserDefaults.standard.bool(forKey: UserDefaultKeyStringConstant.apiCallOneTime)
        print(isApiCallOneTime)
    }
    
}
