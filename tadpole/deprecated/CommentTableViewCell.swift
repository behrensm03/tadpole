//
//  CommentTableViewCell.swift
//  tadpole
//
//  Created by Michael Behrens on 5/23/20.
//  Copyright © 2020 Michael Behrens. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var commentLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.textColor = .black
        commentLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        commentLabel.textAlignment = .left
        commentLabel.numberOfLines = 4
        contentView.addSubview(commentLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            commentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            commentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * Constants.horizontalPadding)
        ])
    }
    
    func configure(for comment: Comment) {
        commentLabel.text = comment.body
    }
    
}
