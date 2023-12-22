//
//  ViewController.swift
//  GalleryApp
//
//  Created by Akanksha Parmar on 22/12/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    static let identifier = "HomeViewController"
    
    var photoArray = [Image]()
    
    @IBOutlet weak var imageTableView:UITableView!{
        didSet{
            imageTableView.delegate = self
            imageTableView.dataSource = self
            imageTableView.register(UINib(nibName: ImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageTableViewCell.identifier)
        }
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        callAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func callAPI(){
        UserDefaultClass.shared.getIsApiCallOneTime()
        print(isApiCallOneTime)
        if !isApiCallOneTime {
            activityIndicator.startAnimating()
            APICall.shared.makeAPICall { result in
                switch result{
                case.success(let data):
                        APICall.shared.saveImage(data){_ in
                            UserDefaults.standard.set(true, forKey: UserDefaultKeyStringConstant.apiCallOneTime)
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.fetchData()
                                self.imageTableView.reloadData()
                            }
                        }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchData(){
        photoArray.removeAll()
        photoArray = CoreDataFunc.shared.fetchDataFromDB(DBTablesName.image) as? [Image] ?? []
        DispatchQueue.main.async {
            self.imageTableView.reloadData()
        }
    }
    
    
    @IBAction func likedBtnPressed(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: LikeImageViewController.identifier) as! LikeImageViewController
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    
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


extension HomeViewController: PhotoDetailDelegate {
    
    func deletePhoto(_ p: Image) {
        CoreDataFunc.shared.context.delete(p)
        CoreDataFunc.shared.save()
        fetchData()
    }
    
    func saveToGallery() {
        
    }
    
}
