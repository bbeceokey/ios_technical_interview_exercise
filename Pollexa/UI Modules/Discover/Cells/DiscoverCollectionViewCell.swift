//
//  DiscoverCollectionViewCell.swift
//  Pollexa
//
//  Created by Busra Ece on 21.06.2024.
//

import UIKit

protocol DiscoverCollectionViewCellDelegate: AnyObject {
    func likeButtonTappedOnImage(_ index: Int,optionId: String)
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
    
    func addLikeButtonToImage(imageView: UIImageView, atIndex index: Int, model: Post) {
        let buttonSize: CGFloat = 40 // Yuvarlak butonun genişliği ve yüksekliği
        let likeButton = UIButton(type: .custom)
        likeButton.setImage(UIImage(resource: .artboard), for: .normal)
        likeButton.frame = CGRect(x: imageView.frame.width - buttonSize, y: 0, width: buttonSize, height: buttonSize)
        likeButton.layer.cornerRadius = buttonSize / 2
        likeButton.clipsToBounds = true
        likeButton.tintColor = .red
        likeButton.addTarget(self, action: #selector(likeButtonTapped(_:optionId:)), for: .touchUpInside)
        imageView.addSubview(likeButton)
        imageView.isUserInteractionEnabled = true
        likeButton.tag = index
    }
    
    @objc func likeButtonTapped(_ sender: UIButton, optionId : String ) {
        // Delegate veya closure kullanarak bu tıklama olayını view controller'a iletebiliriz.
        delegate?.likeButtonTappedOnImage(sender.tag, optionId: optionId)
    }

    func configurePostDetailView(modelPost: Post){
        
        postDetail.text = modelPost.content
        leftImage.image = modelPost.options[0].image
        rightImage.image = modelPost.options[1].image
        //totalVotes.text = "\(viewModel.totalVoteCounts(modelPost: modelPost))"
        //label.text = modelPost.content
    }
    
   
    
}
