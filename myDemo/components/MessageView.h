#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageView : UIView

// 添加新消息的方法
- (void)addMessage:(NSString *)message isUser:(BOOL)isUser;

// 清空所有消息
- (void)clearAllMessages;

@end

NS_ASSUME_NONNULL_END 