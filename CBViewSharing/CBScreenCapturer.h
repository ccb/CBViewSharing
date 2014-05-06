//
//  ScreenCapturer.h
//  DoThisNow
//
//  Created by Chris Burns on 4/30/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBServer;
@interface CBScreenCapturer : NSObject

- (instancetype)initWithSharedViewController:(UIViewController *) sharedViewController server:(CBServer *) server;

- (void) start;
- (void) stop;

@end
