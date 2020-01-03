//
//  LilypadCollectionViewCell.swift
//  tadpole
//
//  Created by Michael Behrens on 9/12/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

class LilypadCollectionViewCell: UICollectionViewCell {
    
    
    var titleLabel: UILabel!
    var subtitleTextView: UITextView!
    var posterLabel: UILabel!
    var userImg: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 5.0
//        contentView.layer.shadowColor = UIColor.lightGray.cgColor
//        contentView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
//        contentView.layer.shadowRadius = 2.0
//        contentView.layer.shadowOpacity = 1.0
        contentView.layer.masksToBounds = false
//        contentView.layer.borderColor = Colors.main.cgColor
//        contentView.layer.borderWidth = 4.0
        
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1.0
        
        contentView.backgroundColor = Colors.main
        
        
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Comfortaa-Bold", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .bold)
//        titleLabel.textColor = Colors.main
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        
        subtitleTextView = UITextView()
        subtitleTextView.translatesAutoresizingMaskIntoConstraints = false
        subtitleTextView.textAlignment = .left
        subtitleTextView.text = ""
        subtitleTextView.isEditable = false
        subtitleTextView.isScrollEnabled = false
        subtitleTextView.font = UIFont(name: "Comfortaa-Regular", size: 15)
        subtitleTextView.textColor = .white
        subtitleTextView.backgroundColor = Colors.main
        contentView.addSubview(subtitleTextView)
        
        
        posterLabel = UILabel()
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.font = UIFont(name: "Comfortaa-Regular", size: 12)
//        posterLabel.textColor = .gray
        posterLabel.textColor = .black
        posterLabel.textAlignment = .center
        contentView.addSubview(posterLabel)
        
        userImg = UIImageView()
        userImg.translatesAutoresizingMaskIntoConstraints = false
        userImg.image = UIImage(named: "tadpoletemp")
        userImg.layer.cornerRadius = contentView.frame.height * 0.25
        userImg.clipsToBounds = true
        contentView.addSubview(userImg)
        
        
        setupConstraints()
        
        
    }
    
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            userImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height * 0.25),
            userImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            userImg.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.5),
            userImg.widthAnchor.constraint(equalTo: userImg.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            posterLabel.topAnchor.constraint(equalTo: userImg.bottomAnchor, constant: Constants.browseCellSpacing),
            posterLabel.centerXAnchor.constraint(equalTo: userImg.centerXAnchor),
            posterLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.browseCellSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: userImg.trailingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * Constants.horizontalPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: (contentView.frame.height * 0.25))
        ])
        
        NSLayoutConstraint.activate([
            subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.browseCellSpacing),
            subtitleTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1 * Constants.browseCellSpacing)
            ])
    }
    
    
    
    func configure(for lilypad: Lilypad) {
        titleLabel.text = lilypad.title
        subtitleTextView.text = lilypad.subtitle
        posterLabel.text = "@" + lilypad.poster
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
