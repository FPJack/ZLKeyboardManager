//
//  ZLKeyboardManager.m
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import "ZLKeyboardManager.h"
#import <objc/runtime.h>
#import "UIView+keyboard.h"
#import "ZLToolBar.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
static NSHashTable<UIView *> *_tables;
@interface UIView (keyboard)
@property(nonatomic, strong) ZLKeyboardConfig *keyboardCfg;
@end
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
@interface ZLKeyboardConfig()
@property (nonatomic,assign,readwrite)CGRect convertFrame;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;
@end
@interface UITextField (keyboard)
@end
@implementation UITextField (keyboard)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [object_getClass((id)self) _swizzleClassMethod:@selector(alloc) with:@selector(_hook_alloc)];
        [self _swizzleClassMethod:@selector(initWithCoder:) with:@selector(_hook_initWithCoder:)];
        [self _swizzleClassMethod:@selector(becomeFirstResponder) with:@selector(_hook_becomeFirstResponder)];

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
- (BOOL)_hook_becomeFirstResponder {
    [self.keyboardCfg becomeFirstResponder];
    BOOL res = [self _hook_becomeFirstResponder];
    if (!res) [self.keyboardCfg resignFirstResponder];
    return res;
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
        [self _swizzleClassMethod:@selector(becomeFirstResponder) with:@selector(_hook_becomeFirstResponder)];
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
- (BOOL)_hook_becomeFirstResponder {
    [self.keyboardCfg becomeFirstResponder];
    BOOL res = [self _hook_becomeFirstResponder];
    if (!res) [self.keyboardCfg resignFirstResponder];
    return res;
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
        [self _swizzleClassMethod:@selector(becomeFirstResponder) with:@selector(_hook_becomeFirstResponder)];
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
- (BOOL)_hook_becomeFirstResponder {
    [self.keyboardCfg becomeFirstResponder];
    BOOL res = [self _hook_becomeFirstResponder];
    if (!res) [self.keyboardCfg resignFirstResponder];
    return res;
}
@end




@interface ZLKeyboardManager()
@property (nonatomic,readonly) UIView *firstResponder;
@property (nonatomic,weak,readwrite) UIView *currentResponder;
@property (nonatomic,nonatomic) UITapGestureRecognizer *tapGesture;
@property(nonatomic, strong,readwrite) NSMutableArray<Class> *disabledInputViewClasses;
@property (nonatomic, copy,readwrite) void(^enableIQKeyboardManagerBK)(void);
@property (nonatomic, copy,readwrite) void(^disableIQKeyboardManagerBK)(void);
@property (nonatomic,strong)NSNumber* orignEnable;
@end
@implementation ZLKeyboardManager
- (NSMutableArray<Class> *)disabledInputViewClasses {
    if (!_disabledInputViewClasses) {
        _disabledInputViewClasses = NSMutableArray.array;
    }
    return _disabledInputViewClasses;
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)];
        _tapGesture.cancelsTouchesInView = NO;
    }
    return _tapGesture;
}
- (void)touchOutside:(UITapGestureRecognizer *)tap {
    UIView *currentResponder = self.currentResponder;
    [currentResponder resignFirstResponder];
}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tables = [NSHashTable weakObjectsHashTable];
        ZLKeyboardManager.share.enable = YES;
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
        share.shouldResignOnTouchOutside = YES;
        share.enableAutoToolbar = YES;
        share.shouldDismissKeyboardOnScrollViewDrag = YES;
    });
    return share;
}
- (void)setEnable:(BOOL)enable {
    if (enable == _enable) return;
    _enable = enable;
    enable ? [self addNotificationObserver] : [self removeNotificationObserver];
}
- (UIView *)firstResponder {
    for (UIView * view in _tables) if (view.isFirstResponder) return view;
    return nil;
}
- (void)UIKeyboardDidShowNotification:(NSNotification *)notification {
}
- (void)recursiveTraverseAllSubviews:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)subview;
            scrollView.keyboardDismissMode = self.shouldDismissKeyboardOnScrollViewDrag;
            if (@available(iOS 11.0, *)) {
                scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
            }
        }
        [self recursiveTraverseAllSubviews:subview];
    }
}
- (void)UIKeyboardWillShowNotification:(NSNotification *)notification {
    UIView *currentResponder = self.currentResponder;
    if (!self.shouldHandleKeyboard) return;
    
    if ([NSStringFromClass(currentResponder.class) isEqualToString:@"_UIAlertControllerTextField"]) {
        return;
    }
    UIView *moveContainerView = currentResponder.keyboardCfg.moveContainerView;
    // 设置scrollView的键盘弹起时的行为
    if ([moveContainerView isKindOfClass:UIScrollView.class]) {
        UIScrollView *scrollView = (UIScrollView *)moveContainerView;
        scrollView.keyboardDismissMode = self.shouldDismissKeyboardOnScrollViewDrag;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    [self recursiveTraverseAllSubviews:moveContainerView];

    
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    animationDuration = animationDuration > 0 ? animationDuration : 0.25;
    UIView *relativeView = currentResponder.keyboardCfg.relativeToKeyboardTopView;
    CGRect viewFrameInWindow = [relativeView convertRect: CGRectMake(0, moveContainerView.bounds.origin.y + relativeView.bounds.origin.y, relativeView.bounds.size.width, relativeView.bounds.size.height) toView:relativeView.window];
    CGFloat maxY = CGRectGetMaxY(viewFrameInWindow);
    CGFloat space = self.currentResponder.keyboardCfg.keyboardTopMargin;
    CGFloat bottomSpace = kScreenHeight - keyboardHeight - maxY - space;
    if (CGRectEqualToRect(moveContainerView.keyboardCfg.originBounds, CGRectZero)) {
        moveContainerView.keyboardCfg.originBounds = moveContainerView.bounds;
    }

    if (bottomSpace >= 0) {
        
    }else {
        [UIView animateWithDuration:animationDuration animations:^{
            BOOL shouldScrollView = NO;
            {
                UIView *superview = currentResponder;
                while (superview.superview) {
                    if (![superview isEqual:moveContainerView]) {
                        superview = superview.superview;
                        if ([superview isKindOfClass:UIScrollView.class]) {
                            UIScrollView *scrollView = (UIScrollView *)superview;
                            if (!scrollView.scrollEnabled || !scrollView.userInteractionEnabled){
                                continue;
                            }
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
                    }else {
                        break;
                    }
                }
            }
            if (shouldScrollView) return;
            moveContainerView.bounds = CGRectMake(0, -bottomSpace, moveContainerView.bounds.size.width, moveContainerView.bounds.size.height);
        } ];
    }
}

- (void)UIKeyboardWillHideNotification:(NSNotification *)notification {
    [self endEditing];
    if (_tapGesture.view) [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
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
- (void)removeNotificationObserver {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
- (void)willChangeStatusBarOrientation:(NSNotification*)aNotification
{
   
}
- (void)UITextFieldTextDidBeginEditingNotification:(NSNotification *)notification {

    UITextField *textField = notification.object;
    if (![self.currentResponder.keyboardCfg.viewContainingController isEqual:textField.keyboardCfg.viewContainingController]) {
        [self endEditing];
    }
    self.currentResponder = textField;
    if (!self.shouldHandleKeyboard) return;

    [self addInputToobarIfRequired];
    if (textField.keyboardCfg.shouldResignOnTouchOutside && ![NSStringFromClass(textField.class) isEqualToString:@"_UIAlertControllerTextField"]) {
        [textField.window addGestureRecognizer:self.tapGesture];
    }else {
        if (_tapGesture.view) {
            [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
        }
    }
}
- (void)UITextFieldTextDidEndEditingNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    [textField.keyboardCfg resignFirstResponder];
    if (!self.shouldHandleKeyboard) return;
    if (_tapGesture.view) {
        [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    }
    if (![textField respondsToSelector:@selector(setInputAccessoryView:)]) {
        return;
    }
}
- (void)UITextViewTextDidBeginEditingNotification:(NSNotification *)notification {
    UITextView *textView = notification.object;
    if (![self.currentResponder.keyboardCfg.viewContainingController isEqual:textView.keyboardCfg.viewContainingController]) {
        [self endEditing];
    }
    self.currentResponder = textView;
    if (!self.shouldHandleKeyboard) return;
    [self addInputToobarIfRequired];
    if (textView.keyboardCfg.shouldResignOnTouchOutside) {
        [textView.window addGestureRecognizer:self.tapGesture];
    }else {
        if (_tapGesture.view) {
            [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
        }
    }
}
- (void)UITextViewTextDidEndEditingNotification:(NSNotification *)notification {
    UITextView *textView = notification.object;
    [textView.keyboardCfg resignFirstResponder];
    if (!self.shouldHandleKeyboard) return;
    if (_tapGesture.view) {
        [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    }
    if (![textView respondsToSelector:@selector(setInputAccessoryView:)]) {
        return;
    }
}

- (UISearchBar *)searchBarOfSearchTextField:(UIView *)searchTextField {
    if ([searchTextField isKindOfClass:UITextField.class] || [searchTextField isKindOfClass:UITextView.class]){
            return nil;
    }
    UIView *superView = searchTextField.superview;
    while (superView && ![superView isKindOfClass:UISearchBar.class]) {
        superView = superView.superview;
    }
    return [(UISearchBar *)superView isKindOfClass:UISearchBar.class] ? (UISearchBar *)superView : nil;
}
- (NSArray *)allInputViews {
    UIView *moveContainerView = self.currentResponder.keyboardCfg.moveContainerView;
    NSMutableArray *arr = NSMutableArray.array;
    [_tables.allObjects enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [self searchBarOfSearchTextField:obj];
        BOOL res = NO;
        if (view) {
            res = view.isUserInteractionEnabled
            && !view.hidden
            && view.alpha > 0.0
            && [view isDescendantOfView:moveContainerView];
        }else {
            res = obj.isUserInteractionEnabled
            && !obj.hidden
            && obj.alpha > 0.0
            && [obj isDescendantOfView:moveContainerView];
        }
        if (res) {
            obj.keyboardCfg.convertFrame = [obj convertRect: obj.bounds toView:view.window];
            [arr addObject:obj];
        }
    }];
    
    if (@available(iOS 13.0, *)) {
        NSMutableArray *searchBars = NSMutableArray.array;
        [arr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:UISearchTextField.class]) {
                UIView *searchBar = obj.superview;
                while (![searchBar isKindOfClass:UISearchBar.class] && searchBar) searchBar = searchBar.superview;
                if (searchBar) [searchBars addObject:searchBar];
            }
        }];
        [arr removeObjectsInArray:searchBars];
    }
    return [arr zl_sortedArrayByPosition];
}
- (void)doneBarButtonAction:(UIBarButtonItem *)sender {
    [self.currentResponder resignFirstResponder];
}
- (void)addInputToobarIfRequired {
    UITextField *textField = self.currentResponder;
    if (![textField respondsToSelector:@selector(inputAccessoryView)]) {
        return;
    }
    if (!textField.inputAccessoryView && textField.keyboardCfg.enableAutoToolbar) {
        ZLToolBar *toolbar = textField.keyboardCfg.keyboardToolbar;
        toolbar = toolbar ?: [[ZLToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        toolbar.barStyle = UIBarStyleDefault;
        if (![textField respondsToSelector:@selector(setInputAccessoryView:)]) {
            return;
        }
       
        UIView *firstResponder = self.currentResponder;
        if ([firstResponder isKindOfClass:UITextField.class]) {
            UITextField *tf = (UITextField *)firstResponder;
            if (tf.attributedPlaceholder) {
                toolbar.titleLabel.attributedText = tf.attributedPlaceholder;
            }else{
                toolbar.titleLabel.text = ((UITextField *)firstResponder).placeholder;
            }
        }else if ([firstResponder isKindOfClass:UISearchBar.class]){
            toolbar.titleLabel.text = ((UISearchBar *)firstResponder).placeholder;
        }else if ([firstResponder isKindOfClass:ZLTextView.class]){
            ZLTextView *zlTextView = (ZLTextView *)firstResponder;
            if (zlTextView.attributedPlaceholder) {
                toolbar.titleLabel.attributedText = zlTextView.attributedPlaceholder;
            }else if (zlTextView.placeholder) {
                toolbar.titleLabel.text = zlTextView.placeholder;
            }
        }else if ([firstResponder isKindOfClass:UITextView.class]) {
            
        }
        NSArray *sortArr = [self allInputViews];
        if (sortArr.count <= 1) {
            toolbar.previousBarButton.image = nil;
            toolbar.nextBarButton.image = nil;
        }else {
            NSInteger idx = [sortArr indexOfObject:firstResponder];
            toolbar.previousBarButton.enabled = !(idx == 0);
            toolbar.nextBarButton.enabled = !(idx == sortArr.count - 1);
        }
        textField.keyboardCfg.keyboardToolbar = toolbar;
        if (![textField respondsToSelector:@selector(setKeyboardAppearance:)]) {
            return;
        }
        if (self.overrideKeyboardAppearance) {
            textField.keyboardAppearance = self.keyboardAppearance;
        }else {
            if (@available(iOS 13.0, *)) {
                if (textField.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    // 黑暗模式
                    textField.keyboardAppearance = UIKeyboardAppearanceDark;
                } else {
                    // 明亮模式
                    textField.keyboardAppearance = UIKeyboardAppearanceLight;
                }
            }
        }
        if (@available(iOS 12.0, *)) {
            toolbar.barStyle = textField.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? UIBarStyleBlack : UIBarStyleDefault;
        }
        
        
        if (self.configureToolBarBK) self.configureToolBarBK(toolbar);
        textField.inputAccessoryView = toolbar;
        [textField reloadInputViews];
    }
}
- (void)endEditing {
    if (!self.shouldHandleKeyboard) return;
    [UIView animateWithDuration:0.25 animations:^{
        UIView *moveContainerView = self.currentResponder.keyboardCfg.moveContainerView;
        moveContainerView.bounds = CGRectMake(0, 0, moveContainerView.bounds.size.width, moveContainerView.bounds.size.height);
//        moveContainerView.bounds= moveContainerView.keyboardCfg.originBounds;
    }];
    self.currentResponder = nil;
}
- (BOOL)shouldHandleKeyboard{
    if ([self adapterPopViewForKeyboardAvoid]) return NO;
    UIView *currentResponder = self.currentResponder;
    if (self.enable && currentResponder.keyboardCfg.shouldAutoHandleKeyboard) {
        return currentResponder.keyboardCfg.shouldAutoHandleKeyboard(currentResponder);
    }
    if (!currentResponder.keyboardCfg.enable) return NO;
    if (self.disabledInputViewClasses.count > 0) {
        BOOL isKindOfDisabledClass = NO;
        for (Class cls in self.disabledInputViewClasses) {
            if ([currentResponder isKindOfClass:cls]) {
                isKindOfDisabledClass = YES;
                break;
            }
        }
        if (isKindOfDisabledClass) return NO;
    }
    return YES;
}
- (BOOL)adapterPopViewForKeyboardAvoid {
    Class cls = NSClassFromString(@"GMPopBaseView");
    if (!cls) cls = NSClassFromString(@"ZLPopBaseView");
    if (!cls) return NO;
    UIView *currentResponder = self.currentResponder;
    UIView *superview = currentResponder.superview;
    while (superview && ![superview isKindOfClass:cls]) {
        superview = superview.superview;
    }
    if ([superview isKindOfClass:cls] && [superview respondsToSelector:@selector(configObj)]) {
        NSObject *config = [superview performSelector:@selector(configObj)];
        SEL sel = NSSelectorFromString(@"avoidKeyboardType");
        if (config && [config respondsToSelector:sel]) {
            NSNumber* type = [config valueForKey:@"avoidKeyboardType"];
            //!!!!很诡异为什么会崩溃，回头看
            //id type = [config performSelector:sel];
            if ([type isKindOfClass:NSNumber.class] &&
                (type.integerValue == 1 || type.integerValue == 2)) {
                return YES;
            }else {
                currentResponder.keyboardCfg.moveContainerView = superview;
            }
        }
    }
    return NO;
}
- (BOOL)resignFirstResponder {
    UIView *currentResponder = self.currentResponder;
    [currentResponder resignFirstResponder];
    return currentResponder != nil;
}


- (BOOL)goPrevious{
    NSArray *sortArr = [self allInputViews];
    NSInteger idx = [sortArr indexOfObject:self.currentResponder];
    if (idx != NSNotFound && idx > 0) {
        UIView *view = sortArr[idx - 1];
        [view becomeFirstResponder];
        view.keyboardCfg.keyboardToolbar.previousBarButton.enabled = ![sortArr.firstObject isEqual:view];
        return YES;
    }
    return NO;
}


- (BOOL)goNext {
    NSArray *sortArr = [self allInputViews];
    NSInteger idx = [sortArr indexOfObject:self.currentResponder];
    if (idx != NSNotFound && idx + 1 < sortArr.count) {
        UIView *view = sortArr[idx + 1];
        [view becomeFirstResponder];
        view.keyboardCfg.keyboardToolbar.nextBarButton.enabled = ![sortArr.lastObject isEqual:view];
        return YES;
    }
    return NO;
}
- (void)adaptIQKeyboardManager:(void(^)(void))enableBK disable:(void(^)(void))disableBK{
    self.enableIQKeyboardManagerBK = enableBK;
    self.disableIQKeyboardManagerBK = disableBK;
}
- (void)registerAllNotifications {
    [self addNotificationObserver];
}
- (void)unregisterAllNotifications{
    [self removeNotificationObserver];
}
@end
