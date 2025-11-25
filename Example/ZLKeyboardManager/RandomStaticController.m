// RandomStaticController.m
#import "RandomStaticController.h"

@interface RandomStaticController ()
@end

@implementation RandomStaticController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"静态页面随机控件";
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *types = @[@"textfield", @"textview", @"searchbar"];
    CGFloat y = 120;

    for (int i = 0; i < 10; i++) {
        NSString *type = types[arc4random() % types.count];

        if ([type isEqualToString:@"textfield"]) {
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, y, self.view.bounds.size.width - 40, 40)];
            tf.placeholder = @"UITextField";
            tf.borderStyle = UITextBorderStyleRoundedRect;
            [self.view addSubview:tf];
            y += 60;

        } else if ([type isEqualToString:@"textview"]) {
            ZLTextView *tv = [[ZLTextView alloc] initWithFrame:CGRectMake(20, y, self.view.bounds.size.width - 40, 120)];
            tv.placeholder = [NSString stringWithFormat:@"UITextView-%ld Placeholder",i];

            tv.text = @"UITextView";
            tv.layer.borderWidth = 1;
            tv.layer.cornerRadius = 5;
            [self.view addSubview:tv];
            y += 140;

        } else {
            UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, 60)];
            sb.placeholder = @"UISearchBar";
            [self.view addSubview:sb];
            y += 80;
        }
    }
}

@end
