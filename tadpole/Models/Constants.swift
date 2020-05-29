//
//  Constants.swift
//  tadpole
//
//  Created by Michael Behrens on 7/11/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit


class Constants {
    
    
    static let mapdist: Double = 10000
    
    // Padding
    static let verticalPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 25
    static let minPadding: CGFloat = 5
    
    
    // Image and Icon dimensions
    static let imgViewDimension: CGFloat = 100
    static let userImgDimension: CGFloat = 50
    static let commentImageViewDimension: CGFloat = 50
    static let loadingScreenLogoDimension: CGFloat = 200
    static let smallIconDimension: CGFloat = 25
    
    // Cell Spacing
    static let cellSpacing: CGFloat = 25
    static let browseCellSpacing: CGFloat = 5
    
    
    // Button sizing
    static let defaultButtonWidth: CGFloat = 250
    static let defaultButtonHeight: CGFloat = 50
    static let smallButtonHeight: CGFloat = 25
    static let smallButtonWidth: CGFloat = 100
    
    // Label sizing
    static let defaultLabelHeight: CGFloat = 50
    static let slimLabelHeight: CGFloat = 20
    
    // Text length
    static let maxLilypadSubtitleLength = 119
    static let maxLilypadTitleLength = 21
    
    
    static func defaultButtonStyle(title: String) -> UIButton {
        
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 20)
        b.backgroundColor = Colors.main
        b.layer.cornerRadius = 25
        b.layer.shadowColor = UIColor.gray.cgColor
        b.layer.shadowOffset = CGSize(width: 5, height: 7)
        b.layer.shadowOpacity = 0.8
        b.layer.masksToBounds = false
        return b
    }
    
    static func buttonNoShadow(title: String, isLargeSize: Bool) -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = Colors.main
        if isLargeSize {
            b.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 20)
            b.layer.cornerRadius = defaultButtonHeight / 2
        } else {
            b.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 15)
            b.layer.cornerRadius = smallButtonHeight / 2
        }
        b.layer.masksToBounds = false
        return b
    }
    
}
