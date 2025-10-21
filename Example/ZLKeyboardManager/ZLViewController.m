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
#import <MediaPlayer/MediaPlayer.h>
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
@interface ZLViewController ()<MPMediaPickerControllerDelegate>

@property (nonatomic, strong) MPMediaPickerController *mpc;
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
//    [self.navigationController pushViewController:TestVC.new animated:YES];
    
//    MPMediaPickerController *mpc = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
//      mpc.delegate = self;//委托
//      mpc.prompt =@"Please select a music";//提示文字
//    mpc.allowsPickingMultipleItems=NO;//是否允许一次选择多个
//    self.mpc = self.mpc;
//    [self presentViewController:mpc animated:YES completion:nil];
//    [self presentModalViewController:mpc animated:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题" message:@"这是一个UIAlertController的示例。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 处理点击确定按钮的逻辑
        NSLog(@"点击了确定按钮");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 处理点击取消按钮的逻辑
        NSLog(@"点击了取消按钮");
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    for (int i = 0 ; i < 20; i ++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    
        }];
    }
   
    
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
  /*insert your code*/
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];

}
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
  /*insert your code*/
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
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
