//
//  ZLTextView.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///IQKeyboardManager库里面的TextView文本输入视图占位符支持
@interface ZLTextView : UITextView

/**
 Set textView's placeholder text. Default is nil.
 */
@property(nullable, nonatomic,copy) IBInspectable NSString    *placeholder;

/**
 Set textView's placeholder attributed text. Default is nil.
 */
@property(nullable, nonatomic,copy) IBInspectable NSAttributedString    *attributedPlaceholder;

/**
 To set textView's placeholder text color. Default is nil.
 */
@property(nullable, nonatomic,copy) IBInspectable UIColor    *placeholderTextColor;
@end

NS_ASSUME_NONNULL_END
