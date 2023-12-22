//
//  APICalling.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 21/12/23.
//

import Foundation
import UIKit
class APICall{
    
  static  let shared = APICall()

    func makeAPICall(completion: @escaping (Result<[Photo], Error>) -> Void) {
        // Replace "your_api_endpoint" with the actual API endpoint you want to call
        guard let apiURL = URL(string: "https://api.slingacademy.com/v1/sample-data/photos") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(ImageModel.self, from: data)
                print("Decoded Data: \(decodedData)")
                guard let data = decodedData.photos else{
                    return
                }
                completion(.success(data))

            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(.failure(error))
            }

        }

        task.resume()
    }
    
    func saveImage(_ photo:[Photo],completion: @escaping (Bool) -> Void){
        let dispatchGroup = DispatchGroup()
        for p in photo{
            dispatchGroup.enter()
            if let url = URL(string: p.url ?? ""){
                APICall.shared.saveImageFromURLToDocumentsDirectory(url: url,photo: p){ _ in
                    dispatchGroup.leave()
                }
            }
            else{
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(true)
        }
    }
    
    func saveImageFromURLToDocumentsDirectory(url: URL,photo:Photo,completion: @escaping (Bool) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                self.saveImageToDocumentsDirectory(image: image, photo: photo)
                completion(true)
            } else {
                let error = NSError(domain: "ImageDownloadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to download or convert image data"])
                completion(false)
            }
          
        }.resume()
    }

    func saveImageToDocumentsDirectory(image:UIImage,photo:Photo) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = Date().timeIntervalSince1970
            let fileURL = documentsDirectory.appendingPathComponent("\(fileName).png")
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try imageData.write(to: fileURL)
                    let newNode = Image(context: ContextConstant.context)
                    newNode.title = photo.title
                    newNode.isLiked = false
                    newNode.imageURL = fileURL.absoluteString
                    CoreDataFunc.shared.save()
                    print("Image saved successfully at: \(fileURL.path)")
                } catch {
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        }
    }

}
