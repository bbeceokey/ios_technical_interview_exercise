//
//  UICollectionViewCell.swift
//  Pollexa
//
//  Created by Busra Ece on 22.06.2024.
//


import UIKit

//MARK: self vs Self?? search

extension UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
