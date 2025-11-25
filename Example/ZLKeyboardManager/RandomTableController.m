// RandomTableController.m
#import "RandomTableController.h"

@interface RandomTableController ()
@property (nonatomic, strong) NSArray *data;
//@property (nonatomic,strong) UITableView *tableView;
@end

@implementation RandomTableController
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _tableView.delegate = (id<UITableViewDelegate>)self;
//        _tableView.dataSource = (id<UITableViewDataSource>)self;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TableView 随机控件";
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }

    // 随机生成 20 个控件类型
    NSMutableArray *tmp = @[].mutableCopy;
    NSArray *types = @[@"textfield", @"textview"];
    for (int i = 0; i < 7; i++) {
        [tmp addObject:types[i % types.count]];
        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@(i).description];

    }
    self.data = tmp;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = self.data[indexPath.row];
    if ([type isEqualToString:@"textview"]) return 120;
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)idx {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@(idx.row).description forIndexPath:idx];
    UITextField *textField = UITextField.new;
    textField.keyboardCfg.enable = NO;
    textField.keyboardCfg.relativeToKeyboardTopView = view;
    textField.keyboardCfg.keyboardTopMargin = 10;
    textField.keyboardCfg.moveContainerView = view
    NSString *type = self.data[idx.row];
    if ([type isEqualToString:@"textfield"]) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width - 30, 40)];
        tf.placeholder = [NSString stringWithFormat:@"UITextField-%ld",idx.row];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:tf];

    } else if ([type isEqualToString:@"textview"]) {
        ZLTextView *tv = [[ZLTextView alloc] initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width - 30, 100)];
        tv.layer.borderWidth = 1;
        tv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tv.text = [NSString stringWithFormat:@"UITextView-%ld",idx.row];
        [cell.contentView addSubview:tv];
        tv.placeholder = [NSString stringWithFormat:@"UITextView-%ld Placeholder",idx.row];

    } else {
        UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        sb.placeholder = @"UISearchBar";
        sb.placeholder = [NSString stringWithFormat:@"UISearchBar-%ld",idx.row];

        [cell.contentView addSubview:sb];
    }

    return cell;
}

@end
