//
//  AppDelegate.h
//  LoLPause
//
//  Created by Seph Soliman on 11/06/13.
//  Copyright (c) 2013 Seph Soliman. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
@property (weak) IBOutlet NSTextField *appIndicatorLabel;

@property (assign) IBOutlet NSWindow *window;

- (IBAction)pauseInterface:(id)sender;
- (IBAction)resumeInterface:(id)sender;

@property (weak) NSTimer *appPollTimer;
@property BOOL appPaused;

@end
