#import <Foundation/Foundation.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeText,
    MessageTypeImage
};

@interface MessageModel : NSObject

@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) BOOL isUser;
@property (nonatomic, strong) id content; // 文本消息是NSString，图片消息是UIImage

+ (instancetype)textMessage:(NSString *)text isUser:(BOOL)isUser;
+ (instancetype)imageMessage:(UIImage *)image isUser:(BOOL)isUser;

@end

NS_ASSUME_NONNULL_END 
