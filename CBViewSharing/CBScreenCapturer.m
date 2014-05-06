//
//  ScreenCapturer.m
//  DoThisNow
//
//  Created by Chris Burns on 4/30/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#define IMAGE_QUALITY 0.05

#import "CBScreenCapturer.h"

#import "CBServer.h"

#import "UIView+ImageRepresentation.h"

@interface CBScreenCapturer ()

@property (weak, nonatomic) UIViewController *sharedViewController;
@property (weak, nonatomic) CBServer *server;

@property (strong) NSOperationQueue *encodingQueue;
@property (assign) BOOL capturing;

@end

@implementation CBScreenCapturer


- (instancetype)initWithSharedViewController:(UIViewController *) sharedViewController server:(CBServer *) server {

    NSParameterAssert(sharedViewController);
    NSParameterAssert(server);
    
    if (self = [super init]) {
        
        self.sharedViewController = sharedViewController;
        self.server = server;
        self.encodingQueue = [NSOperationQueue new];
    }
    
    return self;
}

- (void) start {
    
    self.capturing = YES;
    [self captureScreen:0];
    
}
- (void) stop {
    
    self.capturing = NO;
}

#pragma mark Capturing Methods

- (void)captureScreen: (int) sequenceNumber {
    
    NSBlockOperation *encodeOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        __block UIImage *capturedImaged;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            capturedImaged = [self.sharedViewController.view imageRepresentation];
            
        });
        
        UIImage *capturedImage = [self.sharedViewController.view imageRepresentation];
        NSData *encodedImaged = UIImageJPEGRepresentation(capturedImage, IMAGE_QUALITY);
        
        NSString *path = [NSString stringWithFormat:@"screen/%i", sequenceNumber];
        [self.server post:path withData:encodedImaged completion:^(NSDictionary *response, NSError *error) {
            
            if (error) {
                NSLog(@"error with posting image");
            }
        }];
        
    }];
    
    [encodeOperation setCompletionBlock:^{
        
        if(self.capturing) {
            [self captureScreen:(sequenceNumber + 1)];
        }
    }];
    
    [self.encodingQueue addOperation:encodeOperation];
}

- (void) dealloc {
    
    
}
@end
