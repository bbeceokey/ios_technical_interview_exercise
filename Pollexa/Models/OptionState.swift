//
//  LikedPost.swift
//  Pollexa
//
//  Created by Busra Ece on 22.06.2024.
//

import Foundation
  
struct OptionState : Decodable{
    let postID: String
    let optionID: String
    var isLiked: Bool = false
    private var lastLikedDate: Date?
    static var voteCount: Int = 0
    
    init(postID: String, optionID: String, isLiked: Bool = false, lastLikedDate: Date? = nil,voteCount: Int = 0) {
           self.postID = postID
           self.optionID = optionID
           self.isLiked = isLiked
           self.lastLikedDate = lastLikedDate
           OptionState.voteCount = voteCount
       }
    
    mutating func like() {
        isLiked = true
        lastLikedDate = Date()
        OptionState.voteCount += 1
    }
    
    func lastLikedDateString() -> String {
        guard let lastLikedDate = lastLikedDate else {
            return "Never liked"
        }
        
        return calculateTimeDifference(from: lastLikedDate)
    }
    
    private func calculateTimeDifference(from date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .month], from: date, to: Date())
        
        if let months = components.month, months > 0 {
            return "\(months) month\(months > 1 ? "s" : "") ago"
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days > 1 ? "s" : "") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes > 1 ? "s" : "") ago"
        } else if let seconds = components.second, seconds >= 0 {
            return "\(seconds) second\(seconds != 1 ? "s" : "") ago"
        } else {
            return "Just now"
        }
    }
}
