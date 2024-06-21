//
//  DiscoverModelView.swift
//  Pollexa
//
//  Created by Busra Ece on 21.06.2024.
//

import Foundation


protocol DiscoverModelViewProtocol {
    func fetchPosts() -> [Post]
    var delegate : ViewModelDelegate? { get set}
    var numberOfItems : Int { get }
    func post(index: Int) -> Post?
    func likedPostState(model : inout OptionState)
    func rangeCalculate(model: Post, optionID: String) -> String
    func totalVoteCounts(modelPost: Post) -> Int
}

final class DiscoverModelView {
    private let postProvider = PostProvider.shared
    var posts = [Post]()
    var cell = DiscoverCollectionViewCell()
    weak var viewModelDelegate : ViewModelDelegate?
}

protocol ViewModelDelegate : AnyObject {
    func reloadData()
    
}

extension DiscoverModelView : DiscoverModelViewProtocol{
    var delegate: (any ViewModelDelegate)? {
        get {
            <#code#>
        }
        set {
            <#code#>
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
    
    func rangeCalculate(model: Post, optionID: String) -> String {
        var total = totalVoteCounts(modelPost: model)
        var voteCount = 0
        var optionsState = model.optionsState
        
        for option in model.options {
            if option.id == optionID {
                voteCount = OptionState.voteCount
            }
        }
        
        var range = voteCount % total * 100
        return  "%\(range)"
        
    }
    
    func totalVoteCounts(modelPost: Post) -> Int {
         var total = 0
         for option in modelPost.optionsState {
             var voteC = OptionState.voteCount
             total += voteC
         }
         return total
     }
    
    
    func fetchPosts() -> [Post]  {
        postProvider.fetchAll { result in
            switch result {
            case .success(let posts):
                self.posts = posts
                print(posts)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        return posts
    }
    
    
}
