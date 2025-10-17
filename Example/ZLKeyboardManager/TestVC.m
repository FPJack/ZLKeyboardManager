//
//  TestVC.m
//  ZLKeyboardManager_Example
//
//  Created by admin on 2025/10/17.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "TestVC.h"
#import <ZLKeyboardManager/ZLKeyboardManager.h>
#import <ZLKeyboardManager/UIView+keyboard.h>
@interface TestVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.textField becomeFirstResponder];
    self.textField.keyboardConfig.keyboardDistanceFromRelativeView = 150;

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
   
    
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}
@end
