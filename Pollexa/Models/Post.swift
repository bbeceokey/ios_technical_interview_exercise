//
//  Post.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

public struct Post: Decodable {
    
    // MARK: - Properties
    let id: String
    let createdAt: Date
    let content: String
    var isLiked: Bool
    var likedCount: Int
    var options: [Option]
    
    let user: User?
        
    init(id: String, createdAt: Date, content: String, isLiked: Bool = false, likedCount: Int = 0, options: [Option],  user: User?) {
        self.id = id
        self.createdAt = createdAt
        self.content = content
        self.isLiked = isLiked
        self.likedCount = likedCount
        self.options = options
        self.user = user
    }
}

