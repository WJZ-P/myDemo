//
//  UIView+InputView.m
//  myDemo
//
//  Created by WJZ_P on 2025/5/23.
//

#import "InputView.h"
#import "../utils/ColorUtil.h"

typedef NS_ENUM(NSUInteger,InputViewButtonType){
    InputViewButtonSend,
    InputViewButtonThink,
    InputViewButtonOnline
};

@interface InputView()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIStackView *buttonStack;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIButton *> *actionButtons;

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) UIView *containerView;

@end

@implementation InputView

#pragma mark - UI初始化

// 初始化方法
- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if(self){
        [self setupUI];
        [self setupToolbarButtons];
        [self setupConstraints];
        [self setupObservers];
        
        self.textChange=^(NSString * text){
            NSLog(@"用户输入了：%@",text);
        };
    }
    
    return self;
}

// 被添加到父视图时自动执行
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        self.containerView = self.superview;
        [self setupPositionConstraints];
        [self setupKeyboardObservers];
    }
}

#pragma mark - 私有方法

-(void)setupUI{
    //这里设置输入框的内容
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"和元宝说点什么";
    _textField.borderStyle = UITextBorderStyleNone;  // 移除边框
    _textField.font = [UIFont systemFontOfSize:16];
    
    _textField.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self addSubview:_textField];
    
    // 添加InputView的边框
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.2f;  //控制整个组件的边框
    self.layer.cornerRadius = 20.0f;
    self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];  // 设置一个更浅的灰色背景
}

#pragma mark - 设置Constraints

// 设置的是该视图内部布局
- (void)setupConstraints{
    NSDictionary *views=NSDictionaryOfVariableBindings(_textField,_buttonStack);
    
    NSDictionary *metrics = @{
        @"topPadding": @8,
        @"hPadding": @16,
        @"bottomPadding": @12,
        @"fieldStackSpacing": @8,
        @"textFieldHeight": @40,
        @"sendButtonWidth": @40
    };
    
    // 调整 textField 的宽度约束
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hPadding-[_textField]-hPadding-|" options:0 metrics:metrics views:views]];
    
    // 规则3：让 _buttonStack 左右留出我们自定义的 16 点边距
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hPadding-[_buttonStack]-hPadding-|" options:0 metrics:metrics views:views]];
    
    // 规则4：定义从上到下的完整布局链条
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[_textField(textFieldHeight)]-fieldStackSpacing-[_buttonStack]-bottomPadding-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}

// 设置输入视图定位约束，也就是元素本身相对于父视图的位置约束
- (void)setupPositionConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 水平居中与宽度约束
    [NSLayoutConstraint activateConstraints:@[
        [self.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        [self.widthAnchor constraintEqualToAnchor:self.containerView.widthAnchor multiplier:0.9]
    ]];
    
    // 创建并存储底部约束
    self.bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:self.containerView.safeAreaLayoutGuide.bottomAnchor constant:-5];
    self.bottomConstraint.active = YES;
}

#pragma mark - 设置监听器

-(void)setupObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTextChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_textField];
}

-(void)handleTextChange:(NSNotification *)notice{
    if(self.textChange){
        self.textChange(_textField.text);
    }
}

// 键盘处理（移至InputView内部）
- (void)setupKeyboardObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    CGFloat safeAreaBottomHeight = self.containerView.safeAreaInsets.bottom;//安全区底部的高度
    
    // 计算约束值
    CGFloat newConstant = notification.name == UIKeyboardWillShowNotification ?
    -keyboardFrame.size.height+safeAreaBottomHeight-5 :-5;
    //这里控制输入栏往上的时候，要少移动安全区的那一块高度，不然会空出来一块，不好看
    
    self.bottomConstraint.constant = newConstant;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve
                     animations:^{
        [self.containerView layoutIfNeeded];
    } completion:nil];
}

# pragma mark - 处理按钮相关

-(void)setupToolbarButtons{
    _buttonStack=[[UIStackView alloc]init];
    _buttonStack.axis=UILayoutConstraintAxisHorizontal;
    _buttonStack.distribution=UIStackViewDistributionEqualSpacing;
    _buttonStack.spacing=8;
    
    // 初始化按钮字典
    _actionButtons = [NSMutableDictionary dictionary];
    
    // 创建按钮并存储到字典中
    NSArray *buttonTypes = @[
        @(InputViewButtonThink),
        @(InputViewButtonOnline),
        @(InputViewButtonSend)
    ];
    
    for (NSNumber *type in buttonTypes) {
        UIButton *button = [self createToolButtonWithType:[type integerValue]];
        _actionButtons[type] = button;
        [_buttonStack addArrangedSubview:button];
    }
    
    _buttonStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_buttonStack];
    [NSLayoutConstraint activateConstraints:@[
        [_buttonStack.topAnchor constraintEqualToAnchor:_textField.bottomAnchor constant:16],
        [_buttonStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [_buttonStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16]
    ]];
}

