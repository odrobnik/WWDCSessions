//
//  PreferenceController.h
//  Days
//
//  Created by Frank Gregor on 15.06.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController <NSToolbarDelegate> {
    // general stuff
    IBOutlet NSView         *contentView;
    
    IBOutlet NSToolbarItem  *toolbarItemGeneral;
    IBOutlet NSView         *viewGeneral;
    
    IBOutlet NSMatrix       *pollMatrix;
}

@property (nonatomic, strong) NSUserDefaults *userDefaults;

- (IBAction)changeView:(id)sender;
- (IBAction)preferencesChangedAction:(id)sender;

@end
