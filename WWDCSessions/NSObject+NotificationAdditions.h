//
//  NSObject+NotificationAdditions.h
//
//  Created by cocoa:naut on 28.09.11.
//  Copyright (c) 2012 cocoanaut.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NotificationAdditions)

/**
 A simplified notification message.

 Creates a notification with a given name and information dictionary.
  
 @param notificationName: The name of the notification
 @param userInfo: A NSDictionary containing user specified informations.
 */
- (void)postNotificationName:(NSString*)notificationName userInfo:(NSDictionary*)userInfo;


@end
