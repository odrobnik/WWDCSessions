//
//  PreferenceController.m
//  Days
//
//  Created by Frank Gregor on 15.06.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "PreferencesController.h"


typedef enum {
    toolbarItemTagGeneral       = 10
} toolbarItemTag;

#define CNPrefsToolbarItemGeneralItenfier  @"CNPrefsToolbarItemGeneralItenfier"

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Private method declaration
// ---------------------------------------------------------------------------------------------------------------------

@interface PreferencesController()
- (void)calculateSizeForView:(NSView *)subView;
- (void)restorePreferences;
- (void)defaultsChangedNotification;
@end



@implementation PreferencesController
@synthesize userDefaults;


// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Initialization
// ---------------------------------------------------------------------------------------------------------------------
-(id)init {
    self = [super initWithWindowNibName:@"Preferences"];
    if (self != nil) {
        [[self window] center];
    }
    return self;
}

-(void)awakeFromNib {
    [self changeView:toolbarItemGeneral];
    [[[self window] toolbar] setSelectedItemIdentifier:CNPrefsToolbarItemGeneralItenfier];
    
    // general preferences
    
    [self restorePreferences];
}



// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Helper
// ---------------------------------------------------------------------------------------------------------------------

- (void)restorePreferences {
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:kCNPollFrequencyKey] != nil) {
        [pollMatrix selectCellAtRow:[userDefaults integerForKey:kCNPollFrequencyKey]-1 column:0];
    }
}

- (void)defaultsChangedNotification
{
    [self postNotificationName:kDefaultsChangedNotificationKey userInfo:nil];
}



// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Actions
// ---------------------------------------------------------------------------------------------------------------------

- (IBAction)preferencesChangedAction:(id)sender
{
    if (sender == pollMatrix) {
        [userDefaults setInteger:pollMatrix.selectedRow+1 forKey:kCNPollFrequencyKey];
    }

    [self defaultsChangedNotification];
}

- (IBAction)changeView:(id)sender {
    NSView *aView = nil;
    switch ([sender tag]) 
    {
        case toolbarItemTagGeneral:     aView = viewGeneral; break;
    } 
    [[self window] setTitle: [sender paletteLabel]];
    [self calculateSizeForView: aView];
}




// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Private Methods
// ---------------------------------------------------------------------------------------------------------------------

- (void)calculateSizeForView:(NSView *)subView {
    NSRect windowFrame = [[self window] frame];
    NSRect contentViewFrame = [[[self window] contentView] frame];
    windowFrame.size.height = NSHeight([subView frame]) + (NSHeight(windowFrame) - NSHeight(contentViewFrame));
    windowFrame.size.width = NSWidth([subView frame]);
    windowFrame.origin.y = NSMinY(windowFrame) - (NSHeight([subView frame]) - NSHeight(contentViewFrame));
    
    if ([[contentView subviews] count] != 0) {
        [[[contentView subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    [[self window] setFrame: windowFrame display: YES animate: YES];
    [contentView setFrame: [subView frame]];
    [contentView addSubview: subView];
}

@end
