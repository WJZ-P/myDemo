//
//  ViewController.m
//  myDemo
//
//  Created by WJZ_P on 2025/5/19.
//

#import "ViewController.h"
#import "utils/ColorUtil.h"
#import "components/InputView.h"
#import "components/TopBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //这里进行背景色的设定
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f1f1f1"];
    NSLog(@"修改背景色成功");
    
    //自己的inputView
    InputView *inputView=[[InputView alloc] init];
    TopBar *topBar=[[TopBar alloc] init];
    
    //下面插入自己的组件
    [self.view addSubview:inputView];
    [self.view addSubview:topBar];
    
    // 设置TopBar的约束
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [topBar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [topBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [topBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [topBar.heightAnchor constraintEqualToConstant:44 + self.view.safeAreaInsets.top]
    ]];
}

@end
