//
//  ViewSharing.h
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CBViewSharingSession.h"


@interface CBViewSharing : NSObject

typedef void (^SessionCreatedCompletion)(CBViewSharingSession *session, NSString *invitationURL, NSError *error);

- (instancetype) initWithBaseAddress:(NSString *) baseAddress;

- (void) createSharingSessionWithViewController:(UIViewController *) sharedViewControlled completion:(SessionCreatedCompletion) completion;



@end
