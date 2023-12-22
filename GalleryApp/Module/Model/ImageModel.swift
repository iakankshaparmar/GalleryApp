//
//  ImageModel.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 22/12/23.
//

import Foundation

// MARK: - Welcome
struct ImageModel: Codable {
    let success: Bool?
    let totalPhotos: Int?
    let message: String?
    let offset, limit: Int?
    let photos: [Photo]?

    enum CodingKeys: String, CodingKey {
        case success
        case totalPhotos = "total_photos"
        case message, offset, limit, photos
    }
}

// MARK: - Photo
struct Photo: Codable {
    let url: String?
    let title: String?
    let user: Int?
    let description: String?
    let id: Int?
}
