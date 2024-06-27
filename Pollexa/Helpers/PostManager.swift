import Foundation

class PostManager {
    
    static let shared = PostManager()
    
    private init() {}
    
    func savePostInfo(postId: String, optionCount1: Int, optionCount2: Int, totalVotes: Int, isLiked: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(optionCount1, forKey: "\(postId)_optionCount1")
        defaults.set(optionCount2, forKey: "\(postId)_optionCount2")
        defaults.set(totalVotes, forKey: "\(postId)_totalVotes")
        defaults.set(isLiked, forKey: "\(postId)_isLiked")
    }
    
    func getPostInfo(postId: String) -> (optionCount1: Int, optionCount2: Int, totalVotes: Int, isLiked : Bool)? {
        let defaults = UserDefaults.standard
        guard let optionCount1 = defaults.value(forKey: "\(postId)_optionCount1") as? Int,
              let optionCount2 = defaults.value(forKey: "\(postId)_optionCount2") as? Int,
              let totalVotes = defaults.value(forKey: "\(postId)_totalVotes") as? Int,
              let isLiked = defaults.value(forKey: "\(postId)_isLiked") as? Bool else {
            return nil
        }
        return (optionCount1, optionCount2, totalVotes,isLiked)
    }
}
