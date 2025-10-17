//
//  ZLKeyboardManager.m
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import "ZLKeyboardManager.h"
#import <objc/runtime.h>
#import "UIView+keyboard.h"
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
    [_tables addObject:obj];
    return obj;
}
@end


@interface UIView (VC)
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
    NSLog(@"%@",notification.object);
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
    UIViewController *viewContainingController = self.currentResponder.viewContainingController;
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    animationDuration = animationDuration > 0 ? animationDuration : 0.25;
    UIView *relativeView = self.currentResponder.keyboardConfig.relativeView;
    CGRect viewFrameInWindow = [relativeView convertRect: CGRectMake(0, viewContainingController.view.bounds.origin.y + relativeView.bounds.origin.y, relativeView.bounds.size.width, relativeView.bounds.size.height) toView:relativeView.window];
    CGFloat maxY = CGRectGetMaxY(viewFrameInWindow);
    CGFloat space = self.currentResponder.keyboardConfig.keyboardDistanceFromRelativeView;
    CGFloat bottomSpace = kScreenHeight - keyboardHeight - maxY - space;
    if (CGRectEqualToRect(viewContainingController.view.keyboardConfig.originBounds, CGRectZero)) {
        viewContainingController.view.keyboardConfig.originBounds = viewContainingController.view.bounds;
    }
    if (bottomSpace >= 0) return;
    
    [UIView animateWithDuration:animationDuration animations:^{
        viewContainingController.view.bounds = CGRectMake(0, -bottomSpace, viewContainingController.view.frame.size.width, viewContainingController.view.frame.size.height);
    }];
}
- (void)doneButtonTapped:(id)sender {
    [self.currentResponder resignFirstResponder];
}
- (void)UIKeyboardWillHideNotification:(NSNotification *)notification {
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
}

- (void)UITextFieldTextDidBeginEditingNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (![self.currentResponder.viewContainingController isEqual:textField.viewContainingController]) {
        [self didEndEditing];
    }
    self.currentResponder = textField;
    [self addInputToobarIfRequired];
}
- (void)UITextFieldTextDidEndEditingNotification:(NSNotification *)notification {
}
- (void)UITextViewTextDidBeginEditingNotification:(NSNotification *)notification {
    UITextView *textField = notification.object;
    if (![self.currentResponder.viewContainingController isEqual:textField.viewContainingController]) {
        [self didEndEditing];
    }
    self.currentResponder = textField;
    [self addInputToobarIfRequired];
}
- (void)UITextViewTextDidEndEditingNotification:(NSNotification *)notification {
}

- (void)addInputToobarIfRequired {
    UITextField *textField = self.currentResponder;
    if (self.enableAutoToolbar && !textField.inputAccessoryView && textField.keyboardConfig.enautomAutoToolbar) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        toolbar.barStyle = UIBarStyleDefault;
            // 创建灵活空间（用于将按钮推到右边）
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            // 创建“完成”按钮
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
            // 将按钮添加到工具栏
        toolbar.items = @[flexibleSpace, doneButton];
        textField.inputAccessoryView = toolbar;
        [textField reloadInputViews];
    }
}
- (void)didEndEditing {
    if (!self.isEnabled) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.currentResponder.viewContainingController.view.bounds = self.currentResponder.viewContainingController.view.keyboardConfig.originBounds;
    }];
    self.currentResponder = nil;
}
@end
