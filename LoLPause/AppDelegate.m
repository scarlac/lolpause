//
//  AppDelegate.m
//  LoLPause
//
//  Created by Seph Soliman on 11/06/13.
//  Copyright (c) 2013 Seph Soliman. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self setAppPaused:NO];
	// Insert code here to initialize your application
	NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	[self setAppPollTimer:timer];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
	 
- (void)timerFireMethod:(NSTimer*)theTimer {
	[self pollLoL];
}

- (int) signalProcessWithName:(NSString*)processName andSignal:(int)signal {
	NSString *appName = processName;
	// http://www.manpagez.com/man/3/Signal/
	for(id app in [[NSWorkspace sharedWorkspace] runningApplications]) {
        if ([appName isEqualToString:[[app executableURL] lastPathComponent]]) {
            int pid = [app processIdentifier];
			int ret = kill(pid, signal);
			// 17 = stop (stop process. cannot be caught or ignored)
			// 19 = cont (discard signal. continue after stop)
			NSLog(@"signaling %d to process %d", ret, pid);
			return ret;
        }
    }
	return -1;
}

- (void) pollLoL {
	NSString *gameAppName = @"LeagueofLegends";
	for(id app in [[NSWorkspace sharedWorkspace] runningApplications]) {
        if ([gameAppName isEqualToString:[[app executableURL] lastPathComponent]]) {
			if(![self appPaused]) {
				[[self appIndicatorLabel] setStringValue:@"In-game / Interface paused"];
				[self pauseInterface:nil];
				[self setAppPaused:YES];
			}
			return;
        }
    }
	// interface not running
	if([self appPaused]) {
		[self resumeInterface:nil];
		[self setAppPaused:NO];
	}
	[[self appIndicatorLabel] setStringValue:@"Out of game"];
}

- (IBAction)pauseInterface:(id)sender {
	[self signalProcessWithName:@"LolClient" andSignal:17];
}

- (IBAction)resumeInterface:(id)sender {
	[self signalProcessWithName:@"LolClient" andSignal:19];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	[self resumeInterface:nil];
	return NSTerminateNow;
}

- (void)windowWillClose:(NSNotification *)notification {
	[[NSRunningApplication currentApplication] terminate];
}

@end
