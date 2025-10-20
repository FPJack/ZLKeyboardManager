//
//  ZLKeyboardManager.m
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import "ZLKeyboardManager.h"
#import <objc/runtime.h>
#import "UIView+keyboard.h"
#import "NSArray+keyboard.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
static NSHashTable<UIView *> *_tables;
@interface NSObject (method_hook)
@end
@implementation NSObject (method_hook)
+ (BOOL)_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}
@end

@interface UITextField (keyboard)
@end
@implementation UITextField (keyboard)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [object_getClass((id)self) _swizzleClassMethod:@selector(alloc) with:@selector(_hook_alloc)];
        [self _swizzleClassMethod:@selector(initWithCoder:) with:@selector(_hook_initWithCoder:)];
    });
}
- (instancetype)_hook_initWithCoder:(NSCoder *)coder
{
    UITextField *obj = [self _hook_initWithCoder:coder];
    [_tables addObject:obj];
    return self;
}
+ (instancetype) _hook_alloc{
    UITextField *obj = [self _hook_alloc];
    [_tables addObject:obj];
    return obj;
}
@end
@interface UITextView (keyboard)
@end
@implementation UITextView (keyboard)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [object_getClass((id)self) _swizzleClassMethod:@selector(alloc) with:@selector(_hook_alloc)];
        [self _swizzleClassMethod:@selector(initWithCoder:) with:@selector(_hook_initWithCoder:)];
    });
}
- (instancetype)_hook_initWithCoder:(NSCoder *)coder
{
    UITextView *obj = [self _hook_initWithCoder:coder];
    [_tables addObject:obj];
    return self;
}
+ (instancetype) _hook_alloc{
    UITextView *obj = [self _hook_alloc];
    [_tables addObject:obj];
    return obj;
}
@end
@interface UISearchTextField(keyboard)
@property (nonatomic,weak)UISearchBar *searchBar;
@end
@implementation UISearchTextField (keyboard)
- (UISearchBar *)searchBar {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSearchBar:(UISearchBar *)searchBar {
    objc_setAssociatedObject(self, @selector(searchBar), searchBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
@interface UISearchBar (keyboard)
@end
@implementation UISearchBar (keyboard)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [object_getClass((id)self) _swizzleClassMethod:@selector(alloc) with:@selector(_hook_alloc)];
        [self _swizzleClassMethod:@selector(initWithCoder:) with:@selector(_hook_initWithCoder:)];
    });
}
- (instancetype)_hook_initWithCoder:(NSCoder *)coder
{
    UISearchBar *obj = [self _hook_initWithCoder:coder];
    
    [_tables addObject:obj];
    return self;
}
+ (instancetype)_hook_alloc{
    UISearchBar *obj = [self _hook_alloc];
    obj.searchTextField.searchBar = obj;
    [_tables addObject:obj];
    return obj;
}
@end


@interface UIView (VC)
@property (nonatomic,readonly) UIView *moveContainerView;
@property (nonatomic,readonly) UIView *toViewControllerView;
@property (nonatomic,readonly) UIViewController *viewContainingController;
@property (nonatomic,assign)CGRect convertFrame;
@end
@implementation UIView (VC)
-(UIViewController*)viewContainingController
{
    UIResponder *nextResponder =  self;
    do{
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
    } while (nextResponder);
    return nil;
}
-(UIViewController *)topController
{
    NSMutableArray<UIViewController*> *controllersHierarchy = [[NSMutableArray alloc] init];
    
    UIViewController *topController = self.window.rootViewController;
    
    if (topController)
    {
        [controllersHierarchy addObject:topController];
    }
    
    while ([topController presentedViewController]) {
        
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    
    UIViewController *matchController = [self viewContainingController];
    
    while (matchController && [controllersHierarchy containsObject:matchController] == NO)
    {
        do
        {
            matchController = (UIViewController*)[matchController nextResponder];
            
        } while (matchController && [matchController isKindOfClass:[UIViewController class]] == NO);
    }
    
    return matchController;
}
- (UIView *)moveContainerView {
    return self.kfc_keyboardCfg.moveContainerView ?: self.toViewControllerView;
}
- (UIView *)toViewControllerView {
    UIViewController *vc = self.viewContainingController;
    return vc.view;
}
- (void)recursiveTraverseAllSubviews:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)subview;
            scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            if (@available(iOS 11.0, *)) {
                scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
            }

        }
        [self recursiveTraverseAllSubviews:subview];
    }
}
- (CGRect )convertFrame {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return [value CGRectValue];
    }
    return CGRectZero;
}
- (void)setConvertFrame:(CGRect)convertFrame {
    NSValue *value = [NSValue valueWithCGRect:convertFrame];
    objc_setAssociatedObject(self, @selector(convertFrame), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end



@interface ZLKeyboardManager()
@property (nonatomic,readonly) UIView *firstResponder;
@property (nonatomic,weak) UIView *currentResponder;
@end
@implementation ZLKeyboardManager
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tables = [NSHashTable weakObjectsHashTable];
    });
}
- (UIView *)currentResponder {
    if (_currentResponder) {
        return _currentResponder;
    }
    return self.firstResponder;
}
+ (instancetype)share {
    static ZLKeyboardManager *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = ZLKeyboardManager.new;
        [share addNotificationObserver];
    });
    return share;
}

