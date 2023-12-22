//
//  LikeImageViewController.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 22/12/23.
//

import UIKit

class LikeImageViewController: UIViewController{
    
    static let identifier = "LikeImageViewController"
    
    var photoArray = [Image]()
    
    @IBOutlet weak var imageTableView:UITableView!{
        didSet{
            imageTableView.delegate = self
            imageTableView.dataSource = self
            imageTableView.register(UINib(nibName: ImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageTableViewCell.identifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    

    @IBAction func backBtbPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchData(){
        photoArray.removeAll()
       let allPhotoArray = CoreDataFunc.shared.fetchDataFromDB(DBTablesName.image) as? [Image] ?? []
        photoArray = allPhotoArray.filter({$0.isLiked == true})
        DispatchQueue.main.async {
            self.imageTableView.reloadData()
        }
    }

}

extension LikeImageViewController: PhotoDetailDelegate {
    
        func deletePhoto(_ p: Image) {
            CoreDataFunc.shared.context.delete(p)
            CoreDataFunc.shared.save()
            fetchData()
        }
        
        func saveToGallery() {
            
        }
        
}

extension LikeImageViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        let p = photoArray[indexPath.row]
        cell.imageName.text = p.title
        if let url = URL(string: p.imageURL ?? ""){
            let fileName = url.lastPathComponent
            let image = DocumentDirectoryClass.shared.loadImageFromDocumentDirectory(filname: fileName)
            cell.profileImage.image = image
        }
        if p.isLiked{
            cell.likeImage.tintColor = .red
        }
        else{
            cell.likeImage.tintColor = .blue
        }
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(changeLikeBtn(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: ImageDetailsViewController.identifier) as! ImageDetailsViewController
        destinationVC.photo = photoArray[indexPath.row]
        destinationVC.delegate = self
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func changeLikeBtn(_ sender:UIButton){
        let node = photoArray[sender.tag]
        node.isLiked = !node.isLiked
        CoreDataFunc.shared.save()
        DispatchQueue.main.async {
            self.imageTableView.reloadData()
        }
     }

}
