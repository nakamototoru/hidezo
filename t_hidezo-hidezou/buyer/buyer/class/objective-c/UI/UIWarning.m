//
//  UIWarning.m
//  videoapp01
//
//  Created by デザミ on 2015/10/29.
//  Copyright © 2015年 videoapp01. All rights reserved.
//

#import "UIWarning.h"

@implementation UIWarning

+(UIViewController*)getBaseViewController:(NSInteger)dummy
{
	// 親ビューコンをなんとか検索
	UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
		baseView = baseView.presentedViewController;
	}
	return baseView;
}

// 警告を表示します。OKボタンタップで閉じます。
+(void)Warning:(NSString *)message
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	
	// 親ビューコンをなんとか検索
	UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
		baseView = baseView.presentedViewController;
	}
	[baseView presentViewController:alert animated:YES completion:nil];
}

+(void)WarningWithTitle:(NSString*)title Message:(NSString*)message
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	
	// 親ビューコンをなんとか検索
	UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
		baseView = baseView.presentedViewController;
	}
	[baseView presentViewController:alert animated:YES completion:nil];
}

#pragma AlertView
+(void)AlertWithTitle:(NSString*)title Message:(NSString*)message Actions:(NSArray<UIAlertAction*>*)actions
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	for (UIAlertAction* act in actions) {
		[alert addAction:act];
	}
	
	//[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	
	// 親ビューコンをなんとか検索
	UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
		baseView = baseView.presentedViewController;
	}
	[baseView presentViewController:alert animated:YES completion:nil];
}

#pragma mark ActionSheets
+(void)ActionSheetWithTitle:(NSString*)title Message:(NSString*)message Actions:(NSArray<UIAlertAction*>*)actions
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
	
	for (UIAlertAction* act in actions) {
		[alert addAction:act];
	}
	/*
	 [alertController addAction:
	 [UIAlertAction actionWithTitle:@"はい"
	 style:UIAlertActionStyleDefault
	 handler:^(UIAlertAction *action) {
		NSLog(@"はい");
	 }
	 ]
	 ];
	 
	 [alertController addAction:
	 [UIAlertAction actionWithTitle:@"いいえ"
	 style:UIAlertActionStyleDefault
	 handler:^(UIAlertAction *action) {
	 NSLog(@"いいえ");
	 }
	 ]
	 ];
	 */
	
	// 親ビューコンをなんとか検索
	UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
		baseView = baseView.presentedViewController;
	}
	[baseView presentViewController:alert animated:YES completion:nil];
}

#pragma mark タッチブロック
+(void)showTouchBlock
{
//	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//	[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
	
	// 親ビューコンをなんとか検索
	UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
		baseView = baseView.presentedViewController;
	}
	
	UIView *view = [UIWarning sharedView];
	view.frame = CGRectMake(0, 0, baseView.view.frame.size.width, baseView.view.frame.size.height);
	view.backgroundColor = [UIColor lightGrayColor];
	view.alpha = 0.5;
	[baseView.view addSubview:view];
	
	//[baseView presentViewController:alert animated:YES completion:nil];
}

+(void)dismissTouchBlock
{
	UIView *view = [UIWarning sharedView];
	[view removeFromSuperview];
	[UIWarning sharedView];
}

+(UIView*)sharedView
{
	static UIView *view = nil;
	if (view == nil) {
		view = [[UIView alloc] init];
	}
	else {
		if ([view.superview isDescendantOfView:view]) {
			
		}
		else {
			view = nil;
		}
	}
	return view;
}

@end
