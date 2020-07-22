//
//  WKCImageDisplayView.swift
//  SwiftFuck
//
//  Created by wkcloveYang on 2020/7/21.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

import UIKit


@objc open class WKCImageDisplayView: UIView {
    
   @objc public enum Direction: Int {
        case appearTopToBottom    = 0
        case appearLeftToRight    = 1
        case appearBottomToTop    = 2
        case appearRightToLeft    = 3

        case disappearTopToBottom = 4
        case disappearBottomToTop = 5
        case disappearLeftToRight = 6
        case disappearRightToLeft = 7
    }
    
    private enum Coordinate: Int {
        case topLeft    = 0
        case topRight   = 1
        case bottomLeft = 2
        case bottomRight = 3
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: bounds)
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 需要使用坐标初始化
    /// - Parameter frame: 坐标值
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        contentView.addSubview(imageView)
    }

    open override var contentMode: UIView.ContentMode {
        willSet {
            super.contentMode = newValue
            imageView.contentMode = newValue
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 要渲染的图片
    @objc public var image: UIImage? {
        willSet {
            imageView.image = newValue
        }
    }
    /// 动画时长
    @objc public var duration: TimeInterval = 0.3
    /// 模式
    @objc public var options: UIView.AnimationOptions = .curveLinear
    /// 类型
    @objc public var direction: Direction = .appearTopToBottom {
        willSet {
            switch newValue {
            case .appearTopToBottom:
                contentView.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 0))
            
            case .appearBottomToTop:
                contentView.frame = CGRect(origin: CGPoint(x: 0, y: bounds.height), size: CGSize(width: bounds.width, height: 0))
                
            case .appearLeftToRight:
                contentView.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: bounds.height))
            
            case .appearRightToLeft:
                contentView.frame = CGRect(origin: CGPoint(x: bounds.width, y: 0), size: CGSize(width: 0, height: bounds.height))
                
            default:
                contentView.frame = bounds
            }
        }
    }
    /// 位移的内容占全部的比例
    @objc public var progress: CGFloat = 1.0
    /// 是否保留动画后的结果, 默认true; 不保留的话, 动画完成后回到初始状态
    @objc public var shouldKeepResult: Bool = true
    
    /// 渲染动画
    /// - Parameters:
    ///   - animation: 动画回调
    ///   - completion: 完成回调
    @objc public func startDisplay(animation: (() -> ())? = nil,
                                   completion: (() -> ())? = nil) {
        var finalFrame: CGRect = bounds
        
        switch direction {
        case .appearTopToBottom:
            finalFrame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.height * progress))
            
        case .appearLeftToRight:
            finalFrame = CGRect(origin: .zero, size: CGSize(width: bounds.width * progress, height: bounds.height))
            
        case .appearBottomToTop:
            contentViewTransformCoordinate()
            let height: CGFloat = bounds.height * progress
            finalFrame = CGRect(origin: CGPoint(x: 0, y: bounds.height - height), size: CGSize(width: bounds.width, height: height))
            
        case .appearRightToLeft:
            contentViewTransformCoordinate()
            let width: CGFloat = bounds.width * progress
            finalFrame = CGRect(origin: CGPoint(x:bounds.width -  width, y: 0), size: CGSize(width: width, height: bounds.height))
            
        case .disappearTopToBottom:
            contentViewTransformCoordinate()
            let height: CGFloat = bounds.height * progress
            finalFrame = CGRect(origin: CGPoint(x: 0, y: height), size: CGSize(width: bounds.width, height: bounds.height - height))
            
        case .disappearLeftToRight:
            contentViewTransformCoordinate()
            let width: CGFloat = bounds.width * progress
            finalFrame = CGRect(origin: CGPoint(x: width, y: 0), size: CGSize(width: bounds.width - width, height: bounds.height))
            
        case .disappearBottomToTop:
            finalFrame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.height - bounds.height * progress))
            
        case .disappearRightToLeft:
            finalFrame = CGRect(origin: .zero, size: CGSize(width: bounds.width - bounds.width * progress, height: bounds.height))
        
        }

        displayContentFrame(duration: duration,
                            options: options,
                            atFrame: finalFrame,
                            animation: animation,
                            completion: completion)
    }
    
    /// 移除动画
    @objc func stopDisplay() {
        contentView.layer.removeAllAnimations()
    }
    
    /// 主动画
    /// - Parameters:
    ///   - duration: 时长
    ///   - options: 模式
    ///   - startFrame: 开始坐标
    ///   - atFrame: 结束坐标
    ///   - animation: animation回调
    ///   - completion: 完成回调
    private func displayContentFrame(duration: TimeInterval,
                                     options: UIView.AnimationOptions,
                                     atFrame: CGRect,
                                     animation: (() -> ())?,
                                     completion: (() -> ())?) {
        let startFrame: CGRect = self.contentView.frame
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: options,
                       animations: {
                        self.contentView.frame = atFrame
                        if let ani = animation {
                            ani()
                        }
        }) { (finished) in
            if !self.shouldKeepResult {
                self.contentView.frame = startFrame
            }
            if finished {
                if let com = completion {
                    com()
                }
            }
        }
    }
    
    
    /// 转换contentView的坐标系
    /// - Parameter coord: 转换类型(暂未用到其他类型, 待扩展)
    private func contentViewTransformCoordinate(coord: Coordinate = .bottomRight) {
        guard let img = image else {
            debugPrint("====== Error: 需要先设置image!!! ======")
            return
        }
        
        imageView.image = flipImage(image: img, rotation: .down)
        contentView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
    
    /// 图片转向
    /// - Parameters:
    ///   - image: 原图
    ///   - rotation: 方向
    /// - Returns: newImage
    private func flipImage(image: UIImage,
                           rotation: UIImage.Orientation) -> UIImage {
        var rotate: Double = 0
        var rect: CGRect = .zero
        var translateX: CGFloat = 0
        var translateY: CGFloat = 0
        var scaleX: CGFloat = 1.0
        var scaleY: CGFloat = 1.0
        
        switch rotation {
        case .left:
            rotate = Double.pi / 2.0
            rect = CGRect(origin: .zero, size: CGSize(width: image.size.height, height: image.size.width))
            translateX = 0
            translateY = -rect.width
            scaleY = rect.width / rect.height
            scaleX = rect.height / rect.width
            
        case .right:
            rotate = -Double.pi / 2.0
            rect = CGRect(origin: .zero, size: CGSize(width: image.size.height, height: image.size.width))
            translateX = -rect.height
            translateY = 0
            scaleY = rect.width / rect.height
            scaleX = rect.height / rect.width
            
        case .down:
            rotate = Double.pi
            rect = CGRect(origin: .zero, size: image.size)
            translateX = -rect.width
            translateY = -rect.height
            
        default:
            rotate = 0
            rect = CGRect(origin: .zero, size: image.size)
            translateX = 0
            translateY = 0
        }
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let cxt = UIGraphicsGetCurrentContext()
        cxt?.translateBy(x: 0, y: rect.height)
        cxt?.scaleBy(x: 1.0, y: -1.0)
        cxt?.rotate(by: CGFloat(rotate))
        cxt?.translateBy(x: translateX, y: translateY)
        cxt?.scaleBy(x: scaleX, y: scaleY)
        
        cxt?.draw(image.cgImage!, in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
}
