#import <UIKit/UIKit.h>
#import "../models/MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageView : UIView

// 添加新消息的方法
- (void)addMessage:(MessageModel *)message;

// 清空所有消息
- (void)clearAllMessages;

@end

NS_ASSUME_NONNULL_END 