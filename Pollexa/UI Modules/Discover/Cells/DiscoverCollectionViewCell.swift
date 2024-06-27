//
//  DiscoverCollectionViewCell.swift
//  Pollexa
//
//  Created by Busra Ece on 21.06.2024.
//

import UIKit

protocol DiscoverCollectionViewCellDelegate: AnyObject {
    func likeButtonTappedOnImage(_ index: Int, postId: String)
    
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
    
    private func setupImages() {
            
            let imageSize = CGSize(width: 130, height: 110)

            leftImage.frame.size = imageSize
            rightImage.frame.size = imageSize

            
        leftImage.contentMode = .scaleToFill
            rightImage.contentMode = .scaleToFill

           
            leftImage.clipsToBounds = true
            rightImage.clipsToBounds = true
        }
    
    private func setupProfileImage() {
        let imageSize = CGSize(width: 34, height: 37)
        postOwnerPorfilImage.frame.size = imageSize
        postOwnerPorfilImage.layer.cornerRadius = 10
        postOwnerPorfilImage.clipsToBounds = true
        postOwnerPorfilImage.contentMode = .scaleToFill
        }
    
    func configurePostOwnerView(postModel:Post) {
        setupProfileImage()
        postOwnerPorfilImage.image = postModel.user?.image
        postOwnerName.numberOfLines = 0
        postOwnerName.text = postModel.user?.username
        var date = "\(dateCalculate(model: postModel)) ago"
        postRelasedDate.numberOfLines = 0
        postRelasedDate.preferredMaxLayoutWidth = 200
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
    
    func addLikeButtonToImage(imageView: UIImageView, atIndex index: Int, postId: String, isLiked : Bool) {
        imageView.subviews.forEach { $0.removeFromSuperview() }
        if !isLiked{
            let buttonSize: CGFloat = 30
           
            let xOffset: CGFloat = 10 // Adjust as needed
            let yOffset: CGFloat = 60 /// Yuvarlak butonun genişliği ve yüksekliği
            let likeButton = UIButton(type: .custom)
            likeButton.setImage(UIImage(resource: .default), for: .normal)
            likeButton.frame = CGRect(x: xOffset, y: imageView.frame.height - buttonSize + 70, width: buttonSize, height: buttonSize)
            likeButton.layer.cornerRadius = buttonSize / 2
            likeButton.clipsToBounds = true
            likeButton.tintColor = .red
            likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
            imageView.addSubview(likeButton)
            imageView.isUserInteractionEnabled = true
            likeButton.tag = index // 0 ise sol 1 ise sağ
            likeButton.accessibilityIdentifier = postId
        }
        
    }
    
    func addLabelToImage(imageView: UIImageView, atIndex index: Int, postId: String, labelText: String, isHidden: Bool) {
        if imageView.subviews.contains(where: { $0 is UILabel }) { return }
        
        let buttonSize: CGFloat = 40
        let xOffset: CGFloat = 10 // Adjust as needed
        let yOffset: CGFloat = 60

        let label = UILabel()
        label.text = labelText
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 200
        label.textColor = .white
        label.textAlignment = .center
        label.frame = CGRect(x: xOffset, y: imageView.frame.height - buttonSize - 30, width: 250, height: buttonSize)
        label.layer.cornerRadius = buttonSize / 2
        label.clipsToBounds = true
        label.isHidden = isHidden
        imageView.addSubview(label)
        label.tag = index + 1000 // Use a different tag to distinguish from the button
        label.accessibilityIdentifier = postId
    }
    func hideAllButtons() {
           leftImage.subviews.compactMap { $0 as? UIButton }.first?.isHidden = true
           rightImage.subviews.compactMap { $0 as? UIButton }.first?.isHidden = true
    
       }
    
   
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        hideAllButtons()
            if let postId = sender.accessibilityIdentifier {
                delegate?.likeButtonTappedOnImage(sender.tag, postId: postId)
                
                
                //updateLikeButtonState(for: sender.imageView!, optionId: optionId)
            }
        }
    
    func updateUIForLikedState(_ postModel: Post) {
            if postModel.isLiked {
                hideAllButtons()
                addLabelToImage(imageView: leftImage, atIndex: 0, postId: postModel.id, labelText: viewModel.rangeLeftCalculate(model: postModel), isHidden: false)
                addLabelToImage(imageView: rightImage, atIndex: 1, postId: postModel.id, labelText: viewModel.rangeRightCalculate(model: postModel), isHidden: false)
            } else {
                addLikeButtonToImage(imageView: leftImage, atIndex: 0, postId: postModel.id, isLiked: postModel.isLiked)
                addLikeButtonToImage(imageView: rightImage, atIndex: 1, postId: postModel.id, isLiked: postModel.isLiked)
            }
        }
    


    func configurePostDetailView(modelPost: Post){
        setupImages()
        postDetail.text = modelPost.content
        leftImage.image = modelPost.options[0].image
        rightImage.image = modelPost.options[1].image
        totalVotes.text = "\(modelPost.likedCount)"
        totalVotes.numberOfLines = 0
    }
    
    
   
    
}
