//
//  ViewController.m
//  myDemo
//
//  Created by WJZ_P on 2025/5/19.
//

#import "ViewController.h"
#import "utils/ColorUtil.h"
#import "components/InputView.h"

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
    
    InputView *inputView=[[InputView alloc] initWithTitle:@"我是一个快乐的元宝🎉" placeholder:@"快点输入文字！🐧"];
    
    //下面插入自己的组件
    [self.view addSubview:inputView];
}

@end
