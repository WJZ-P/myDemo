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
#import "components/MessageView.h"
#import "models/MessageModel.h"

@interface ViewController () <InputViewDelegate, TopBarDelegate>

@property (nonatomic, strong) TopBar *topBar;
@property (nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) MessageView *messageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //这里进行背景色的设定
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f1f1f1"];
    NSLog(@"修改背景色成功");
    
    // 创建并添加 TopBar
    _topBar = [[TopBar alloc] init];
    _topBar.delegate = self;
    _topBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_topBar];
    
    // 创建并添加 MessageView
    _messageView = [[MessageView alloc] init];
    _messageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_messageView];
    
    // 创建并添加 InputView
    _inputView = [[InputView alloc] init];
    _inputView.delegate = self;
    _inputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_inputView];
    
    // 设置约束
    [self setupConstraints];
}

- (void)setupConstraints {
    // TopBar 约束
    [NSLayoutConstraint activateConstraints:@[
        [_topBar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [_topBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_topBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_topBar.heightAnchor constraintEqualToConstant:44]
    ]];
    
    
    // MessageView 约束
    [NSLayoutConstraint activateConstraints:@[
        [_messageView.topAnchor constraintEqualToAnchor:_topBar.bottomAnchor],
        [_messageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_messageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_messageView.bottomAnchor constraintEqualToAnchor:_inputView.topAnchor]
    ]];
}

#pragma mark - TopBarDelegate

- (void)topBar:(TopBar *)topBar didTapSideBarButton:(UIButton *)button {
    NSLog(@"点击了侧边栏");
}

- (void)topBar:(TopBar *)topBar didTapNewChatButton:(UIButton *)button {
    NSLog(@"点击了新建聊天，执行清空界面函数。");
    [self.messageView clearAllMessages];
}

#pragma mark - InputViewDelegate

- (void)inputView:(InputView *)inputView didSendMessage:(NSString *)message {
    // 添加用户消息
    MessageModel *userMessage = [MessageModel textMessage:message isUser:YES];
    [self.messageView addMessage:userMessage];
    
    // 模拟AI回复
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MessageModel *aiMessage = [MessageModel textMessage:@"我收到了你的消息" isUser:NO];
        [self.messageView addMessage:aiMessage];
    });
}



@end
