//
//  TadpoleDetailView.swift
//  tadpole
//
//  Created by Michael Behrens on 5/16/20.
//  Copyright © 2020 Michael Behrens. All rights reserved.
//

import UIKit

class TadpoleDetailView {
    
    var view: UIView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var dismissButton: UIButton
    var posterLabel: UILabel
//    var commentsTableView: UITableView
    var checkinsLabel: UILabel
    var checkinsIcon: UIImageView
    
    var checkinButton: UIButton
    
    var commentsCollectionView: UICollectionView
    var reuse = "ReuseComment"
    
    var padding: CGFloat = 10
    
    init() {
        self.view = UIView()
        self.view.backgroundColor = .white
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = false
        
        self.titleLabel = UILabel()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = .center
//        self.titleLabel.backgroundColor = .red
        self.titleLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
        
        self.subtitleLabel = UILabel()
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleLabel.textAlignment = .left
        self.subtitleLabel.font = UIFont(name: "Comfortaa-Regular", size: 15)
        self.subtitleLabel.numberOfLines = 5
        
        self.posterLabel = UILabel()
        self.posterLabel.translatesAutoresizingMaskIntoConstraints = false
        self.posterLabel.textAlignment = .center
        self.posterLabel.font = UIFont(name: "Comfortaa-Light", size: 15)
//        self.posterLabel.backgroundColor = .gray
        self.posterLabel.textColor = Colors.main
        
        self.checkinsIcon = UIImageView()
        self.checkinsIcon.translatesAutoresizingMaskIntoConstraints = false
        self.checkinsIcon.image = UIImage(named: "map")
        
        self.checkinsLabel = UILabel()
        self.checkinsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.checkinsLabel.textAlignment = .left
        self.checkinsLabel.font = UIFont(name: "Comfortaa-Light", size: 15)
        self.checkinsLabel.textColor = Colors.darkGray
        
//        self.commentsTableView = UITableView()
//        self.commentsTableView.translatesAutoresizingMaskIntoConstraints = false
//        self.commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: self.reuse)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        self.commentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.commentsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.commentsCollectionView.backgroundColor = .white
        self.commentsCollectionView.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: self.reuse)
        view.addSubview(commentsCollectionView)
        
        self.dismissButton = Constants.buttonNoShadow(title: "dismiss", isLargeSize: true)
        
        self.checkinButton = Constants.buttonNoShadow(title: "check in", isLargeSize: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelsForLilypad(lily: Lilypad) {
        self.titleLabel.text = lily.title
        self.subtitleLabel.text = lily.subtitle
        self.posterLabel.text = "Posted By: \(lily.poster)"
        self.checkinsLabel.text = "\(lily.numCheckins)"
    }
    
    func getView() -> UIView {
        return self.view
    }
    
}