- (void)didBeginEditing:(NSNotification *)notification {
//    NSLog(@"%@",notification.object);
}
- (UIView *)firstResponder {
    for (UIView * view in _tables) {
        if (view.isFirstResponder) return view;
    }
    return nil;
}
- (void)UIKeyboardDidShowNotification:(NSNotification *)notification {
    if (!self.isEnabled) return;
  
}

- (void)UIKeyboardWillShowNotification:(NSNotification *)notification {
    if (!self.isEnabled) return;
    
    UIView *currentResponder = self.firstResponder;
    UIView *moveContainerView = currentResponder.moveContainerView;

    // 设置scrollView的键盘弹起时的行为
    [moveContainerView recursiveTraverseAllSubviews:moveContainerView];
    
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    animationDuration = animationDuration > 0 ? animationDuration : 0.25;
    UIView *relativeView = currentResponder.kfc_keyboardCfg.relativeView;
    CGRect viewFrameInWindow = [relativeView convertRect: CGRectMake(0, moveContainerView.bounds.origin.y + relativeView.bounds.origin.y, relativeView.bounds.size.width, relativeView.bounds.size.height) toView:relativeView.window];
//    CGRect viewFrameInWindow = [relativeView.superview convertRect: currentResponder.frame toView:relativeView.window];
    CGFloat maxY = CGRectGetMaxY(viewFrameInWindow);
    CGFloat space = self.currentResponder.kfc_keyboardCfg.keyboardDistanceFromRelativeView;
    CGFloat bottomSpace = kScreenHeight - keyboardHeight - maxY - space;
    if (CGRectEqualToRect(moveContainerView.kfc_keyboardCfg.originBounds, CGRectZero)) {
        moveContainerView.kfc_keyboardCfg.originBounds = moveContainerView.bounds;
    }
    if (bottomSpace >= 0) return;
    [UIView animateWithDuration:animationDuration animations:^{
        BOOL shouldScrollView = NO;
        {
            UIView *superview = currentResponder.superview;
            while (superview.superview && ![superview isEqual:moveContainerView]) {
                superview = superview.superview;
                if ([superview isKindOfClass:UIScrollView.class]) {
                    UIScrollView *scrollView = superview;
                    CGFloat scrollViewHeight = scrollView.frame.size.height;
                    CGFloat space = scrollView.contentSize.height - scrollViewHeight - scrollView.contentOffset.y;
                    if (space >= -bottomSpace) {
                        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - bottomSpace);
                        shouldScrollView = YES;
                        break;
                    }else if (space > 0 && space < -bottomSpace) {
                        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollViewHeight);
                        moveContainerView.bounds = CGRectMake(0, -bottomSpace - space, moveContainerView.bounds.size.width, moveContainerView.bounds.size.height);
                        shouldScrollView = YES;
                        break;
                    }
                }
            }
        }
        if (shouldScrollView) return;
        moveContainerView.bounds = CGRectMake(0, -bottomSpace, moveContainerView.bounds.size.width, moveContainerView.bounds.size.height);
    } ];
}
- (void)doneButtonTapped:(id)sender {
    [self.currentResponder resignFirstResponder];
}
- (void)UIKeyboardWillHideNotification:(NSNotification *)notification {
    if (!self.isEnabled) return;

    [self didEndEditing];
}

- (void)addNotificationObserver {
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UIKeyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UITextFieldTextDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UITextFieldTextDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UITextViewTextDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UITextViewTextDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarOrientation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:[UIApplication sharedApplication]];

}
- (void)willChangeStatusBarOrientation:(NSNotification*)aNotification
{
   
}


