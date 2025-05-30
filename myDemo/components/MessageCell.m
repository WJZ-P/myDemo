#import "MessageCell.h"

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        // 创建气泡视图
        _bubbleView = [[UIView alloc] init];
        _bubbleView.layer.cornerRadius = 12;
        _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bubbleView];
        
        // 创建消息标签
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_bubbleView addSubview:_messageLabel];
        
        // 设置约束
        [NSLayoutConstraint activateConstraints:@[
            [_bubbleView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4],
            [_bubbleView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4],
            [_bubbleView.widthAnchor constraintLessThanOrEqualToAnchor:self.contentView.widthAnchor multiplier:0.75],
            
            [_messageLabel.topAnchor constraintEqualToAnchor:_bubbleView.topAnchor constant:8],
            [_messageLabel.bottomAnchor constraintEqualToAnchor:_bubbleView.bottomAnchor constant:-8],
            [_messageLabel.leadingAnchor constraintEqualToAnchor:_bubbleView.leadingAnchor constant:12],
            [_messageLabel.trailingAnchor constraintEqualToAnchor:_bubbleView.trailingAnchor constant:-12]
        ]];
    }
    return self;
}

- (void)configureWithMessage:(NSString *)message isUser:(BOOL)isUser {
    _messageLabel.text = message;
    
    // 根据是否是用户消息设置不同的样式
    if (isUser) {
        _bubbleView.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        _messageLabel.textColor = [UIColor whiteColor];
        
        // 用户消息靠右
        [NSLayoutConstraint activateConstraints:@[
            [_bubbleView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
            [_bubbleView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.leadingAnchor constant:16]
        ]];
    } else {
        _bubbleView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        _messageLabel.textColor = [UIColor blackColor];
        
        // AI消息靠左
        [NSLayoutConstraint activateConstraints:@[
            [_bubbleView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
            [_bubbleView.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.trailingAnchor constant:-16]
        ]];
    }
}

@end 