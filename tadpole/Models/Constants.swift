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
    static let verticalPadding: CGFloat = 10
    static let imgViewDimension: CGFloat = 100
    static let horizontalPadding: CGFloat = 25
    static let minPadding: CGFloat = 5
    static let loadingScreenLogoDimension: CGFloat = 200
    static let cellSpacing: CGFloat = 25
    static let browseCellSpacing: CGFloat = 5
    static let userImgDimension: CGFloat = 50
    
    static let defaultButtonWidth: CGFloat = 250
    static let defaultButtonHeight: CGFloat = 50
    
    static let splashPowerProgressBarHeight: CGFloat = 20
    
    
    
    
    static let maxLilypadSubtitleLength = 119
    static let maxLilypadTitleLength = 21
    
    
    static func defaultButtonStyle(title: String) -> UIButton {
        
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        b.backgroundColor = Colors.main
        b.layer.cornerRadius = 25
        b.layer.shadowColor = UIColor.gray.cgColor
        b.layer.shadowOffset = CGSize(width: 5, height: 7)
        b.layer.shadowOpacity = 0.8
        b.layer.masksToBounds = false
        return b
    }
    
    static func buttonNoShadow(title: String) -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        b.backgroundColor = Colors.main
        b.layer.cornerRadius = 25
        b.layer.masksToBounds = false
        return b
    }
    
}
