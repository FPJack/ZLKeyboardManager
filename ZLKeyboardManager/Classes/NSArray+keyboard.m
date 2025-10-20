//
//  NSArray+keyboard.m
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/20.
//

#import "NSArray+keyboard.h"
@interface UIView()
@property (nonatomic,assign)CGRect convertFrame;
@end
@implementation NSArray (keyboard)
- (NSArray<UIView*>*)kfc_sortedArrayByTag
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        if ([view1 respondsToSelector:@selector(tag)] && [view2 respondsToSelector:@selector(tag)])
        {
            if ([view1 tag] < [view2 tag])    return NSOrderedAscending;
            
            else if ([view1 tag] > [view2 tag])    return NSOrderedDescending;
            
            else    return NSOrderedSame;
        }
        else
            return NSOrderedSame;
    }];
}

- (NSArray<UIView*>*)kfc_sortedArrayByPosition
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        CGFloat x1 = CGRectGetMinX(view1.convertFrame);
        CGFloat y1 = CGRectGetMinY(view1.convertFrame);
        CGFloat x2 = CGRectGetMinX(view2.convertFrame);
        CGFloat y2 = CGRectGetMinY(view2.convertFrame);
        
        if (y1 < y2)  return NSOrderedAscending;
        
        else if (y1 > y2) return NSOrderedDescending;
        
        //Else both y are same so checking for x positions
        else if (x1 < x2)  return NSOrderedAscending;
        
        else if (x1 > x2) return NSOrderedDescending;
        
        else    return NSOrderedSame;
    }];
}
@end