// 创建单个按钮
- (UIButton *)createToolButtonWithType:(InputViewButtonType)type {
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *imageName;//设置按钮的图标
    NSString *buttonTitle;//按钮的文字
    // 使用 UIButtonConfiguration 设置按钮样式,这个plainButtonConfiguration如果换成filled开头的，按钮就自带一个背景填充色
    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];

    switch (type){
        case InputViewButtonSend:
            imageName=@"paperplane";//设置发送按钮的样式,这是一个纸飞机
            buttonTitle=@"";
            config.contentInsets = NSDirectionalEdgeInsetsMake(5, 5, 5, 5);
            button.layer.cornerRadius = 17.5;  // 设置为宽度的一半，使其成为圆形
            [button.widthAnchor constraintEqualToConstant:35].active = YES;
            [button.heightAnchor constraintEqualToConstant:35].active = YES;
            config.baseForegroundColor = [UIColor whiteColor];    // 发送按钮的图标和文字为白色
            button.backgroundColor = [UIColor blackColor];        // 发送按钮的背景为黑色
            break;
        case InputViewButtonThink:
            // imageName=@"lightbulb.max";//一个发最大光的灯泡，但是灯泡太大了，不匹配
            buttonTitle=@"R1·深度思考";
            config.contentInsets = NSDirectionalEdgeInsetsMake(5, 10, 5, 10);
            button.layer.cornerRadius = 18;
            config.baseForegroundColor = [UIColor colorWithHexString:@"#666666"];    // 其他按钮保持灰色
            break;
        case InputViewButtonOnline:
            imageName=@"globe";//一个地球
            buttonTitle=@"联网搜索";
            config.contentInsets = NSDirectionalEdgeInsetsMake(5, 10, 5, 10);
            button.layer.cornerRadius = 18;
            config.baseForegroundColor = [UIColor colorWithHexString:@"#666666"];    // 其他按钮保持灰色
            break;
    }
    
    config.image = [UIImage systemImageNamed:imageName];
    config.title = buttonTitle;
    config.imagePadding = 5;
    
    button.configuration = config;
    
    //下面设置一下boder的样式
    button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    button.layer.borderWidth=0.5f;
    // button.backgroundColor=[UIColor systemGray6Color]; //设置按钮的背景颜色
    
    [button addTarget:self action:@selector(toolButtonTapped:) forControlEvents:UIControlEventTouchUpInside];   //设置按钮的点击事件
    
    // 为深度思考和联网搜索按钮添加点击事件
    if (type == InputViewButtonThink || type == InputViewButtonOnline) {
        [button addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

// 深度思考和联网搜索按钮的点击事件
- (void)toggleButton:(UIButton *)sender {
    // 遍历字典找到对应的按钮类型
    InputViewButtonType buttonType = InputViewButtonSend; // 默认值
    for (NSNumber *type in _actionButtons) {
        if (_actionButtons[type] == sender) {
            buttonType = [type integerValue];
            break;
        }
    }
    
    if (buttonType == InputViewButtonThink) {
        if (!self.isThinkButtonActive) {
            // 激活状态：蓝色边框和文字
            sender.layer.borderColor = [UIColor systemBlueColor].CGColor;
            
            // 更新按钮配置
            UIButtonConfiguration *config = sender.configuration;
            config.baseForegroundColor = [UIColor systemBlueColor];
            sender.configuration = config;
            
            NSLog(@"开启深度思考");
            self.isThinkButtonActive = YES;
        } else {
            // 非激活状态：灰色边框和文字
            sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            // 更新按钮配置
            UIButtonConfiguration *config = sender.configuration;
            config.baseForegroundColor = [UIColor blackColor];
            sender.configuration = config;
            
            NSLog(@"关闭深度思考");
            self.isThinkButtonActive = NO;
        }
    } else if (buttonType == InputViewButtonOnline) {
        if (!self.isOnlineButtonActive) {
            // 激活状态：蓝色边框和文字
            sender.layer.borderColor = [UIColor systemBlueColor].CGColor;
            
            // 更新按钮配置
            UIButtonConfiguration *config = sender.configuration;
            config.baseForegroundColor = [UIColor systemBlueColor];
            sender.configuration = config;
            
            NSLog(@"开启联网搜索");
            self.isOnlineButtonActive = YES;
        } else {
            // 非激活状态：灰色边框和文字
            sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            // 更新按钮配置
            UIButtonConfiguration *config = sender.configuration;
            config.baseForegroundColor = [UIColor blackColor];
            sender.configuration = config;
            
            NSLog(@"关闭联网搜索");
            self.isOnlineButtonActive = NO;
        }
    }
}

// 按钮点击处理
- (void)toolButtonTapped:(UIButton *)sender {
    // 遍历字典找到对应的按钮类型
    InputViewButtonType buttonType = InputViewButtonSend; // 默认值
    for (NSNumber *type in _actionButtons) {
        if (_actionButtons[type] == sender) {
            buttonType = [type integerValue];
            break;
        }
    }
    
    if (buttonType != InputViewButtonSend) {
        NSLog(@"一个按钮被点击了");
//        if (self.buttonAction) {
//            self.buttonAction(buttonType); // 通过block回调点击事件
//        }
    }
}


#pragma mark - 视图释放时

-(void)dealloc{
    // 释放的时候要移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end

