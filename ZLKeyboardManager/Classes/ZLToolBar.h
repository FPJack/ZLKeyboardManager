//
//  ZLToolBar.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZLBarButtonItem : UIBarButtonItem
///外部赋值，监听点击事件，点击的时候会回调出去
@property(nonatomic,copy)void (^actionBK)(ZLBarButtonItem *sender);
@end

@interface ZLToolBar : UIToolbar
/**
 Previous bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) ZLBarButtonItem *previousBarButton;
- (void)previousBarButtonAction:(ZLBarButtonItem *)sender;
/**
 Next bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) ZLBarButtonItem *nextBarButton;
- (void)nextBarButtonAction:(ZLBarButtonItem *)sender;

/**
 Title bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) ZLBarButtonItem *titleBarButton;
@property (nonatomic, strong,readonly) UILabel *titleLabel;


/**
 Done bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) ZLBarButtonItem *doneBarButton;
- (void)doneBarButtonAction:(ZLBarButtonItem *)sender;

/**
 Fixed space bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) ZLBarButtonItem *fixedSpaceBarButton1;
@property(nonnull, nonatomic, strong) ZLBarButtonItem *fixedSpaceBarButton2;


@end

NS_ASSUME_NONNULL_END
