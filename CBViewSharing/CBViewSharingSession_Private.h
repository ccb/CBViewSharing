//
//  ViewSharingSession_Private.h
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import "CBViewSharingSession.h"

@class CBServer;

@interface CBViewSharingSession ()

@property (strong, readwrite) NSString *identifier;
@property (nonatomic, readwrite) SessionState state;

@property (weak, nonatomic) UIViewController *sharedViewController;
@property (weak, nonatomic) CBServer *server;

- (instancetype) initWithBaseAddress:(NSURL *) baseAddress; 

@end
