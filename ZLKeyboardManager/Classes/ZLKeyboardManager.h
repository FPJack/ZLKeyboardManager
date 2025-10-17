//
//  ZLKeyboardManager.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLKeyboardManager : NSObject
+ (instancetype)share;
@property(nonatomic, assign, getter = isEnabled) BOOL enable;
@property(nonatomic, assign, getter = isEnableAutoToolbar) BOOL enableAutoToolbar;
@end
NS_ASSUME_NONNULL_END
