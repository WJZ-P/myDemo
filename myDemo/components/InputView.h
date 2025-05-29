//
//  UIView+InputView.h
//  myDemo
//
//  Created by WJZ_P on 2025/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InputViewDelegate <NSObject>


@end

@interface InputView :UIView
//
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

//通过block回调传递内容变化
@property (nonatomic,strong) void (^textChange)(NSString *text);

@property (nonatomic, assign) BOOL isThinkButtonActive;
@property (nonatomic, assign) BOOL isOnlineButtonActive;
@end

NS_ASSUME_NONNULL_END
