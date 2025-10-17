//
//  ZLViewController.m
//  ZLKeyboardManager
//
//  Created by fanpeng on 10/17/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLViewController.h"
#import "TestVC.h"
#import <ZLKeyboardManager/ZLKeyboardManager.h>
#import <ZLKeyboardManager/UIView+keyboard.h>
@interface GMTextField : UITextField
@end
@implementation GMTextField

+ (instancetype)alloc {
    return [super alloc];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
@interface ZLViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UITextField *textField1;

@end

@implementation ZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.stackView.layoutMargins = UIEdgeInsetsMake(50, 50, 50, 50);
    self.stackView.layoutMarginsRelativeArrangement = YES;

    self.stackView.spacing = 20;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.orangeColor;// 设置背景色
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor}; // 标题颜色
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        self.navigationController.navigationBar.barTintColor = UIColor.orangeColor;
        self.navigationController.navigationBar.backgroundColor = UIColor.orangeColor;
    }
    self.textField.keyboardConfig.keyboardDistanceFromRelativeView = 10;
//    self.textField.keyboardConfig.relativeView = self.stackView;
    
    self.textField1.keyboardConfig.keyboardDistanceFromRelativeView = 10;
//    self.textField1.keyboardConfig.relativeView = self.stackView;
    ZLKeyboardManager.share.enable = YES;
//    ZLKeyboardManager.share.enableAutoToolbar = YES;
//    self.textField1.keyboardConfig.enautomAutoToolbar = YES;
   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.textField becomeFirstResponder];
//    self.view.bounds = CGRectMake(0, 200, 375, 667);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ta:(id)sender {
    [self.navigationController pushViewController:TestVC.new animated:YES];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
//    [self.textField resignFirstResponder];
//    [self.textField1 reloadInputViews];
//
    
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}
@end
