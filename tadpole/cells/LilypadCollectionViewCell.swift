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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5.0
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 3.0, height: 5.0)
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.masksToBounds = false
        contentView.layer.borderColor = Colors.main.cgColor
        contentView.layer.borderWidth = 4.0
        
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.font = UIFont(name: "Comfortaa-Bold", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = Colors.main
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        
        subtitleTextView = UITextView()
        subtitleTextView.translatesAutoresizingMaskIntoConstraints = false
        subtitleTextView.textAlignment = .left
        subtitleTextView.text = ""
        subtitleTextView.isEditable = false
        subtitleTextView.isScrollEnabled = false
        subtitleTextView.font = UIFont(name: "Comfortaa-Regular", size: 15)
//        subtitleTextView.backgroundColor = UIColor.red
        contentView.addSubview(subtitleTextView)
        
        
        posterLabel = UILabel()
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.font = UIFont(name: "Comfortaa-Regular", size: 15)
        posterLabel.textColor = .gray
        posterLabel.textAlignment = .center
//        posterLabel.backgroundColor = .blue
        contentView.addSubview(posterLabel)
        
        
        
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * Constants.horizontalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -35)
            ])
        
        NSLayoutConstraint.activate([
            posterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            posterLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            posterLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            posterLabel.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        NSLayoutConstraint.activate([
            subtitleTextView.topAnchor.constraint(equalTo: posterLabel.bottomAnchor, constant: Constants.verticalPadding),
            subtitleTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1 * Constants.verticalPadding)
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
