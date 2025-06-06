#import <UIKit/UIKit.h>
#import "../models/MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

// 定义消息操作按钮类型
typedef NS_ENUM(NSUInteger, MessageActionButtonType) {
    MessageActionButtonRetry,    // 重试按钮
    MessageActionButtonCopy,     // 复制按钮
    MessageActionButtonThumbUp,  // 点赞按钮
    MessageActionButtonThumbDown,// 点踩按钮
    MessageActionButtonSpeak,    // 语音播放按钮
    MessageActionButtonShare     // 分享按钮
};

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UIStackView *actionButtonStack;  // 操作按钮栈

- (void)configureWithMessage:(MessageModel *)message;

@end

NS_ASSUME_NONNULL_END 