//
//  ZLStackViewVC.m
//  ZLKeyboardManager_Example
//
//  Created by admin on 2025/10/20.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLStackViewVC.h"

@interface ZLStackViewVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ZLStackViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.textView becomeFirstResponder];
    self.textView.kfc_keyboardCfg.keyboardDistanceFromRelativeView = 50;
    self.searchBar.kfc_keyboardCfg.keyboardDistanceFromRelativeView = 100;
    self.textField.kfc_keyboardCfg.keyboardDistanceFromRelativeView = 150;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
