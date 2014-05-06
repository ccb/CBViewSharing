//
//  ViewSharing.m
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import "CBViewSharing.h"

#import "CBViewSharingSession.h"
#import "CBViewSharingSession_Private.h"
#import "CBServer.h"


@interface CBViewSharing ()

@property CBServer *server;
@property NSURL *baseAddress;

@end


@implementation CBViewSharing


- (instancetype) initWithBaseAddress:(NSString *) baseAddress {
    
    if (self = [super init]) {
        
        self.baseAddress = [NSURL URLWithString:baseAddress];
        self.server = [[CBServer alloc] initWithBaseAddress:self.baseAddress];
    }
    
    return self;
}

- (void) createSharingSessionWithViewController:(UIViewController *) sharedViewControlled completion:(SessionCreatedCompletion) completion {
    
    [self.server post:@"/session" withJSON:@{} completion:^(NSDictionary *response, NSError *error) {
        
        if(error) {
            
            NSLog(@"session create failed with error %@", error);
            completion(nil, nil, error);
            return;
        }
        
        //create a new sharing session
        CBViewSharingSession *session = [[CBViewSharingSession alloc] initWithBaseAddress:self.baseAddress];
        
        session.identifier = response[@"sessionIdentifier"];
        
        session.sharedViewController = sharedViewControlled; //(TODO) move this into a proper init
        session.server = self.server;
        
        self.server.sessionIdentifier = session.identifier; //(TODO) fix this...
        
        NSString *invitationURLString = [[self.baseAddress absoluteString] stringByAppendingFormat:@"/session/%@/invitation", session.identifier];
    
        completion(session, invitationURLString, nil);
        
    }];
    
}


@end
