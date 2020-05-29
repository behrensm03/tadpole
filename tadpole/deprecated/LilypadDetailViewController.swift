//
//  LilypadDetailViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 1/4/20.
//  Copyright © 2020 Michael Behrens. All rights reserved.
//

import UIKit

class LilypadDetailViewController: UIViewController {
    
    var lilypad: Lilypad!
    weak var delegate: UpdateCommentsDelegate?
    
    var titleLabel: UILabel!
    var closeButton: UIBarButtonItem!
    
    func setLilypad(lilypad: Lilypad) {
        print(lilypad.toString())
        self.lilypad = lilypad
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.main
        
        titleLabel = UILabel()
        titleLabel.text = lilypad.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.main
        
        setupConstraints()
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalPadding),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    

    

}
