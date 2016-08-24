//
//  UIWarning.h
//  videoapp01
//
//  Created by デザミ on 2015/10/29.
//  Copyright © 2015年 videoapp01. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@interface UIWarning : NSObject

+(void)Warning:(NSString *)message;

+(void)WarningWithTitle:(NSString*)title Message:(NSString*)message;

#pragma AlertView
+(void)AlertWithTitle:(NSString*)title Message:(NSString*)message Actions:(NSArray<UIAlertAction*>*)actions;

#pragma mark ActionSheets
+(void)ActionSheetWithTitle:(NSString*)title Message:(NSString*)message Actions:(NSArray<UIAlertAction*>*)actions;

#pragma mark タッチブロック
+(void)showTouchBlock;
+(void)dismissTouchBlock;

@end