- (void)UITextFieldTextDidBeginEditingNotification:(NSNotification *)notification {
    if (!self.isEnabled) return;

    UITextField *textField = notification.object;
    if (![self.currentResponder.viewContainingController isEqual:textField.viewContainingController]) {
        [self didEndEditing];
    }
    self.currentResponder = textField;
    [self addInputToobarIfRequired];
}
- (void)UITextFieldTextDidEndEditingNotification:(NSNotification *)notification {
    if (!self.isEnabled) return;
}
- (void)UITextViewTextDidBeginEditingNotification:(NSNotification *)notification {
    if (!self.isEnabled) return;
    UITextView *textField = notification.object;
    if (![self.currentResponder.viewContainingController isEqual:textField.viewContainingController]) {
        [self didEndEditing];
    }
    self.currentResponder = textField;
    [self addInputToobarIfRequired];
}
- (void)UITextViewTextDidEndEditingNotification:(NSNotification *)notification {
    if (!self.isEnabled) return;
}
- (void)preAction {
    NSArray *sortArr = [self allInputViews];
    NSInteger idx = [sortArr indexOfObject:self.currentResponder];
    if (idx != NSNotFound && idx > 0) {
        UIView *view = sortArr[idx - 1];
        [view becomeFirstResponder];
    }
}
- (void)nextAction {
    NSArray *sortArr = [self allInputViews];
    NSInteger idx = [sortArr indexOfObject:self.currentResponder];
    if (idx != NSNotFound && idx + 1 < sortArr.count) {
        UIView *view = sortArr[idx + 1];
        [view becomeFirstResponder];
    }
}
- (NSArray *)allInputViews {
   
    UIView *view = self.currentResponder.moveContainerView;
    NSMutableArray *arr = NSMutableArray.array;
    [_tables.allObjects enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isDescendantOfView:view]) {
            obj.convertFrame = [obj convertRect: obj.bounds toView:view.window];
            [arr addObject:obj];
        }
    }];
    
    if (@available(iOS 13.0, *)) {
        NSMutableArray *searchBars = NSMutableArray.array;
        [arr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:UISearchTextField.class]) {
                UISearchBar *searchBar = obj.superview;
                while (![searchBar isKindOfClass:UISearchBar.class] && searchBar) searchBar = searchBar.superview;
                if (searchBar) [searchBars addObject:searchBar];
            }
        }];
        [arr removeObjectsInArray:searchBars];
    }
    
    return [arr kfc_sortedArrayByPosition];
}
- (void)addInputToobarIfRequired {
    UITextField *textField = self.currentResponder;
    if (self.enableAutoToolbar && !textField.inputAccessoryView && textField.kfc_keyboardCfg.enableAutoToolbar) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        toolbar.barStyle = UIBarStyleDefault;
            // 创建灵活空间（用于将按钮推到右边）
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[ZLKeyboardManager keyboardPreviousImage] style:UIBarButtonItemStylePlain target:self action:@selector(preAction)];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[ZLKeyboardManager keyboardNextImage] style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];

        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            // 创建“完成”按钮
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
            // 将按钮添加到工具栏
        toolbar.items = @[item1,item2,flexibleSpace, doneButton];
        textField.inputAccessoryView = toolbar;
        [textField reloadInputViews];
    }
}
- (void)didEndEditing {
    if (!self.isEnabled) return;
    [UIView animateWithDuration:0.25 animations:^{
        UIView *moveContainerView = self.currentResponder.moveContainerView;
        moveContainerView.bounds = CGRectMake(0, 0, moveContainerView.bounds.size.width, moveContainerView.bounds.size.height);
    }];
    self.currentResponder = nil;
}

+(UIImage*)keyboardPreviousImage
{
    static UIImage *keyboardUpImage = nil;
    
    if (keyboardUpImage == nil)
    {
        NSString *base64Data = @"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";
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
        keyboardUpImage = [UIImage imageWithData:data scale:3];

        //Support for RTL languages like Arabic, Persia etc... (Bug ID: #448)
        keyboardUpImage = [keyboardUpImage imageFlippedForRightToLeftLayoutDirection];
    }
    
    return keyboardUpImage;
}

+(UIImage*)keyboardNextImage
{
    static UIImage *keyboardDownImage = nil;
    
    if (keyboardDownImage == nil)
    {
        NSString *base64Data = @"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";
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
        keyboardDownImage = [UIImage imageWithData:data scale:3];
        
        //Support for RTL languages like Arabic, Persia etc... (Bug ID: #448)
        keyboardDownImage = [keyboardDownImage imageFlippedForRightToLeftLayoutDirection];
    }
    
    return keyboardDownImage;
}
@end
