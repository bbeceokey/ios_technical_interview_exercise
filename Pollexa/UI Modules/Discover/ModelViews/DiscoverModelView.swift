//
//  DiscoverModelView.swift
//  Pollexa
//
//  Created by Busra Ece on 21.06.2024.
//

import Foundation


protocol DiscoverModelViewProtocol {
    func fetchPosts()
    var delegate: ViewModelDelegate? { get set }
    var numberOfItems : Int { get }
    func post(index: Int) -> Post?
    func likedPostState(model : inout OptionState)
    //func rangeCalculate(model: Post, optionID: String) -> String
    //func totalVoteCounts(modelPost: Post) -> Int
    func updatePost(_ post: Post)
    var posts: [Post] { get }
}

final class DiscoverModelView {
    private let postProvider = PostProvider.shared
    private(set) var posts = [Post]()
    
    var cell = DiscoverCollectionViewCell()
    weak var viewModelDelegate : ViewModelDelegate?
    
    
    
}

protocol ViewModelDelegate : AnyObject {
    func reloadData()
    
}

extension DiscoverModelView : DiscoverModelViewProtocol{
    
    func updatePost(_ post: Post) {
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index] = post
                print(post.options)
            }
        }
    
    func fetchPosts()  {
        postProvider.fetchAll { result in
            switch result {
            case .success(let decodeData):
                self.posts = decodeData
                
                self.delegate?.reloadData()
                print(posts)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        
    }
    
    
    var delegate: ViewModelDelegate? {
            get {
                return viewModelDelegate
            }
            set {
                viewModelDelegate = newValue
            }
        }
    
    
    var numberOfItems: Int {
        posts.count
    }
    
    func post(index: Int) -> Post? {
        posts[index]
    }
    
    func likedPostState( model : inout OptionState) {
        model.like()
    }
    
    /*func rangeCalculate(model: Post, optionID: String) -> String {
        let total = totalVoteCounts(modelPost: model)
        var voteCount = 0
        
        for option in model.options {
            if option.id == optionID {
                voteCount = OptionState.voteCount
            }
        }
        
        let range = voteCount % total * 100
        return  "%\(range)"
        
    }*/
    
    /*func totalVoteCounts(modelPost: Post) -> Int {
         var total = 0
         for option in modelPost.optionsState! {
             let voteC = OptionState.voteCount
             total += voteC
         }
         return total
     }*/
    
    
    
    
    
}
