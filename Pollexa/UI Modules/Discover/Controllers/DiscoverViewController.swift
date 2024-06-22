//
//  DiscoverViewController.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

class DiscoverViewController: UIViewController, ViewModelDelegate {
    func reloadData() {
        postsCollectionView.reloadData()
    }
    

    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var postsGeneral: UIView!
    @IBOutlet weak var postAddedBtn: UIButton!
    @IBOutlet weak var profilAvatar: UIImageView!
    
   
    // MARK: - Properties
    private let postProvider = PostProvider.shared
    var viewModel: DiscoverModelViewProtocol = DiscoverModelView()
    
    let nib = UINib(nibName: "DiscoverCollectionViewCell", bundle: nil)


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        let flowLayout = flowLayoutSet()
        postsCollectionView.collectionViewLayout = flowLayout

        postsCollectionView.register(nib, forCellWithReuseIdentifier: "postCell")
        reloadData()
    }
    
    
    var posts = [Post]()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchPosts()
        
    }
    
    private func flowLayoutSet() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let flowWidth = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: flowWidth, height: 338)
        return flowLayout
    }

}

extension DiscoverViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! DiscoverCollectionViewCell
        let postModel = viewModel.post(index: indexPath.row)! // Optional unwrapping
        cell.configurePostOwnerView(postModel: postModel)
        cell.configurePostDetailView(modelPost: postModel)
        cell.backgroundColor = .white  // Hücre arka plan rengini beyaz yapın veya ihtiyacınıza göre ayarlayın
        cell.layer.borderWidth = 1.0  // Hücre kenar çizgisini ekleyin
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.zPosition = 1
        return cell
    }
    
    
}
