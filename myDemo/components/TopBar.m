#import "TopBar.h"

@interface TopBar()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation TopBar

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupUI {
    // 设置背景色
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建标题标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    // 创建左侧按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_leftButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    _leftButton.tintColor = [UIColor blackColor];
    _leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_leftButton addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
    
    // 创建右侧按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_rightButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    _rightButton.tintColor = [UIColor blackColor];
    _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_rightButton addTarget:self action:@selector(rightButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
    
    // 添加底部阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 2;
}

- (void)setupConstraints {
    // 设置标题标签约束
    [NSLayoutConstraint activateConstraints:@[
        [_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_titleLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor multiplier:0.6]
    ]];
    
    // 设置左侧按钮约束
    [NSLayoutConstraint activateConstraints:@[
        [_leftButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [_leftButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_leftButton.widthAnchor constraintEqualToConstant:44],
        [_leftButton.heightAnchor constraintEqualToConstant:44]
    ]];
    
    // 设置右侧按钮约束
    [NSLayoutConstraint activateConstraints:@[
        [_rightButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [_rightButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_rightButton.widthAnchor constraintEqualToConstant:44],
        [_rightButton.heightAnchor constraintEqualToConstant:44]
    ]];
}

#pragma mark - Button Actions

- (void)leftButtonTapped {
    if (self.leftButtonAction) {
        self.leftButtonAction();
    }
}

- (void)rightButtonTapped {
    if (self.rightButtonAction) {
        self.rightButtonAction();
    }
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end 