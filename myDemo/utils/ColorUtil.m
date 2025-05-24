//
//  UIColor+UIColor_HexString.m
//  myDemo
//
//  Created by WJZ_P on 2025/5/23.
//

#import "ColorUtil.h"

@implementation UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    //先对输入的字符串做预处理
    NSString *cleanString=[hexString stringByReplacingOccurrencesOfString:(@"#") withString:@""];
    // 对去掉#后的长度做判断，长度不符合就返回默认的颜色。
    if([cleanString length]!=6){
        return [UIColor blackColor];
    }
    
    // 下面分别取出rgb三种颜色
    NSString *rString=[cleanString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString=[cleanString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString=[cleanString substringWithRange:NSMakeRange(4, 2)];
    
    // 做一个进制转换
    unsigned int rHex,gHex,bHex;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&rHex]; // 扫描红色部分
    [[NSScanner scannerWithString:gString] scanHexInt:&gHex]; // 扫描绿色部分
    [[NSScanner scannerWithString:bString] scanHexInt:&bHex]; // 扫描蓝色部分
    
    return [UIColor colorWithRed:((CGFloat)rHex / 255.0f)
                           green:((CGFloat)gHex / 255.0f)
                            blue:((CGFloat)bHex / 255.0f)
                           alpha:1.0f];
}

@end
