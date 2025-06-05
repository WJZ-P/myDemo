#import "MessageModel.h"

@class UIImage;

@implementation MessageModel

+ (instancetype)textMessage:(NSString *)text isUser:(BOOL)isUser {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = MessageTypeText;
    model.isUser = isUser;
    model.content = text;
    return model;
}

+ (instancetype)imageMessage:(UIImage *)image isUser:(BOOL)isUser {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = MessageTypeImage;
    model.isUser = isUser;
    model.content = image;
    return model;
}

@end 
