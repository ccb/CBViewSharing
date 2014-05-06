//
//  Socket.m
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import "CBSocket.h"

#import <socket.IO/SocketIO.h>
#import <socket.IO/SocketIOPacket.h>

@interface CBSocket () <SocketIODelegate>

@property (strong) NSString *sessionIdentifier;
@property (strong) NSURL *address;

@property (strong) SocketIO *socket;
@property (strong) NSMutableDictionary *listeners;

@end

@implementation CBSocket

- (instancetype) initWithAddress:(NSURL *) address {
    
    if (self = [super init]) {
        self.address = address;
    }
    return  self;
}

//(1) connect to a socket exposed on the server
- (void) attachToSession:(NSString *) sessionIdentifier {
    
    self.sessionIdentifier = sessionIdentifier;
    
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    
    NSString *socketHost = [self.address host];
    NSNumber *socketPort = [self.address port];
    
    [self.socket connectToHost:socketHost onPort:[socketPort integerValue]];
}

//(2) when the socket has connected send an attach service message and when it returnes confirm that the service is now connected
- (void) socketIODidConnect:(SocketIO *)socket {
    
    /*once we have successfully connected we need to send the attach event using the session identifier when this returns then we have becomed attached */
    [self attachService];
    
}
//(3) send the attach message and fire the did attach method when it returns
- (void) attachService {
    
    [self.socket sendEvent:@"attach-service" withData:self.sessionIdentifier andAcknowledge:^(id argsData) {
        
        __weak CBSocket *weakSocket = self;
        
    
        self.listeners = [NSMutableDictionary new]; //listeners is only created at this stage, this is because it shouldn't be possible to attach to a listeners until this stage
    
        [weakSocket.delegate socketDidAttach:self];
        
    }];
}
//(4) wait for
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    
    NSDictionary *incomingEvent = [packet dataAsJSON];
    
    NSString *eventName = incomingEvent[@"name"];
    NSDictionary *eventArguments = [incomingEvent[@"args"] lastObject]; //(???) this might be problematic
    
    [self broadcast:eventName withArguments:eventArguments];
    
}

//(5) when the user wants to detach
- (void) detatchFromSession {
    
    [self.socket disconnect];
    
}
- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    
    [self.delegate socketDidDetach:self];
    
}

#pragma Listen & Broadcast Socket IO Messages
- (void) broadcast:(NSString *) name withArguments:(NSDictionary *) arguments {
    
    if(self.listeners[name]) {
        
        NSMutableArray *listenersForMessage = self.listeners[name];
        [listenersForMessage enumerateObjectsUsingBlock:^(MessageListener listener, NSUInteger index, BOOL *stop) {
            
            listener(name, arguments);
        }];
    }
}

- (void) listen:(NSString *)name withListener:(MessageListener)listener {
    
    if (!self.listeners) {
        
        return;
        
    }
    else if (self.listeners[name]) {
        
        [self.listeners[name] addObject:listener];
    }
    
    else {
        
        self.listeners[name] = [NSMutableArray arrayWithObject:listener];
    }
}






#pragma <#arguments#>


@end
