//
//  CollectionViewCell.swift
//  Demo
//
//  Created by wkcloveYang on 2020/7/21.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    static let itemSize: CGSize = CGSize(width: floor((UIScreen.main.bounds.width - 8) / 2.0), height: floor((UIScreen.main.bounds.width - 8) / 2.0))
    
    lazy var displayView: WKCImageDisplayView = {
        let view = WKCImageDisplayView(frame: CGRect(origin: .zero, size: CollectionViewCell.itemSize))
        view.duration = 0.3
        view.options = .curveLinear
        view.progress = 1.0
        view.image = UIImage(named: "1.jpg")
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 16)
        return view
    }()
    
    var directin: WKCImageDisplayView.Direction = .appearTopToBottom {
        willSet {
            displayView.direction = newValue
            switch newValue {
                
            case .appearTopToBottom:
                label.text = "appearTopToBottom"
                
            case .appearBottomToTop:
                label.text = "appearBottomToTop"
               
            case .appearLeftToRight:
                label.text = "appearLeftToRight"
                
            case .appearRightToLeft:
                label.text = "appearRightToLeft"
                
            case .disappearTopToBottom:
                label.text = "disappearTopToBottom"
                
            case .disappearBottomToTop:
                label.text = "disappearBottomToTop"
            
            case .disappearLeftToRight:
                label.text = "disappearLeftToRight"
                
            case .disappearRightToLeft:
                label.text = "disappearRightToLeft"
                
            default: break
            }
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(displayView)
        contentView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
