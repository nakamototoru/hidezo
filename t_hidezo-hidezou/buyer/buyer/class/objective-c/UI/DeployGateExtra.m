//
//  DeployGateExtra.m
//  buyer
//
//  Created by デザミ on 2016/09/05.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

#import "DeployGateExtra.h"
#import <DeployGateSDK/DeployGateSDK.h>

@implementation DeployGateExtra

+(void)DGSLog:(NSString*)text
{
	DGSLog(text);
}

+(instancetype)shared {

	static DeployGateExtra *instance = nil;
	if (instance == nil) {
		instance = [[DeployGateExtra alloc] init];
	}
	return instance;
}

@end
