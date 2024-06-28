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
    func updatePost(_ post: Post)
    var posts: [Post] { get }
    func rangeLeftCalculate(model: Post) -> String
    func rangeRightCalculate(model: Post) -> String
    func indexPath(forIndex index: Int) -> IndexPath?
    func likedPostsCount() -> Int
}

final class DiscoverModelView {
    private let postProvider = PostProvider.shared
    private var internalPosts = [Post]() // Internal storage
        
    var posts: [Post] {
            get {
                return internalPosts
            }
            set {
                internalPosts = newValue
            }
        }
    
    var cell = DiscoverCollectionViewCell()
    weak var viewModelDelegate : ViewModelDelegate?
 
}

protocol ViewModelDelegate : AnyObject {
    func reloadData()
    
}

extension DiscoverModelView : DiscoverModelViewProtocol{
    
    func likedPostsCount() -> Int {
        var likedPostCount = 0
        for post in self.posts {
            if post.isLiked {
                likedPostCount += 1
            }
        }
        return likedPostCount
    }
    
    
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
    
    func indexPath(forIndex index: Int) -> IndexPath? {
        guard index < posts.count else { return nil }
        return IndexPath(item: index, section: 0)
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

    func rangeLeftCalculate(model: Post) -> String {
        let totalCount = model.likedCount
        let leftCount = model.options[0].optionCount
        let range = Float(leftCount) / Float(totalCount) * 100
        let formattedRange = String(format: "%.2f", range)
        return "%\(formattedRange)"
    }
    
    func rangeRightCalculate(model: Post) -> String{
        let totalCount = model.likedCount
        let rightCount = model.options[1].optionCount
        let range = Float(rightCount) / Float(totalCount) * 100
        let formattedRange = String(format: "%.2f", range)
        return "%\(formattedRange)"
    }

}
