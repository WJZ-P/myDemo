#import <UIKit/UIKit.h>
#import "../models/MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UIView *bubbleView;

- (void)configureWithMessage:(MessageModel *)message;

@end

NS_ASSUME_NONNULL_END 