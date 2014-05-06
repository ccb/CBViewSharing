//
//  InputInjector.h
//  DoThisNow
//
//  Created by Chris Burns on 4/30/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBSocket;

@interface CBInputReceiver : NSObject

- (instancetype)initWithSharedViewController:(UIViewController *) sharedController socket:(CBSocket *) socket;

- (void) start;
- (void) stop; 
@end
