//
//  UIView+InputView.m
//  myDemo
//
//  Created by WJZ_P on 2025/5/23.
//

#import "InputView.h"

typedef NS_ENUM(NSUInteger,InputViewButtonType){
    InputViewButtonSend,
    InputViewButtonThink,
    InputViewButtonOnline
} <#new#>;

@interface InputView()

@property (nonatomic, strong) UILabel *titleLabel;//input上面的文字
@property (nonatomic, strong) UITextField *textField;//输入框
@property (nonatomic, strong) UIStackView *buttonStack;//按钮的容器
@property (nonatomic, strong) NSArray<UIButton *>actionButtons;//存放按钮的数组

@end

@implementation InputView
// 这个就相当于初始化方法
- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder {
    self = [super initWithFrame:CGRectZero];
    
    if(self){
        //调用下面的方法
        [self setupUIWithTitle:title placeholder:placeholder];
        [self setupConstraints];
        [self setupObservers];
        [self setupToolbarButtons];//初始化input下方的工具栏
    }
    
    return self;
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

- (void)setupConstraints{
    // 使用VFL布局，VFL就是visual format language，也就是可视化格式语言。
    
    //先创建一个视图对象，后面要用。
    NSDictionary *views=NSDictionaryOfVariableBindings(_titleLabel,_textField);
    
    //下面这里，开始创建规则。
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textField]|" options:0 metrics:nil  views:views]];
    
    // 这里的VFL中，-8-表示八个单位这么宽，后面textField(40)表示它的高度是40单位。
    [self addConstraints:
       [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]-8-[_textField(40)]|"
                                               options:0
                                               metrics:nil
                                                 views:views]];
    
    
}

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

-(void)setupToolbarButtons{
    _buttonStack=[[UIStackView alloc]init];//分配空间
    _buttonStack.axis=UILayoutConstraintAxisHorizontal;//横向排列
    _buttonStack.distribution=UIStackViewDistributionFillEqually;
}

//还有的暂时先不写，看看效果

-(void)dealloc{
    // 释放的时候要移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
