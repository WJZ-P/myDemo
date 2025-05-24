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
    
    InputView *inputView=[[InputView alloc] initWithTitle:@"快乐的腾讯元宝" placeholder:@"快点输入文字！🐧"];
    
    inputView.translatesAutoresizingMaskIntoConstraints=NO;
    
    //下面插入自己的组件
    [self.view addSubview:inputView];
    
    //控制在主视图上的位置
    
    // 先创建好这个约束，但先不激活它，单独写上因为要动态更新
    self.inputViewBottomConstraint = [inputView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20];
    
    [NSLayoutConstraint activateConstraints: @[
        //让inputView的水平中心对齐父视图的水平中心
        [inputView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        //给inputView一个宽度
        [inputView.widthAnchor constraintEqualToConstant:300],
        //再给一个高度
        [inputView.heightAnchor constraintEqualToConstant:100],
        self.inputViewBottomConstraint//我们存好的约束
        ]
    ];
    
    
    //inputView里面定义了一个block，也就是回调函数，在这里controller里面去具体实现。
    inputView.textChange=^(NSString * text){
        NSLog(@"用户输入了：%@",text);
    };
    
    //要设置一个键盘监听
    [self setupKeyboardObservers];
}

// 订阅手机键盘
-(void)setupKeyboardObservers{
    //“键盘即将出现”
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard Handling 处理键盘监听消息

-(void)keyboardWillShow:(NSNotification *)notification{
    //从通知信息中拿到键盘尺寸和动画信息
    NSDictionary *userInfo=notification.userInfo;
    //键盘弹出后的最终位置
    CGRect keyboardFrame=[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘弹出的动画时间
    NSTimeInterval duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘弹出的动画曲线
    UIViewAnimationCurve curve=[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    //计算InputView 新的底部的偏移量
    CGFloat newConstant=-(keyboardFrame.size.height);
    
    //更新约束，并且调用
    self.inputViewBottomConstraint.constant=newConstant;
    
    //让约束的改变以动画形式展现
    [UIView animateWithDuration:duration delay:0 options:curve<<16 animations:^{
        [self.view layoutIfNeeded];//命令视图根据新的约束调整布局
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // 1. 同样，获取动画信息
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 2. 恢复约束到最初的状态
    self.inputViewBottomConstraint.constant = -20;
    
    // 3. 以动画形式恢复
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve << 16
                     animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
