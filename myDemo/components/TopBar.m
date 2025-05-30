#import "TopBar.h"
#import "../utils/ColorUtil.h"

@interface TopBar()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *YBSideBarButton;
@property (nonatomic, strong) UIButton *YBNewChatButton;
@property (nonatomic, strong) CALayer *bottomBorder;

@end

@implementation TopBar

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupUI];
        [self setupConstraints];
        
        // 设置默认标题
        [self setTitle:@"超级无敌腾讯元宝"];
        
        // 设置默认按钮事件
        self.YBSideBarButtonAction = ^{
            NSLog(@"点击了侧边栏");
        };
        
        self.YBNewChatButtonAction = ^{
            NSLog(@"点击了新建聊天");
        };
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupUI {
    // 设置背景色
    self.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
    // 创建底部边框线
    _bottomBorder = [CALayer layer];
    _bottomBorder.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.layer addSublayer:_bottomBorder];
    
    // 创建标题标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    // 创建侧边栏按钮
    _YBSideBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_YBSideBarButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    _YBSideBarButton.tintColor = [UIColor blackColor];
    _YBSideBarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_YBSideBarButton addTarget:self action:@selector(YBSideBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_YBSideBarButton];
    
    // 创建新建聊天按钮
    _YBNewChatButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_YBNewChatButton setImage:[UIImage systemImageNamed:@"plus.bubble"] forState:UIControlStateNormal];
    _YBNewChatButton.tintColor = [UIColor blackColor];
    _YBNewChatButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_YBNewChatButton addTarget:self action:@selector(YBNewChatButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_YBNewChatButton];
}

- (void)setupConstraints {
    // 设置标题标签约束
    [NSLayoutConstraint activateConstraints:@[
        [_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_titleLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor multiplier:0.6]
    ]];
    
    // 设置侧边栏按钮约束
    [NSLayoutConstraint activateConstraints:@[
        [_YBSideBarButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [_YBSideBarButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_YBSideBarButton.widthAnchor constraintEqualToConstant:44],
        [_YBSideBarButton.heightAnchor constraintEqualToConstant:44]
    ]];
    
    // 设置新建聊天按钮约束
    [NSLayoutConstraint activateConstraints:@[
        [_YBNewChatButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [_YBNewChatButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_YBNewChatButton.widthAnchor constraintEqualToConstant:44],
        [_YBNewChatButton.heightAnchor constraintEqualToConstant:44]
    ]];
}

#pragma mark - Button Actions

- (void)YBSideBarButtonTapped {
    if (self.YBSideBarButtonAction) {
        self.YBSideBarButtonAction();
    }
}

- (void)YBNewChatButtonTapped {
    if (self.YBNewChatButtonAction) {
        self.YBNewChatButtonAction();
    }
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新底部边框线的frame
    _bottomBorder.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

@end 