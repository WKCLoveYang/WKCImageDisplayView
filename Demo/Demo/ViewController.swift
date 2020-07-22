//
//  ViewController.swift
//  Demo
//
//  Created by wkcloveYang on 2020/7/21.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CollectionViewCell.itemSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundView = nil
        view.backgroundColor = nil
        view.delegate = self
        view.dataSource = self
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CollectionViewCell.classForCoder()))
        return view
    }()

    
    private var dataSource: [WKCImageDisplayView.Direction] = [
    .appearTopToBottom,
    .appearBottomToTop,
    .appearLeftToRight,
    .appearRightToLeft,
    .disappearTopToBottom,
    .disappearBottomToTop,
    .disappearLeftToRight,
    .disappearRightToLeft
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CollectionViewCell.classForCoder()), for: indexPath) as! CollectionViewCell
        cell.directin = dataSource[indexPath.row]
        cell.startDisplay(delay: TimeInterval(indexPath.row))
        return cell
    }
}

