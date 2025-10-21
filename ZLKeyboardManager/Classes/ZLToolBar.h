//
//  ZLToolBar.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface ZLToolBar : UIToolbar
/**
 Previous bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) UIBarButtonItem *previousBarButton;
- (void)previousBarButtonAction:(UIBarButtonItem *)sender;
/**
 Next bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) UIBarButtonItem *nextBarButton;
- (void)nextBarButtonAction:(UIBarButtonItem *)sender;

/**
 Title bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) UIBarButtonItem *titleBarButton;
@property (nonatomic, strong,readonly) UILabel *titleLabel;


/**
 Done bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) UIBarButtonItem *doneBarButton;
- (void)doneBarButtonAction:(UIBarButtonItem *)sender;

/**
 Fixed space bar button of toolbar.
 */
@property(nonnull, nonatomic, strong) UIBarButtonItem *fixedSpaceBarButton1;
@property(nonnull, nonatomic, strong) UIBarButtonItem *fixedSpaceBarButton2;


@end

NS_ASSUME_NONNULL_END
