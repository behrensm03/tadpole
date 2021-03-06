//
//  AddLilypadViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 10/28/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

class AddLilypadViewController: UIViewController, UITextViewDelegate {
    
    var backButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    
    var titleField: UITextField!
    var subtitleView: UITextView!
    
    var nextButton: UIButton!
    
    var flowIndex = 0
    var fields: [AnyObject]!
    var bgs: [UIView]!
    var fieldBGView: UIView!
    var viewBGView: UIView!
    var subtitlePlaceholder: String!
    
    var topOfNextButton: CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.darkGray
        
        self.navigationItem.title = "new lilypad"
        
        self.navigationController!.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: Colors.main,
         NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)]
        
        backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = Colors.main
        
        setupNextButton()
        
        fieldBGView = UIView()
        fieldBGView.translatesAutoresizingMaskIntoConstraints = false
        fieldBGView.backgroundColor = Colors.main
        view.addSubview(fieldBGView)
        
        viewBGView = UIView()
        viewBGView.translatesAutoresizingMaskIntoConstraints = false
        viewBGView.backgroundColor = Colors.main
        viewBGView.isHidden = true
        view.addSubview(viewBGView)
        
        setupTextFields()
        setupConstraints()
        
    }
    
    func setupNextButton() {
        nextButton = Constants.buttonNoShadow(title: "next", isLargeSize: true)
        nextButton.addTarget(self, action: #selector(handleNextPress), for: .touchUpInside)
        view.addSubview(nextButton)
    }
    
    func submitNewLilypad() {
        let lily = Lilypad(title: titleField.text!, subtitle: subtitleView.text!, poster: System.currentUser!, latitude: System.currentLocation!.latitude, longitude: System.currentLocation!.longitude, numCheckins: 0)
        DatabaseManager.addLilypadForZone(lily: lily)
    }
    
    
    func incFlowIndex() {
        if (flowIndex >= fields.count - 1) {
            submitNewLilypad()
            backButtonTapped()
        } else {
            flowIndex += 1
        }
    }
    
    @objc func handleNextPress() {
        // hide current stuff
        if let f = fields[flowIndex] as? UITextField {
            f.isHidden = true
        } else if let f = fields[flowIndex] as? UITextView {
            f.isHidden = true
        }
        bgs[flowIndex].isHidden = true
        incFlowIndex()
        // show new stuff
        if let f = fields[flowIndex] as? UITextField {
            f.isHidden = false
        } else if let f = fields[flowIndex] as? UITextView {
            f.isHidden = false
        }
        bgs[flowIndex].isHidden = false
    }
    

    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            fieldBGView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1*view.frame.height/4),
            fieldBGView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            fieldBGView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * Constants.horizontalPadding),
            fieldBGView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            viewBGView.topAnchor.constraint(equalTo: fieldBGView.topAnchor),
            viewBGView.leadingAnchor.constraint(equalTo: fieldBGView.leadingAnchor),
            viewBGView.trailingAnchor.constraint(equalTo: fieldBGView.trailingAnchor),
            viewBGView.heightAnchor.constraint(equalToConstant: 102)
        ])

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: fieldBGView.topAnchor),
            titleField.leadingAnchor.constraint(equalTo: fieldBGView.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: fieldBGView.trailingAnchor),
            titleField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleField.topAnchor),
            subtitleView.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            subtitleView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 3 * Constants.verticalPadding),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: Constants.defaultButtonWidth),
            nextButton.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight)
        ])
    }
    
    
    func setupTextFields() {
        
        
        titleField = UITextField()
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.textColor = .white
        titleField.font = UIFont(name: "Comfortaa-Regular", size: 16)
        titleField.backgroundColor = Colors.darkGray
        let str = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        titleField.attributedPlaceholder = str
        
        
        subtitleView = UITextView()
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.textColor = .white
        subtitleView.backgroundColor = Colors.darkGray
        subtitleView.font = titleField.font
        subtitleView.delegate = self
        subtitleView.isHidden = true
        subtitlePlaceholder = "Enter a description."
        subtitleView.text = subtitlePlaceholder
        view.addSubview(subtitleView)
        
        fieldBGView.addSubview(titleField)
        fieldBGView.bringSubviewToFront(titleField)
        
        fields = [titleField, subtitleView]
        bgs = [fieldBGView, viewBGView]
        
        
    }
    
    
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }


    func checkValidLilypad() -> Bool {
//        if let t = titleField.text {
//            if let s = subtitleField.text {
//                return (t.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) != "" && s.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) != "")
//            }
//        }
        return false
    }
    
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if subtitleView.text == subtitlePlaceholder {
            subtitleView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if subtitleView.text == "" {
            subtitleView.text = subtitlePlaceholder
        }
    }
    

}





