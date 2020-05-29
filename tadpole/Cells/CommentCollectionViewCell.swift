//
//  CommentCollectionViewCell.swift
//  tadpole
//
//  Created by Michael Behrens on 5/24/20.
//  Copyright © 2020 Michael Behrens. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    var posterImg: UIImageView!
    var usernameLabel: UILabel!
    var commentContainerView: UIView!
    var commentTextView: UITextView!
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        
        // Image View to display the user's profile image
        posterImg = UIImageView()
        posterImg.translatesAutoresizingMaskIntoConstraints = false
        posterImg.image = UIImage(named: "tadpoletemp")
        posterImg.layer.cornerRadius = Constants.commentImageViewDimension / 2
        posterImg.clipsToBounds = true
        contentView.addSubview(posterImg)
        
        
        commentContainerView = UIView()
        commentContainerView.translatesAutoresizingMaskIntoConstraints = false
        commentContainerView.layer.cornerRadius = 12
        commentContainerView.layer.masksToBounds = false
        commentContainerView.backgroundColor = Colors.lightGray
        contentView.addSubview(commentContainerView)
        
        
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = UIFont(name: "Comfortaa-Bold", size: 15)
        usernameLabel.textColor = Colors.main
        usernameLabel.textAlignment = .left
        usernameLabel.backgroundColor = .clear
        contentView.addSubview(usernameLabel)
        
        
        
        commentTextView = UITextView()
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.font = UIFont(name: "Comfortaa-Regular", size: 15)
        commentTextView.textColor = .black
        commentTextView.textAlignment = .left
        commentTextView.isEditable = false
        commentTextView.backgroundColor = .clear
        contentView.addSubview(commentTextView)
        
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding),
            posterImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            posterImg.heightAnchor.constraint(equalToConstant: Constants.commentImageViewDimension),
            posterImg.widthAnchor.constraint(equalToConstant: Constants.commentImageViewDimension)
        ])
        
        NSLayoutConstraint.activate([
            commentContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding),
            commentContainerView.leadingAnchor.constraint(equalTo: posterImg.trailingAnchor, constant: Constants.horizontalPadding),
            commentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * Constants.horizontalPadding),
            commentContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: commentContainerView.topAnchor, constant: Constants.verticalPadding),
            usernameLabel.leadingAnchor.constraint(equalTo: commentContainerView.leadingAnchor, constant: Constants.verticalPadding),
            usernameLabel.trailingAnchor.constraint(equalTo: commentContainerView.trailingAnchor, constant: -1 * Constants.verticalPadding),
            usernameLabel.heightAnchor.constraint(equalToConstant: Constants.slimLabelHeight)
        ])
        
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: Constants.verticalPadding),
            commentTextView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            commentTextView.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            commentTextView.bottomAnchor.constraint(equalTo: commentContainerView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(for comment: Comment) {
        // MARK: configure user image when that feature is available
        usernameLabel.text = comment.poster
        commentTextView.text = comment.body
    }
    
}
