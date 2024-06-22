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
    
    var viewModel : DiscoverModelViewProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    // MARK: - Properties
    private let postProvider = PostProvider.shared

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}

extension DiscoverViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "discoverCell", for: indexPath) as! DiscoverCollectionViewCell
        
        cell.configurePostDetailView(modelPost: viewModel.post(index: indexPath.row)!)
        
        cell.configurePostOwnerView(model: viewModel.post(index: indexPath.row)!.user, postModel: viewModel.post(index: indexPath.row)!)
        
        return cell
    }
    
    
}
