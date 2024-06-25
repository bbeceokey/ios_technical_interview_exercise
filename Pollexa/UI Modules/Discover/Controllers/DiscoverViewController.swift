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
        viewModel.fetchPosts()
        //reloadData()
    }
    
    
    var posts = [Post]()
    
    override func viewWillAppear(_ animated: Bool) {
       
      
        print("çalıştı")
        
    }
    
    private func flowLayoutSet() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let flowWidth = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: flowWidth, height: 338)
        return flowLayout
    }

}

extension DiscoverViewController : UICollectionViewDelegate, UICollectionViewDataSource,DiscoverCollectionViewCellDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! DiscoverCollectionViewCell
        print("indexPath",indexPath)
                var postModel = viewModel.post(index: indexPath.row)
        cell.configurePostOwnerView(postModel: postModel!)
        cell.configurePostDetailView(modelPost: postModel!)
        print("postModel", postModel)
        if !postModel!.isLiked{
            cell.addLikeButtonToImage(imageView: cell.leftImage, atIndex: 0, optionId: postModel!.options[0].id, isLiked: postModel!.isLiked)
                    }
        if !postModel!.isLiked {
            cell.addLikeButtonToImage(imageView: cell.rightImage, atIndex: 1, optionId: postModel!.options[1].id, isLiked: postModel!.isLiked)
                    }
                    
                    cell.backgroundColor = .white
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.layer.zPosition = 1
                    cell.delegate = self
                 
                    // Set the delegate
                //reloadData()
                return cell
    }
    
    func likeButtonTappedOnImage(_ index: Int, optionId: String) {
        guard var postModel = viewModel.post(index: index) else { return }
        postModel.isLiked = true
        postModel.likedCount += 1
        viewModel.updatePost(postModel)
    }
    

}
        


    

