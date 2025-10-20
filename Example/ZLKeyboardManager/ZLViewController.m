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


@end

@implementation ZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(ta:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"stackView" style:UIBarButtonItemStylePlain target:self action:@selector(stackView:)];

    self.navigationItem.rightBarButtonItems = @[item1,item2];
}
- (void)stackView:(id)obj {
    [self.navigationController pushViewController:ZLStackViewVC.new animated:YES];

}
- (void)ta:(id)obj {
    [self.navigationController pushViewController:TestVC.new animated:YES];

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
//    [self.textField resignFirstResponder];
//    [self.textField1 reloadInputViews];
//
    
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}
@end
