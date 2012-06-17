//
//  CNAppDelegate.m
//  WWDC Sessions
//
//  Created by Frank Gregor on 16.06.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "CNAppDelegate.h"

#define kHTTPHeader202       @"200 OK"
#define kHTTPHeader404       @"404 Not Found"


@implementation CNAppDelegate

@synthesize window = _window;
@synthesize statusItem;
@synthesize statusItemMenu;
@synthesize userDefaults;
@synthesize prefsController;
@synthesize currentYear;
@synthesize sessionsAvailable;
@synthesize scheduler;
@synthesize sessionURL;



// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Initialization
// --------------------------------------------------------------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        self.currentYear = [dateFormatter stringFromDate:date];
        self.sessionsAvailable = NO;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(configurateScheduler) name:kDefaultsChangedNotificationKey object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    self.statusItemMenu = [[NSMenu alloc] init];
    
    [self.statusItemMenu addItemWithTitle:NSLocalizedString(@"About WWDCSessions", @"Statusbar Items") action:@selector(showAboutWindowAction:) keyEquivalent:@""];
    [self.statusItemMenu addItemWithTitle:NSLocalizedString(@"Preferences...", @"Statusbar Items") action:@selector(showPreferencesAction:) keyEquivalent:@""];
    [self.statusItemMenu addItem:[NSMenuItem separatorItem]];
    [self.statusItemMenu addItemWithTitle:NSLocalizedString(@"Beam me to the video pool...", @"Statusbar Items") action:@selector(beamToVideoPoolAction:) keyEquivalent:@""];
    [self.statusItemMenu addItem:[NSMenuItem separatorItem]];
    [self.statusItemMenu addItemWithTitle:NSLocalizedString(@"Quit WWDCSessions", @"Statusbar Items") action:@selector(terminate:) keyEquivalent:@""];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.highlightMode = YES;
    self.statusItem.target = self;
    self.statusItem.menu = self.statusItemMenu;
}



// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - NSApplication Delegate
// --------------------------------------------------------------------------------------------------------------------------

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self checkForSessions];
    [self configurateScheduler];
}



// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Helper
// --------------------------------------------------------------------------------------------------------------------------

- (void)configurateScheduler
{
    NSLog(@"defaultsChanged notification received.");
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger pollInterval;
    if ([self.userDefaults objectForKey:kCNPollFrequencyKey] != nil) {
        pollInterval = 60 * 60 * [self.userDefaults integerForKey:kCNPollFrequencyKey];
    } else {
        pollInterval = 60 * 60;
    }
    NSLog(@"poll interval is: %li seconds", pollInterval);
    self.scheduler = [NSTimer scheduledTimerWithTimeInterval:pollInterval
                                                      target:self 
                                                    selector:@selector(checkForSessions) 
                                                    userInfo:nil 
                                                     repeats:YES];
}

- (void)checkForSessions
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/curl"];
    
    self.sessionURL = [NSString stringWithFormat:kCNSessionVideosBaseURL, self.currentYear];
    NSArray *arguments = [NSArray arrayWithObjects: @"--silent", @"--head", self.sessionURL, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    [task setStandardInput:[NSPipe pipe]];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    NSString *resultString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSRange aRange;
    
    // check for 202
    aRange = [resultString rangeOfString:kHTTPHeader202];
    // no 202 received, so we check explicitly against 404
    if (aRange.location == NSNotFound) {
        //check for 404
        aRange = [resultString rangeOfString:kHTTPHeader404];
        // OK, we got a 404 - site not available
        if (aRange.location != NSNotFound) {
            self.sessionsAvailable = NO;
            self.statusItem.image = [NSImage imageNamed:@"WWDCSessions-Statusbaricon-Normal"];
            self.statusItem.alternateImage = [NSImage imageNamed:@"WWDCSessions-Statusbaricon-Highlight"];
            [[self.statusItemMenu itemAtIndex:2] setHidden:YES];
            [[self.statusItemMenu itemAtIndex:3] setHidden:YES];
        }

    // got HTTP header 202 - OK
    } else {
        self.sessionsAvailable = YES;
        self.statusItem.image = [NSImage imageNamed:@"WWDCSessions-Statusbaricon-Available"];
        self.statusItem.alternateImage = [NSImage imageNamed:@"WWDCSessions-Statusbaricon-Available"];
        [[self.statusItemMenu itemAtIndex:2] setHidden:NO];
        [[self.statusItemMenu itemAtIndex:3] setHidden:NO];
    }
}


// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Actions
// --------------------------------------------------------------------------------------------------------------------------

-(IBAction)showAboutWindowAction:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction)showPreferencesAction:(id)sender {
    if (!self.prefsController)
        self.prefsController = [[PreferencesController alloc] init];
    [NSApp activateIgnoringOtherApps:YES];
    [self.prefsController showWindow:self];
}

- (IBAction)beamToVideoPoolAction:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.sessionURL]];
}

@end
