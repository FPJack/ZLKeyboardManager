# ZLKeyboardManager
ZLKeyboardManager是一个轻量级的iOS键盘管理工具，只需要导入库，无需添加一行代码就能够自动处理键盘弹出时遮挡输入框的问题。它通过监听键盘通知，计算第一响应者的位置，并调整视图的位置以确保输入框始终可见。可以兼容IQKeyboardManager，以及精确到设置某个输入框设置是否禁用IQKeyboardManager而启用ZLKeyboardManager启用处理键盘，并且完善了平时使用IQkeyboardManager遇到的一些问题，包括但不限于：
<p>
 1.有时键盘会闪跳，viewWillAppear设置弹出键盘会有问题
 <p/>
 <p>
 2.第一响应者如果没有所属window或者所属控制器，则无法正确计算位置弹出键盘
 <p/>
<p>
 3.无法设置移动容器view，默认控制器的view
<p/>
<p>
 4.无法设置键盘相对某个特定view底部的间距，默认是第一响应者底部
 <p/>
 <p>
 5.无法精确到某个TextField设置是否启用键盘管理
<p/>
 <p>
 6.UITableViewController中使用键盘失效的问题
<p/>

## Example



<p align="center">
  <img src="https://github.com/FPJack/ZLKeyboardManager/blob/master/test.GIF" width="240" alt="ZLPermission Logo">
</p>

## 安装


```ruby
pod 'ZLKeyboardManager' //导入默认已开启键盘管理功能
```

开启键盘管理功能,导入库的时候默认已开启
```objc
    ZLKeyboardManager.share.enable = NO;//关闭键盘管理功能
```
开启自动工具栏功能
```objc
    ZLKeyboardManager.share.enableAutoToolbar = YES;
```

开启点击背景收起键盘功能
```objc
    ZLKeyboardManager.share.shouldResignOnTouchOutside = YES;
```

单独某个输入框禁用键盘管理功能
```objc
    textField.keyboardCfg.enable = NO;
```

设置相对键盘顶部的view,默认是输入框
```objc
    textField.keyboardCfg.relativeToKeyboardTopView = view;
```

设置键盘顶部间距
```objc
    textField.keyboardCfg.keyboardTopMargin = 10;
```

设置需要移动的容器view,默认是第一响应者的所属控制器的view，如果没有控制器则是所属window
```objc
    textField.keyboardCfg.moveContainerView = view
```

单独某个输入框禁用IQKeyboardManager而启用ZLKeyboardManager处理键盘
```objc
    textField.keyboardCfg.disableIQKeyboardManager = YES;
    textField.keyboardCfg.enable = YES;
```
## Author

fanpeng, 2551412939@qq.com

## License

ZLKeyboardManager is available under the MIT license. See the LICENSE file for more info.
