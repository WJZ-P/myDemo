//
//  UIView+InputView.m
//  myDemo
//
//  Created by WJZ_P on 2025/5/23.
//

#import "InputView.h"
#import "../utils/ColorUtil.h"

// 定义最大行数常量
const NSInteger kMaxInputLines = 3;

typedef NS_ENUM(NSUInteger,InputViewButtonType){
    InputViewButtonSend,
    InputViewButtonThink,
    InputViewButtonOnline
};

@interface InputView() <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIStackView *buttonStack;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIButton *> *actionButtons;

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textViewHeightConstraint;
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
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8); // 调整上下内边距
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled = NO; // 禁用滚动，让高度自适应
    
    // 设置占位符文本
    _textView.text = @"和元宝说点什么";
    _textView.textColor = [UIColor lightGrayColor];
    
    _textView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self addSubview:_textView];
    
    // 添加InputView的边框
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.2f;  //控制整个组件的边框
    self.layer.cornerRadius = 20.0f;
    self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];  // 设置一个更浅的灰色背景

    // 添加底部阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 2;
}

#pragma mark - 设置Constraints

// 设置的是该视图内部布局
- (void)setupConstraints{
    NSDictionary *views=NSDictionaryOfVariableBindings(_textView,_buttonStack);
    
    NSDictionary *metrics = @{
        @"topPadding": @8,
        @"hPadding": @16,
        @"bottomPadding": @12,
        @"fieldStackSpacing": @8,
        @"minTextFieldHeight": @40,
        @"sendButtonWidth": @40
    };
    
    // 调整 textView 的宽度约束
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hPadding-[_textView]-hPadding-|" options:0 metrics:metrics views:views]];
    
    // 规则3：让 _buttonStack 左右留出我们自定义的 16 点边距
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hPadding-[_buttonStack]-hPadding-|" options:0 metrics:metrics views:views]];
    
    // 规则4：定义从上到下的完整布局链条，移除固定高度约束
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[_textView]-fieldStackSpacing-[_buttonStack]-bottomPadding-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // 创建并存储 textView 的高度约束，设置初始高度
    self.textViewHeightConstraint = [_textView.heightAnchor constraintEqualToConstant:40];
    self.textViewHeightConstraint.active = YES;
    
    // 设置最小高度约束
    NSLayoutConstraint *minHeightConstraint = [_textView.heightAnchor constraintGreaterThanOrEqualToConstant:40];
    minHeightConstraint.active = YES;
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
}

// 创建单个按钮
- (UIButton *)createToolButtonWithType:(InputViewButtonType)type {
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *imageName;//设置按钮的图标
    NSString *buttonTitle;//按钮的文字
    // 使用 UIButtonConfiguration 设置按钮样式,这个plainButtonConfiguration如果换成filled开头的，按钮就自带一个背景填充色
    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];

    switch (type){
        case InputViewButtonSend:{
            imageName=@"paperplane.circle.fill";//设置发送按钮的样式,这是一个纸飞机
            buttonTitle=@"";
            button.layer.cornerRadius = 17.5;  // 设置为宽度的一半，使其成为圆形
            [button.widthAnchor constraintEqualToConstant:35].active = YES;
            [button.heightAnchor constraintEqualToConstant:35].active = YES;
            config.baseForegroundColor = [UIColor blackColor];    // 图案和文字是黑色

            // 调整图标大小，使其完全覆盖边框
            UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:28];

            // 3. 应用配置并设置图像
            config.preferredSymbolConfigurationForImage = symbolConfig;
            config.image = [[UIImage systemImageNamed:imageName 
                                   withConfiguration:symbolConfig] 
                           imageWithTintColor:[UIColor blackColor]
                           renderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
        }
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
    
    [button addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];   //设置按钮的点击事件
    
    return button;
}

// 按钮的点击事件
- (void)toggleButton:(UIButton *)sender {
    // 遍历字典找到对应的按钮类型
    InputViewButtonType buttonType = InputViewButtonSend; // 默认值
    for (NSNumber *type in _actionButtons) {
        if (_actionButtons[type] == sender) {
            buttonType = [type integerValue];
            break;
        }
    }
    
    switch (buttonType) {
        case InputViewButtonThink: {
            NSLog(@"深度思考按钮被点击");
            BOOL isActive = !self.isThinkButtonActive;
            // 更新按钮样式
            sender.layer.borderColor = isActive ? [UIColor systemBlueColor].CGColor : [UIColor lightGrayColor].CGColor;
            
            // 更新按钮配置
            UIButtonConfiguration *config = sender.configuration;
            config.baseForegroundColor = isActive ? [UIColor systemBlueColor] : [UIColor blackColor];
            sender.configuration = config;
            
            // 更新状态
            self.isThinkButtonActive = isActive;
            
            break;
        }
            
        case InputViewButtonOnline: {
            NSLog(@"联网搜索按钮被点击");
            BOOL isActive = !self.isOnlineButtonActive;
            // 更新按钮样式
            sender.layer.borderColor = isActive ? [UIColor systemBlueColor].CGColor : [UIColor lightGrayColor].CGColor;
            
            // 更新按钮配置
            UIButtonConfiguration *config = sender.configuration;
            config.baseForegroundColor = isActive ? [UIColor systemBlueColor] : [UIColor blackColor];
            sender.configuration = config;
            
            // 更新状态
            self.isOnlineButtonActive = isActive;

            break;
        }

        case InputViewButtonSend: {
            NSLog(@"发送按钮被点击");
            NSString *message = [self currentText];
            if (message.length > 0) {
                // 通知代理
                if ([self.delegate respondsToSelector:@selector(inputView:didSendMessage:)]) {
                    [self.delegate inputView:self didSendMessage:message];
                }
                // 清空输入框
                [self clearText];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Public Methods

- (NSString *)currentText {
    return _textView.text;
}

- (void)clearText {
    _textView.text = @"";
    // 重置高度
    self.textViewHeightConstraint.constant = 40;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // 当开始编辑时，如果是占位符文本，则清空并改变颜色
    if ([textView.text isEqualToString:@"和元宝说点什么"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    // 当结束编辑时，如果文本为空，则显示占位符
    if (textView.text.length == 0) {
        textView.text = @"和元宝说点什么";
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    // 计算文本内容的高度，需要考虑内边距
    CGFloat maxHeight = (textView.font.lineHeight * kMaxInputLines) + 
                       textView.textContainerInset.top + 
                       textView.textContainerInset.bottom;
    
    // 计算内容实际需要的高度，同样需要考虑内边距
    CGFloat contentHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)].height;
    
    // 限制最大高度
    contentHeight = MIN(contentHeight, maxHeight);
    
    // 更新高度约束
    self.textViewHeightConstraint.constant = contentHeight;
    
    // 通知内容变化
    if (self.textChange) {
        self.textChange(textView.text);
    }
}

#pragma mark - 视图释放时

-(void)dealloc{
    // 释放的时候要移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


@end

