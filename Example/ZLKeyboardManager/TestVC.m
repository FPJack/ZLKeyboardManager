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
#import <Masonry/Masonry.h>
@interface TestVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *textFieldValues;
@property (nonatomic, strong) NSMutableArray *searchBarValues;
@property (nonatomic, strong) NSMutableArray *textViewValues;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic,strong)UIView *containerView;
@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
//        ZLKeyboardManager.share.enable = YES;
//    ZLKeyboardManager.share.enableAutoToolbar = YES;
//    IQKeyboardManager.sharedManager.enable = YES;
//    IQKeyboardManager.sharedManager.enableAutoToolbar = YES;
    
//    IQKeyboardManager.sharedManager.enable = NO;
//    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    
//    self.navigationController.navigationBarHidden = YES;
//    NSMutableArray *arr = ZLKeyboardManager.share.disabledInputViewClasses;
//    [ZLKeyboardManager.share.disabledInputViewClasses addObject:[UISearchBar class]];
//    [ZLKeyboardManager.share.disabledInputViewClasses addObject:[UITextField class]];
//    [ZLKeyboardManager.share.disabledInputViewClasses addObject:[UITextView class]];
    NSLog(@"%@",ZLKeyboardManager.share.disabledInputViewClasses);
    [self setupData];
    [self setupUI];
    self.view = UIView.new;
//    self.containerView = UIView.new;
    self.view.backgroundColor = UIColor.orangeColor;

//    [self.view addSubview:self.containerView];
//    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.bottom.trailing.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//    }];
//    [self.containerView addSubview:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.textView becomeFirstResponder];
//    self.tableView.transform = CGAffineTransformMakeTranslation(0, -247);
//    NSLog(@"%@",self.tableView);
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
//    CGFloat height = 200;
//    self.tableView.layer.frame = CGRectMake(0, -247, self.view.bounds.size.width, self.view.bounds.size.height);

//    self.tableView.frame = CGRectMake(0, height, self.view.bounds.size.width, self.view.bounds.size.height - height);
    
}
- (void)setupData {
    // 初始化数据数组
    self.textFieldValues = [NSMutableArray array];
    self.searchBarValues = [NSMutableArray array];
    self.textViewValues = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [self.textFieldValues addObject:[NSString stringWithFormat:@"TextField %d", i+1]];
        [self.searchBarValues addObject:[NSString stringWithFormat:@"Search %d", i+1]];
        [self.textViewValues addObject:[NSString stringWithFormat:@"TextView Content for Cell %d\nThis is a multi-line text view.", i+1]];
    }

}

- (void)setupUI {
    self.title = @"输入控件示例";
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = 200;
    // 创建TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, self.view.bounds.size.width, self.view.bounds.size.height - height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 200; // 设置合适的高度
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InputCell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputCell" forIndexPath:indexPath];
    
    // 清除cell的contentView上的所有子视图
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // 设置cell背景色
    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    // 创建标题标签
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 20)];
    titleLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row + 1];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor darkTextColor];
    [cell.contentView addSubview:titleLabel];
    
    // 创建UITextField
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 30, CGRectGetWidth(tableView.frame) - 30, 35)];
    textField.placeholder = @"请输入文本";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.text = self.textFieldValues[indexPath.row];
    textField.tag = 1000 + indexPath.row; // 用于标识
    textField.delegate = self;
    [cell.contentView addSubview:textField];
//    textField.keyboardConfig.keyboardDistanceFromRelativeView = 100;
    

    
    
    // 创建UISearchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 75, CGRectGetWidth(tableView.frame) - 30, 40)];
    searchBar.placeholder = @"搜索内容";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.text = self.searchBarValues[indexPath.row];
    searchBar.tag = 2000 + indexPath.row;
    searchBar.delegate = self;
    NSLog(@"%d----%p",searchBar.kfc_keyboardCfg.enableAutoToolbar,searchBar);
    [cell.contentView addSubview:searchBar];

    // 创建UITextView
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 125, CGRectGetWidth(tableView.frame) - 30, 60)];
    textView.text = self.textViewValues[indexPath.row];
    textView.font = [UIFont systemFontOfSize:14];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.cornerRadius = 5.0;
    textView.tag = 3000 + indexPath.row;
    textView.delegate = self;
    textView.kfc_keyboardCfg.shouldAutoHandleKeyboard = ^BOOL(UIView * _Nonnull view) {
        return YES;
    };
    [cell.contentView addSubview:textView];
  

    if (indexPath.item == 2) {
        self.textView = textView;
//        textView.kfc_keyboardCfg.moveContainerView = self.containerView;
        [textView becomeFirstResponder];
    }
    
    // 为每个控件添加标签
    [self addLabelToView:textField text:@"UITextField" position:CGRectMake(-80, 8, 70, 20)];
    [self addLabelToView:searchBar text:@"UISearchBar" position:CGRectMake(-85, 12, 75, 20)];
    [self addLabelToView:textView text:@"UITextView" position:CGRectMake(-75, 20, 65, 20)];
    
    return cell;
}

// 添加标签的方法
- (void)addLabelToView:(UIView *)view text:(NSString *)text position:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 取消所有第一响应者
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger index = textField.tag - 1000;
    if (index >= 0 && index < 20) {
        self.textFieldValues[index] = textField.text ?: @"";
        NSLog(@"TextField %ld: %@", (long)index + 1, textField.text);
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSInteger index = searchBar.tag - 2000;
    if (index >= 0 && index < 20) {
        self.searchBarValues[index] = searchBar.text ?: @"";
        NSLog(@"SearchBar %ld: %@", (long)index + 1, searchBar.text);
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSInteger index = textView.tag - 3000;
    if (index >= 0 && index < 20) {
        self.textViewValues[index] = textView.text ?: @"";
        NSLog(@"TextView %ld: %@", (long)index + 1, textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
