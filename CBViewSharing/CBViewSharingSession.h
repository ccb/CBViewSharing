//
//  ViewSharingSession.h
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBViewSharingSession;

@protocol CBViewSharingSessionDelegate <NSObject>

-(void) sessionWasCreated:(CBViewSharingSession *) session;
-(void) sessionDidStartSharing:(CBViewSharingSession *) session;
-(void) sessionDidStopSharing:(CBViewSharingSession *) session;
-(void) session:(CBViewSharingSession *) session didFailWithError:(NSError *) error;
@end


@interface CBViewSharingSession : NSObject

typedef enum SessionState {
    
    //these states occur ...
    Initialized, //once the session object has been initialized but before it has been connected on the server
    Created, //once the application has received a session identifier but has not connected
    Started, //once the client (i.e. the remote user) has become attached and the session is session has actually started
    Stopped, //once the user has chosen to end the session or if it is automatically closed by leaving
    Failed //once something (e.g. web sockets, no registration, etc) has causes the session to fatally not work
    
} SessionState;

@property (strong, readonly) NSString *identifier;
@property (readonly) SessionState state;

@property (weak) id<CBViewSharingSessionDelegate> delegate;

- (void) start;
- (void) stop;

@end
