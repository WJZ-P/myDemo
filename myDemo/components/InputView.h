//
//  myDemo
//
//  Created by WJZ_P on 2025/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 前向声明
@class InputView;

@protocol InputViewDelegate <NSObject>

@required
// 发送消息
- (void)inputView:(InputView *)inputView didSendMessage:(NSString *)message;

@end

@interface InputView : UIView

@property (nonatomic, weak) id<InputViewDelegate> delegate;

//通过block回调传递内容变化
@property (nonatomic,strong) void (^textChange)(NSString *text);

// 获取当前输入框文本
- (NSString *)currentText;

// 清空输入框
- (void)clearText;

@property (nonatomic, assign) BOOL isThinkButtonActive;
@property (nonatomic, assign) BOOL isOnlineButtonActive;

// 定义最大行数常量
extern const NSInteger kMaxInputLines;

@end

NS_ASSUME_NONNULL_END
