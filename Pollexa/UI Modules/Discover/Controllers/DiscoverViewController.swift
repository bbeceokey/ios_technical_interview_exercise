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


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: "postCell")
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self

        //reloadData()
    }
    
    
    var posts = [Post]()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchPosts()
        
    }
}

extension DiscoverViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! DiscoverCollectionViewCell
           
           let postModel = viewModel.post(index: indexPath.row)! // Optional unwrapping
           cell.configurePostDetailView(modelPost: postModel)
           
           return cell
    }
    
    
}
