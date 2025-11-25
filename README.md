# ZLKeyboardManager
ZLKeyboardManager是一个轻量级的iOS键盘管理工具，能够自动处理键盘弹出时遮挡输入框的问题。它通过监听键盘通知，计算第一响应者的位置，并调整视图的位置以确保输入框始终可见。处理IQkeyboardManager平时遇到的一些问题，包括但不限于：
 1.有时键盘会闪跳，viewWillAppear设置弹出键盘会有问题\n
 2.第一响应者如果没有所属window或者所属控制器，则无法正确计算位置弹出键盘\n
 3.无法设置移动容器view，默认控制器的view\n
 4.无法设置键盘相对某个特定view底部的间距，默认是第一响应者底部\n
 5.无法精确到某个TextField设置是否启用键盘管理\n
[![CI Status](https://img.shields.io/travis/fanpeng/ZLKeyboardManager.svg?style=flat)](https://travis-ci.org/fanpeng/ZLKeyboardManager)
[![Version](https://img.shields.io/cocoapods/v/ZLKeyboardManager.svg?style=flat)](https://cocoapods.org/pods/ZLKeyboardManager)
[![License](https://img.shields.io/cocoapods/l/ZLKeyboardManager.svg?style=flat)](https://cocoapods.org/pods/ZLKeyboardManager)
[![Platform](https://img.shields.io/cocoapods/p/ZLKeyboardManager.svg?style=flat)](https://cocoapods.org/pods/ZLKeyboardManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZLKeyboardManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZLKeyboardManager'
```

开启键盘管理功能
```objc
    ZLKeyboardManager.share.enable = YES;
```


## Author

fanpeng, peng.fan@ukelink.com

## License

ZLKeyboardManager is available under the MIT license. See the LICENSE file for more info.
