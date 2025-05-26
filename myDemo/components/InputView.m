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

@property (nonatomic, strong) UILabel *titleLabel;//input上面的文字
@property (nonatomic, strong) UITextField *textField;//输入框
@property (nonatomic, strong) UIStackView *buttonStack;//按钮的容器
@property (nonatomic, strong) NSArray<UIButton *>*actionButtons;//存放按钮的数组

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;//新增一个底部约束的饮用
@property (nonatomic, weak) UIView *containerView;//存储父视图的引用，必须weak防止循环引用。

@end

@implementation InputView

#pragma mark - UI初始化

// 初始化方法
- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder {
    self = [super initWithFrame:CGRectZero];
    
    if(self){
        //调用下面的方法
        [self setupUIWithTitle:title placeholder:placeholder];
        [self setupToolbarButtons];//初始化input下方的工具栏
        
        [self setupConstraints];//设置元素内部约束
        [self setupObservers];
        
        //实现一些事先定义好的接口
        //inputView里面定义了一个block，也就是回调函数，在这里controller里面去具体实现。
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

-(void)setupUIWithTitle:(NSString *)title placeholder:(NSString *)placeholder{
    // 标题标签
    _titleLabel=[[UILabel alloc] init];
    _titleLabel.text=title;
    _titleLabel.font=[UIFont systemFontOfSize:14];
    
    //这里设置输入框的内容
    _textField = [[UITextField alloc] init];
    _textField.placeholder = placeholder;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont systemFontOfSize:16];
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _textField.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self addSubview:_titleLabel];
    [self addSubview:_textField];
    
}

#pragma mark - 设置Constraints

// 设置的是该视图内部布局
- (void)setupConstraints{
    // 使用VFL布局，VFL就是visual format language，也就是可视化格式语言。
    
    //先创建一个视图对象，后面要用。
    NSDictionary *views=NSDictionaryOfVariableBindings(_titleLabel,_textField,_buttonStack);
    
    //这里定义一个别名，用于控制视图的左右边界。
    NSDictionary *metrics = @{
        @"topPadding": @8,
        @"hPadding": @16, //水平padding
        @"bottomPadding": @8,
        @"labelFieldSpacing": @8,
        @"fieldStackSpacing": @16,
        @"textFieldHeight": @40
    };
    
    //下面这里，开始创建规则。
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textField]|" options:0 metrics:nil  views:views]];
    
    // 规则3：让 _buttonStack 左右留出我们自定义的 16 点边距
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hPadding-[_buttonStack]-hPadding-|" options:0 metrics:metrics views:views]];
    
    // 规则4：定义从上到下的完整布局链条
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[_titleLabel]-labelFieldSpacing-[_textField(textFieldHeight)]-fieldStackSpacing-[_buttonStack]-bottomPadding-|"
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
    _buttonStack=[[UIStackView alloc]init];//分配空间
    _buttonStack.axis=UILayoutConstraintAxisHorizontal;//横向排列
    _buttonStack.distribution=UIStackViewDistributionEqualSpacing;//布局调整
    _buttonStack.spacing=8;
    
    NSArray *buttonTypes =@[
        @(InputViewButtonSend),@(InputViewButtonThink),@(InputViewButtonOnline)
    ];
    
    NSMutableArray *buttons=[NSMutableArray new];//存放按钮
    for(NSNumber *typeNum in buttonTypes){//初始化按钮
        UIButton *btn=[self createToolButtonWithType:typeNum.integerValue];
        [buttons addObject:btn];
    }
    
    _actionButtons=[buttons copy];
    for(UIButton *btn in _actionButtons)[_buttonStack addArrangedSubview:btn];
    
    _buttonStack.translatesAutoresizingMaskIntoConstraints=NO;
    //添加进视图里
    [self addSubview:_buttonStack];
    
}

// 创建单个按钮
- (UIButton *)createToolButtonWithType:(InputViewButtonType)type {
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *imageName;//设置按钮的图标
    NSString *buttonTitle;//按钮的文字
    
    switch (type){
        case InputViewButtonSend:
            imageName=@"paperplane";//设置发送按钮的样式,这是一个纸飞机
            buttonTitle=@"发送";
            break;
        case InputViewButtonThink:
            imageName=@"lightbulb.max";//一个发最大光的灯泡
            buttonTitle=@"深度思考";
            break;
        case InputViewButtonOnline:
            imageName=@"globe";//一个地球
            buttonTitle=@"联网搜索";
            break;
    }
    [button setImage:[UIImage systemImageNamed:imageName] forState:UIControlStateNormal];//设置在普通状态下的样式
    button.tintColor=[UIColor darkGrayColor];//这个是设置SF这样模版图标的样式，这里设置成深灰色
    
    //下面设置按钮标题
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal]; // 设置标题颜色
    
    //下面设置一下boder的样式
    button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    button.layer.borderWidth=1.0f;
    button.backgroundColor=[UIColor systemGray6Color];//先写死这个颜色
    button.layer.cornerRadius=15;
    
    
    [button addTarget:self action:@selector(toolButtonTapped:) forControlEvents:UIControlEventTouchUpInside];   //设置按钮的点击事件
    
    //约束按钮的尺寸(注释掉就是自动fit-content)
//    [button.widthAnchor constraintEqualToConstant:30].active = YES;
//    [button.heightAnchor constraintEqualToConstant:35].active = YES;
    
    return button;
}

// 按钮点击处理
- (void)toolButtonTapped:(UIButton *)sender {
    NSUInteger index = [self.actionButtons indexOfObject:sender];
    if (index != NSNotFound) {
//        if (self.buttonAction) {
//            self.buttonAction(index); // 通过block回调点击事件
//        }
    }
}


#pragma mark - 视图释放时

-(void)dealloc{
    // 释放的时候要移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
