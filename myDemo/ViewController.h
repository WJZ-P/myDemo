//
//  ViewController.h
//  myDemo
//
//  Created by WJZ_P on 2025/5/19.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//存放一个约束，控制input区域的底部，同时当手机输入框弹出的时候需要动态更新
@property (nonatomic,strong)NSLayoutConstraint *inputViewBottomConstraint;

@end

