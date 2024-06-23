//
//  DiscoverCollectionViewCell.swift
//  Pollexa
//
//  Created by Busra Ece on 21.06.2024.
//

import UIKit

protocol DiscoverCollectionViewCellDelegate: AnyObject {
    func likeButtonTappedOnImage(_ index: Int,optionId: String )
    
}


class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postOwnerView: UIView!
    @IBOutlet weak var postRelasedDate: UILabel!
    @IBOutlet weak var postOwnerName: UILabel!
    @IBOutlet weak var postOwnerPorfilImage: UIImageView!
    @IBOutlet weak var artBoardButton: UIButton!
    
    
    @IBOutlet weak var postDetailView: UIView!
    @IBOutlet weak var lastVoted: UILabel!
    @IBOutlet weak var postDetail: UITextField!
    @IBOutlet weak var stackImageView: UIStackView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var totalVotes: UILabel!
    
    var viewModel : DiscoverModelViewProtocol!

    weak var delegate: DiscoverCollectionViewCellDelegate?
    
    
    func configurePostOwnerView(postModel:Post) {
        postOwnerPorfilImage.image = postModel.user?.image
        postOwnerName.text = postModel.user?.username
        var date = "\(dateCalculate(model: postModel)) ago"
        postRelasedDate.text = date
        
        if date.contains("month"){
            artBoardButton.setImage(.artboard, for: .normal)
            artBoardButton.isHidden = false
        } else if date.contains("days"){
            artBoardButton.isHidden = true
        }
        
    }
    
    
    
    fileprivate func dateCalculate(model: Post) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var createdDate =  model.createdAt
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: createdDate, to: currentDate)

        if let months = components.month, months >= 1 {
            return "\(months) month\(months > 1 ? "s" : "")"
        } else {
            let days = calendar.dateComponents([.day], from: createdDate, to: currentDate).day ?? 0
            return "\(days) day\(days > 1 ? "s" : "") "
        }
     }
    
    func addLikeButtonToImage(imageView: UIImageView, atIndex index: Int, optionId: String, isLiked : Bool) {
        //imageView.subviews.forEach { $0.removeFromSuperview() }
        if !isLiked{
            let buttonSize: CGFloat = 40 
           
                        let xOffset: CGFloat = 10 // Adjust as needed
                        let yOffset: CGFloat = 60 /// Yuvarlak butonun genişliği ve yüksekliği
            let likeButton = UIButton(type: .custom)
            likeButton.setImage(UIImage(resource: .artboard), for: .normal)
            likeButton.frame = CGRect(x: xOffset, y: imageView.frame.height - buttonSize + 60, width: buttonSize, height: buttonSize)
            likeButton.layer.cornerRadius = buttonSize / 2
            likeButton.clipsToBounds = true
            likeButton.tintColor = .red
            likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
            imageView.addSubview(likeButton)
            imageView.isUserInteractionEnabled = true
            likeButton.tag = index
            likeButton.accessibilityIdentifier = optionId
        }
        
    }
    func hideAllButtons() {
           leftImage.subviews.compactMap { $0 as? UIButton }.first?.isHidden = true
           rightImage.subviews.compactMap { $0 as? UIButton }.first?.isHidden = true
       }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
            if let optionId = sender.accessibilityIdentifier {
                delegate?.likeButtonTappedOnImage(sender.tag,optionId: optionId)
                hideAllButtons()
                //updateLikeButtonState(for: sender.imageView!, optionId: optionId)
            }
        }


    func configurePostDetailView(modelPost: Post){
        
        postDetail.text = modelPost.content
        leftImage.image = modelPost.options[0].image
        rightImage.image = modelPost.options[1].image
        
        //updateLikeButtonState(for: rightImage, isLiked: modelPost.options[1].isLiked)
        //totalVotes.text = "\(viewModel.totalVoteCounts(modelPost: modelPost))"
        //label.text = modelPost.content
    }
    
    private func updateLikeButtonState(for imageView: UIImageView, optionId: String) {
        if let button = imageView.subviews.compactMap({ $0 as? UIButton }).first {
            button.isHidden = true
               }
        }
    
   
    
}
