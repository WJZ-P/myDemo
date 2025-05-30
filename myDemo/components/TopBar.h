#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopBar : UIView

// 按钮点击事件回调
@property (nonatomic, copy) void (^leftButtonAction)(void);
@property (nonatomic, copy) void (^rightButtonAction)(void);

// 初始化方法
- (instancetype)init;

// // 设置标题
// - (void)setTitle:(NSString *)title;

// // 设置左侧按钮
// - (void)setLeftButtonWithImage:(NSString *)imageName action:(void (^)(void))action;

// // 设置右侧按钮
// - (void)setRightButtonWithImage:(NSString *)imageName action:(void (^)(void))action;

@end

NS_ASSUME_NONNULL_END 