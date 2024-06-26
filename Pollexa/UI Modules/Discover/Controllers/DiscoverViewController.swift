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
    
    @IBOutlet weak var activePoll: UILabel!
    
    @IBOutlet weak var seeDetails: UILabel!
    // MARK: - Properties
    private let postProvider = PostProvider.shared
    var viewModel: DiscoverModelViewProtocol = DiscoverModelView()
    
    let nib = UINib(nibName: "DiscoverCollectionViewCell", bundle: nil)
    
    func uiManaged(){
        postsGeneral.layer.cornerRadius = 5.0
        profilAvatar.layer.cornerRadius = 5.0
        seeDetails.sizeToFit()
        activePoll.text = "2 Poll Active"
        activePoll.numberOfLines = 0
        activePoll.preferredMaxLayoutWidth = 400
    }


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        uiManaged()
        viewModel.delegate? = self
        
        let flowLayout = flowLayoutSet()
        postsCollectionView.collectionViewLayout = flowLayout

        postsCollectionView.register(nib, forCellWithReuseIdentifier: "postCell")
        viewModel.fetchPosts()
        
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
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! DiscoverCollectionViewCell
           var postModel = viewModel.post(index: indexPath.row)!
           cell.delegate = self
           cell.viewModel = viewModel
           cell.configurePostOwnerView(postModel: postModel)
           cell.configurePostDetailView(modelPost: postModel)
           cell.backgroundColor = .white
           cell.layer.borderWidth = 1.0
           cell.layer.borderColor = UIColor.lightGray.cgColor
           cell.layer.zPosition = 1
           cell.updateUIForLikedState(postModel)
           return cell
       }
    
    
    func likeButtonTappedOnImage(_ index: Int, optionId: String) {
           if let indexPath = viewModel.indexPath(forIndex: index),
           let cell = postsCollectionView.cellForItem(at: indexPath) as? DiscoverCollectionViewCell {
            
            guard var postModel = viewModel.post(index: index) else { return }
            postModel.isLiked = true
            postModel.likedCount += 1
            
            if let optionIndex = postModel.options.firstIndex(where: { $0.id == optionId }) {
                postModel.options[optionIndex].optionCount += 1
            }
            
            viewModel.updatePost(postModel)
            cell.updateUIForLikedState(postModel)
        }
    }

}
        


    

