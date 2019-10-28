//
//  BrowseViewController.swift
//  tadpole
//
//  Created by Michael Behrens on 7/23/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit


class BrowseViewController: UIViewController {
    
    
    var lilypads = [Lilypad]()
    let lilypadReuse = "lilypadreuse"
    var lilypadsCollectionView: UICollectionView!
    var lilypadsFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationItem.title = "browse"
        view.backgroundColor = .white
        
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.main,
             NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .bold)]
        
        
        
        
        
    
        setupCollectionViewItems()
        setupConstraints()
        fetchLilypads()
    }
    
    
    
    
    func fetchLilypads() {
        DatabaseManager.getLilypadInfo { (info) in
            if let info = info {
                DatabaseManager.getLilypads(info: info) { (gotLilys) in
                    if gotLilys {
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
        
        let l1 = Lilypad(title: "first", subtitle: "subtitle1subtitle1subtitle1subtitle1subtitle1", poster: "poster1")
        let l2 = Lilypad(title: "second", subtitle: "2222222", poster: "p2")
        let l3 = Lilypad(title: "third", subtitle: "acbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzacbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzacbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzacbdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz", poster: "p3")
        let l4 = Lilypad(title: "reallylongtitlethiswilloverflow", subtitle: "sub", poster: "p4")
        
        lilypads.append(l1)
        lilypads.append(l2)
        lilypads.append(l3)
        lilypads.append(l4)
        lilypadsCollectionView.reloadData()
    }
    
    
    func setupCollectionViewItems() {
        lilypadsFlowLayout = UICollectionViewFlowLayout()
        lilypadsFlowLayout.scrollDirection = .vertical
        lilypadsFlowLayout.minimumLineSpacing = Constants.cellSpacing
        lilypadsFlowLayout.minimumInteritemSpacing = Constants.cellSpacing
        
        
        
        lilypadsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: lilypadsFlowLayout)
        lilypadsCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        lilypadsCollectionView.backgroundColor = Colors.lightGray
        lilypadsCollectionView.backgroundColor = .white
        lilypadsCollectionView.dataSource = self
        lilypadsCollectionView.delegate = self
        lilypadsCollectionView.register(LilypadCollectionViewCell.self, forCellWithReuseIdentifier: lilypadReuse)
        view.addSubview(lilypadsCollectionView)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            lilypadsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalPadding),
            lilypadsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lilypadsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lilypadsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1 * Constants.verticalPadding)
            ])
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
        let length = collectionView.frame.width - (2 * Constants.horizontalPadding)
        return CGSize(width: length, height: length * 0.6)
    }
}
