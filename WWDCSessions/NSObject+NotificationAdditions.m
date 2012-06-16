//
//  NSObject+NotificationAdditions.h
//
//  Created by cocoa:naut on 28.09.11.
//  Copyright (c) 2012 cocoanaut.com. All rights reserved.
//

#import "NSObject+NotificationAdditions.h"


@implementation NSObject (NotificationAdditions)

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Notifications
// ---------------------------------------------------------------------------------------------------------------------

- (void)postNotificationName:(NSString*)notificationName userInfo:(NSDictionary*)userInfo
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:notificationName
						  object:self
						userInfo:userInfo];
}

@end
