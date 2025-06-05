//
//  main.m
//  myDemo
//
//  Created by WJZ_P on 2025/5/19.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    NSLog(@"应用启动成功。");
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
