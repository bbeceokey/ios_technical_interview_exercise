//
//  PostProvider.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import Foundation

class PostProvider {
    
    // MARK: - Properties
    static let shared = PostProvider(fileName: "posts")
    private let filename: String
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    // MARK: - Life Cycle
    private init(fileName: String) {
        self.filename = fileName
    }
    
    // MARK: - Methods
    func fetchAll(completion: (_ result: Result<[Post], Error>) -> Void) {
        guard let fileUrl = Bundle.main.url(
            forResource: filename,
            withExtension: "json"
        ) else {
            completion(.failure(
                NSError(
                    domain: "JSON file not found.",
                    code: 0
                )
            ))
            return
        }
        
        guard let postData = try? Data.init(contentsOf: fileUrl) else {
            completion(.failure(
                NSError(
                    domain: "Could not read the data.",
                    code: 1
                )
            ))
            return
        }
        
        do {
            var posts = try decoder.decode([Post].self, from: postData)
            
            for i in 0..<posts.count {
                var post = posts[i]
                var optionStates: [OptionState] = []
                
                       
                for optionData in post.options {
                    var option = OptionState(postID: post.id, optionID:optionData.id,isLiked: false, lastLikedDate: Date())
                            optionStates.append(option)
                        }
                        
                        post.optionsState = optionStates
                        posts[i] = post
                    }
                    
            completion(.success(posts))
        } catch {
            completion(.failure(error))
        }
    }
}
