#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopBar;

@protocol TopBarDelegate <NSObject>

@required
- (void)topBar:(TopBar *)topBar didTapSideBarButton:(UIButton *)button;
- (void)topBar:(TopBar *)topBar didTapNewChatButton:(UIButton *)button;

@end

@interface TopBar : UIView

@property (nonatomic, weak) id<TopBarDelegate> delegate;

// 初始化方法
- (instancetype)init;

// 设置标题
- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END 
