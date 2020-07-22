# WKCImageDisplayView
图片动画渲染

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/WKCImageDisplayView?style=flat)](https://cocoapods.org/pods/WKCImageDisplayView) [![License: MIT](https://img.shields.io/cocoapods/l/WKCImageDisplayView?style=flat)](http://opensource.org/licenses/MIT)

提供一个可自定义方向的图片渲染动画.

| 属性 | 含义 |
| ---- | ---- |
| image | 渲染图 |
| duration | 动画时长 |
| options | 动画选项 |
| direction | 渲染选项 |
| progress | 位移的内容占全部的比例 |
| shouldKeepResult | 是否保留动画后的结果 |

示例:
```
lazy var displayView: WKCImageDisplayView = {
    let view = WKCImageDisplayView(frame: CGRect(origin: .zero, size: CollectionViewCell.itemSize))
    view.duration = 0.3
    view.options = .curveLinear
    view.progress = 1.0
    view.image = UIImage(named: "1.jpg")
    return view
}()
```
通过 ` startDisplay` 和 ` stopDisplay `控制渲染动画.

| <p align="center">
<img src="https://github.com/WKCLoveYang/WKCFaceImageCropper/raw/master/source/1.MP4" width="350">
</p>
