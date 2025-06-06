#import "MessageCell.h"

@implementation MessageCell {
    NSLayoutConstraint *_bubbleRight;//约束布局
    NSLayoutConstraint *_bubbleLeft;
    NSLayoutConstraint *_imageAspectRatioConstraint; // 用于控制图片宽高比的约束
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中状态，不然选中效果很难看
        self.backgroundColor = [UIColor clearColor];

        // 创建气泡视图
        _bubbleView = [[UIView alloc] init];
        _bubbleView.layer.cornerRadius = 12;
        _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;//约束布局
        [self.contentView addSubview:_bubbleView];//添加气泡视图

        // 创建消息标签
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;//表示消息可以显示多行文本，0表示不限制行数
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;//约束布局
        [_bubbleView addSubview:_messageLabel];//添加文本消息
        
        // 创建图片视图
        _messageImageView = [[UIImageView alloc] init];
        _messageImageView.contentMode = UIViewContentModeScaleAspectFit;    //不要改变图片的宽高比例
        _messageImageView.layer.cornerRadius = 12; // 同样设置圆角
        _messageImageView.clipsToBounds = YES; // 必须设置，否则图片内容会溢出圆角
        _messageImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_bubbleView addSubview:_messageImageView];//添加图片消息

        // 只保留最大宽度约束
        [_bubbleView.widthAnchor constraintLessThanOrEqualToAnchor:self.contentView.widthAnchor multiplier:0.75].active = YES;

        // 气泡顶部和底部
        [_bubbleView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4].active = YES;
        [_bubbleView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4].active = YES;

        // 气泡左右约束（用户消息靠右，AI靠左，后续切换优先级即可）
        _bubbleRight = [_bubbleView.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.trailingAnchor constant:-16];
        _bubbleLeft = [_bubbleView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.leadingAnchor constant:16];
        // 默认激活用户消息右对齐
        _bubbleRight.active = YES;
        _bubbleLeft.active = NO;

        // 消息label约束
        [_messageLabel.topAnchor constraintEqualToAnchor:_bubbleView.topAnchor constant:8].active = YES;
        [_messageLabel.bottomAnchor constraintEqualToAnchor:_bubbleView.bottomAnchor constant:-8].active = YES;
        [_messageLabel.leadingAnchor constraintEqualToAnchor:_bubbleView.leadingAnchor constant:12].active = YES;
        [_messageLabel.trailingAnchor constraintEqualToAnchor:_bubbleView.trailingAnchor constant:-12].active = YES;
        
        // 图片视图约束
        [_messageImageView.topAnchor constraintEqualToAnchor:_bubbleView.topAnchor constant:8].active = YES;
        [_messageImageView.bottomAnchor constraintEqualToAnchor:_bubbleView.bottomAnchor constant:-8].active = YES;
        [_messageImageView.leadingAnchor constraintEqualToAnchor:_bubbleView.leadingAnchor constant:8].active = YES;
        [_messageImageView.trailingAnchor constraintEqualToAnchor:_bubbleView.trailingAnchor constant:-8].active = YES;

        // 拒绝被父视图拉伸
        [_bubbleView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    }
    return self;
}

- (void)configureWithMessage:(MessageModel *)message {
    // 设置气泡位置
    if (message.isUser) {
        _bubbleView.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        _messageLabel.textColor = [UIColor whiteColor];
        // 用户消息靠右
        _bubbleRight.active = YES;
        _bubbleLeft.active = NO;
    } else {
        _bubbleView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        _messageLabel.textColor = [UIColor blackColor];
        // AI消息靠左
        _bubbleLeft.active = YES;
        _bubbleRight.active = NO;
    }
    
    // 根据消息类型显示不同内容
    switch (message.type) {
        case MessageTypeText: {
            _messageLabel.text = (NSString *)message.content;
            _messageLabel.hidden = NO;
            _messageImageView.hidden = YES;
            break;
        }
        case MessageTypeImage: {
            UIImage *image = (UIImage *)message.content;
            _messageImageView.image = image;
            _messageLabel.hidden = YES;
            _messageImageView.hidden = NO;
            
            // 创建并激活新的宽高比约束
            if (image && image.size.width > 0) {
                CGFloat aspectRatio = image.size.height / image.size.width;
                _imageAspectRatioConstraint = [_messageImageView.heightAnchor constraintEqualToAnchor:_messageImageView.widthAnchor multiplier:aspectRatio];
                _imageAspectRatioConstraint.active = YES;
            }
            break;
        }
    }
}

// 添加 prepareForReuse 是一个好习惯，防止Cell复用时显示错乱
- (void)prepareForReuse {
    [super prepareForReuse];
    
    // 重置内容
    _messageLabel.text = nil;
    _messageImageView.image = nil;
    
    // 重置视图状态
    _messageLabel.hidden = YES;
    _messageImageView.hidden = YES;
    
    // 移除动态添加的约束
    if (_imageAspectRatioConstraint) {
        _imageAspectRatioConstraint.active = NO;
        _imageAspectRatioConstraint = nil;
    }
}

@end 
