//
//  UIView+InputView.h
//  myDemo
//
//  Created by WJZ_P on 2025/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputView :UIView
//
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

//通过block回调传递内容变化
@property (nonatomic,strong) void (^textChange)(NSString *text);
@end

NS_ASSUME_NONNULL_END
