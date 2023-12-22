//
//  ImageDetailsViewController.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 22/12/23.
//

import UIKit
import Photos

protocol PhotoDetailDelegate{
    func deletePhoto(_ p:Image)
}

class ImageDetailsViewController: UIViewController {
    
    static let identifier = "ImageDetailsViewController"
    
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    var photo = Image()
     var delegate:PhotoDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.addShadow()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        
        imageName.text = photo.title
        if let url = URL(string: photo.imageURL ?? ""){
            let fileName = url.lastPathComponent
            let image = DocumentDirectoryClass.shared.loadImageFromDocumentDirectory(filname: fileName)
            profileImage.image = image
        }
        
    }
    
    @IBAction func backBtbPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteBtbPressed(_ sender: Any) {
        delegate?.deletePhoto(photo)
        showAlert("Delete", "Image deleted successfully")
    }
    
    @IBAction func saveToGalleryBtbPressed(_ sender: Any) {
        if let url = URL(string: photo.imageURL ?? ""){
            let fileName = url.lastPathComponent
            if let image = DocumentDirectoryClass.shared.loadImageFromDocumentDirectory(filname: fileName){
                checkPhotoLibraryPermission(image)
            }
        }
    }
    
    func checkPhotoLibraryPermission(_ image:UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Photo library access has been granted
            saveImageToLibrary(image)
        case .denied, .restricted:
            // Photo library access has been denied or restricted

            showPermissionAlert()
        case .notDetermined:
            // Request photo library access
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.saveImageToLibrary(image)
                    } else {
                        self?.showPermissionAlert()
                    }
                }
            }
        case .limited:
            print("Limited")
        @unknown default:
            fatalError("Unhandled case")
        }
    }

    func saveImageToLibrary(_ image:UIImage) {
        // Assuming you have an UIImage named "imageToSave"
        let imageToSave = image

        // Save the image to the photo library
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
       
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // If there was an error while saving the image
            print("Error saving image: \(error.localizedDescription)")
            showAlert("Error", "Image not save.")
        } else {
            // If the image was saved successfully
            print("Image saved successfully")
            showAlert("Success", "Image saved successfully")
        }
    }
    

    func showPermissionAlert() {
        let alert = UIAlertController(title: "Permission Required", message: "Please enable photo library access in Settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            // Open app settings
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ tittleString:String,_ message:String) {
           // Create the alert controller
           let alertController = UIAlertController(title: tittleString, message: message, preferredStyle: .alert)

           // Add an action button to the alert
           let okAction = UIAlertAction(title: "OK", style: .default) { _ in
               // Handle the OK button tap if needed
               print("OK ")
               if tittleString == "Success" || tittleString == "Delete"{
                   self.navigationController?.popViewController(animated: true)
               }
            
           }

           // Add the action to the alert controller
           alertController.addAction(okAction)

           // Present the alert controller
           present(alertController, animated: true, completion: nil)
       }

}
