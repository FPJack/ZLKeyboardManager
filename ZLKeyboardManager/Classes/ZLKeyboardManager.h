//
//  ZLKeyboardManager.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import <Foundation/Foundation.h>
#import "UIView+keyboard.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLKeyboardManager : NSObject
+ (instancetype)share;
@property(nonatomic, assign, getter = isEnabled) BOOL enable;
@property(nonatomic, assign, getter = isEnableAutoToolbar) BOOL enableAutoToolbar;
/// 点击背景是否收起键盘，defaults is YES
@property (nonatomic,assign)BOOL shouldResignOnTouchOutside;
@end
NS_ASSUME_NONNULL_END
