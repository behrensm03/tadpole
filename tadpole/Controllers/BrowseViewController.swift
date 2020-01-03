//
//  BrowseViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 7/23/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class BrowseViewController: UIViewController {
    
    
    var lilypads = [Lilypad]()
    let lilypadReuse = "lilypadreuse"
    var lilypadsCollectionView: UICollectionView!
    var lilypadsFlowLayout: UICollectionViewFlowLayout!
    
    var newLilypadButton: UIBarButtonItem!
    
    let loadingIndiator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: Colors.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationItem.title = "browse"
        view.backgroundColor = .white
        
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.main,
             NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)]
        
        

        newLilypadButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLilypadButtonTapped))
        newLilypadButton.tintColor = Colors.main
        self.navigationItem.rightBarButtonItem = newLilypadButton
        
        
        loadingIndiator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndiator)
        
    
        setupCollectionViewItems()
        setupConstraints()
        view.bringSubviewToFront(loadingIndiator)
        loadingIndiator.startAnimating()
        fetchLilypads()
        
        
    }
    
    
    
    
    func fetchLilypads() {
        DatabaseManager.getLilypadInfo { (info) in
            if let info = info {
                DatabaseManager.getLilypads(info: info) { (gotLilys) in
                    if gotLilys {
                        self.loadingIndiator.stopAnimating()
                        DispatchQueue.main.async {
                            self.lilypadsCollectionView.reloadData()
                        }
                    } else {
                        fatalError()
                    }
                }
            } else {
                fatalError()
            }
        }
    }
    
    
    
    func hardCodeLilypads() {
        // some database stuff when it works
        
//        let l1 = Lilypad(title: "first", subtitle: "subtitle1subtitle1subtitle1subtitle1subtitle1", poster: "poster1")
//        let l2 = Lilypad(title: "second", subtitle: "2222222", poster: "p2")
//        let l3 = Lilypad(title: "third", subtitle: "acbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzacbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzacbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzacbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz", poster: "p3")
//        let l4 = Lilypad(title: "reallylongtitlethiswilloverflow", subtitle: "sub", poster: "p4")
        
//        lilypads.append(l1)
//        lilypads.append(l2)
//        lilypads.append(l3)
//        lilypads.append(l4)
//        lilypadsCollectionView.reloadData()
    }
    
    
    func setupCollectionViewItems() {
        lilypadsFlowLayout = UICollectionViewFlowLayout()
        lilypadsFlowLayout.scrollDirection = .vertical
//        lilypadsFlowLayout.minimumLineSpacing = Constants.cellSpacing
        lilypadsFlowLayout.minimumLineSpacing = 0
//        lilypadsFlowLayout.minimumInteritemSpacing = Constants.cellSpacing
        lilypadsFlowLayout.minimumInteritemSpacing = 0
        lilypadsFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        
        
        lilypadsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: lilypadsFlowLayout)
        lilypadsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lilypadsCollectionView.backgroundColor = .white
        lilypadsCollectionView.dataSource = self
        lilypadsCollectionView.delegate = self
        lilypadsCollectionView.register(LilypadCollectionViewCell.self, forCellWithReuseIdentifier: lilypadReuse)
        view.addSubview(lilypadsCollectionView)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            lilypadsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lilypadsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lilypadsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lilypadsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            loadingIndiator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndiator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndiator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndiator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func addLilypadButtonTapped() {
        let addLilypadController = AddLilypadViewController()
        self.navigationController?.pushViewController(addLilypadController, animated: true)
    }
    
    
    
    
    
    
    
    
}




extension BrowseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return System.lilypads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lilypadReuse, for: indexPath) as! LilypadCollectionViewCell
        let lilypad = System.lilypads[indexPath.item]
        cell.configure(for: lilypad)
        return cell
    }
}


extension BrowseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension BrowseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let length = collectionView.frame.width - (2 * Constants.horizontalPadding)
//        return CGSize(width: length, height: length * 0.6)
        let length = collectionView.frame.width
        return CGSize(width: length, height: 0.35 * length)
    }
}
