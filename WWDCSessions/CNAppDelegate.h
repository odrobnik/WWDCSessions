//
//  CNAppDelegate.h
//  WWDCSessions
//
//  Created by Frank Gregor on 16.06.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"

@interface CNAppDelegate : NSObject <NSApplicationDelegate> {
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenu *statusItemMenu;
@property (nonatomic, strong) PreferencesController *prefsController;
@property (nonatomic, strong) NSString *currentYear;
@property (nonatomic, assign) BOOL sessionsAvailable;
@property (nonatomic, strong) NSTimer *scheduler;
@property (nonatomic, strong) NSString *sessionURL;


@end
