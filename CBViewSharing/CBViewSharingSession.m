//
//  ViewSharingSession.m
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import "CBViewSharingSession.h"
#import "CBViewSharingSession_Private.h"

#import "CBSocket.h"

#import "CBInputReceiver.h"
#import "CBScreenCapturer.h"

@interface CBViewSharingSession () <SocketDelegate>

@property (strong) CBSocket *socket;

@property (strong) CBInputReceiver *inputReceiver;
@property (strong) CBScreenCapturer *screenCapturer;

@end

@implementation CBViewSharingSession


- (instancetype) initWithBaseAddress:(NSURL *) baseAddress {
    
    if (self = [super init]) {
        
        self.socket = [[CBSocket alloc] initWithAddress:baseAddress];
        self.socket.delegate = self; 
        self.state = Initialized;
        
    }
    return self;
}

//(1) start begins sharing by connecting the socket to the session
- (void) start {

    [self.socket attachToSession:self.identifier];
    
}

//(2) when the socket is sucessfully then we can consider the session 'created' properly
- (void) socketDidAttach:(CBSocket *)socket {
    
    self.state = Created;
    [self.delegate sessionWasCreated:self];
    
    __weak CBViewSharingSession *weakSession = self;
    
    [self.socket listen:@"started" withListener:^(NSString *messageName, NSDictionary *messageArguments) {
        
        [weakSession participantConnected];

    }];

}


//(3) when the socket reports a started message, the invitated participant has connected to the session
- (void) participantConnected {
    
    //create the classes required to forward input and capture the screen
    self.inputReceiver = [[CBInputReceiver alloc] initWithSharedViewController:self.sharedViewController socket:self.socket];
    [self.inputReceiver start];
    
    self.screenCapturer = [[CBScreenCapturer alloc] initWithSharedViewController:self.sharedViewController server:self.server];
    [self.screenCapturer start];
    
    //signal to the delegate that sharing has now started
    self.state = Started;
    [self.delegate sessionDidStartSharing:self];
    
}

- (void) socketDidDetach:(CBSocket *)socket {
    
    [self participantDisconnected];
    
}

//(4) if the user navigates away from the page, the invited participant is considered to have left the session
- (void) participantDisconnected {
    
    //stop the session
    [self stop];
    
    //inform the delegate that sharing has stopped
    [self.delegate sessionDidStopSharing:self];
}

//(5) once the host stops the session or the participant moves away from the display we shut down the input receiver and capturer and signle the end of the session
- (void) stop {
    
    //stop the input receiver and screen capturer
    [self.inputReceiver stop];
    
    [self.screenCapturer stop];
    
    //disconnect the socket
    [self.socket detatchFromSession];
    
    self.state = Stopped;
}

- (void) dealloc {
    
    
    
}
     
@end
