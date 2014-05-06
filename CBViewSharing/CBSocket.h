//
//  Socket.h
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBSocket;

@protocol SocketDelegate <NSObject>

- (void) socketDidAttach:(CBSocket *) socket;
- (void) socketDidDetach:(CBSocket *) socket; 

@end

@interface CBSocket : NSObject

typedef void (^MessageListener)(NSString *messageName, NSDictionary *messageArguments);

- (instancetype) initWithAddress:(NSURL *) address;

- (void) attachToSession:(NSString *) sessionIdentifier;
- (void) detatchFromSession;

- (void) listen:(NSString *)name withListener:(MessageListener)listener;

@property (weak) id<SocketDelegate> delegate;



@end
