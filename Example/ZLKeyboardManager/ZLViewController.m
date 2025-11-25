//
//  ZLViewController.m
//  ZLKeyboardManager
//
//  Created by fanpeng on 10/17/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLViewController.h"
#import "RandomTableController.h"
#import "RandomScrollController.h"
#import "RandomStaticController.h"

@interface ZLViewController ()

@end

@implementation ZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页面";
    
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
    NSArray *titles = @[
        @"TableView 随机控件",
        @"ScrollView 随机控件",
        @"静态页面随机控件"
    ];

    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(40, 150 + i * 80, self.view.bounds.size.width - 80, 60);
        btn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        btn.layer.cornerRadius = 8;
        btn.tag = i + 1;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)click:(UIButton *)sender {
    UIViewController *vc;
    if (sender.tag == 1) vc = [RandomTableController new];
    else if (sender.tag == 2) vc = [RandomScrollController new];
    else vc = [RandomStaticController new];

    [self.navigationController pushViewController:vc animated:YES];
}
@end
