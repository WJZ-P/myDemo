#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *bubbleView;

- (void)configureWithMessage:(NSString *)message isUser:(BOOL)isUser;

@end

NS_ASSUME_NONNULL_END 