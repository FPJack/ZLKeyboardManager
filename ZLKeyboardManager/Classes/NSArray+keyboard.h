//
//  NSArray+keyboard.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (keyboard)
@property (nonnull, nonatomic, readonly, copy) NSArray<__kindof UIView*> * kfc_sortedArrayByTag;

/**
 Returns the array by sorting the UIView's by their tag property.
 */
@property (nonnull, nonatomic, readonly, copy) NSArray<__kindof UIView*> * kfc_sortedArrayByPosition;
@end

NS_ASSUME_NONNULL_END
