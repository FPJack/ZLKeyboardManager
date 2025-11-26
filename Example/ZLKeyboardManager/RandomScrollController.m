// RandomScrollController.m
#import "RandomScrollController.h"

@interface RandomScrollController ()
@property UIScrollView *scroll;
@end

@implementation RandomScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"ScrollView 随机控件";
    self.view.backgroundColor = UIColor.whiteColor;

    self.scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scroll];
    if (@available(iOS 11.0, *)) {
        self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }

    CGFloat y = 20;
    NSArray *types = @[@"textfield", @"textview", @"searchbar"];

    for (int i = 0; i < 8; i++) {
        NSString *type = types[i % types.count];

        if ([type isEqualToString:@"textfield"]) {
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, y, self.view.bounds.size.width - 40, 40)];
            tf.placeholder = @"UITextField";
            tf.borderStyle = UITextBorderStyleRoundedRect;
            [self.scroll addSubview:tf];
            y += 60;

        } else if ([type isEqualToString:@"textview"]) {
            ZLTextView *tv = [[ZLTextView alloc] initWithFrame:CGRectMake(20, y, self.view.bounds.size.width - 40, 120)];
            tv.placeholder = [NSString stringWithFormat:@"UITextView-%ld Placeholder",i];
            tv.font = [UIFont systemFontOfSize:16];

            tv.layer.borderWidth = 1;
            tv.layer.cornerRadius = 4;
            tv.text = @"UITextView";
            [self.scroll addSubview:tv];
            y += 140;

        } else {
            UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, 60)];
            sb.placeholder = @"UISearchBar";
            [self.scroll addSubview:sb];
            y += 80;
        }
    }

    self.scroll.contentSize = CGSizeMake(self.view.bounds.size.width, y);
}

@end
