//
//  InputInjector.m
//  DoThisNow
//
//  Created by Chris Burns on 4/30/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import "CBInputReceiver.h"

#import "CBSocket.h"


@interface CBInputReceiver()

@property (weak, nonatomic) UIViewController *sharedViewController;
@property (weak, nonatomic) CBSocket *socket;

@property (strong, nonatomic) CALayer *overlay;
@property (assign, nonatomic) CGPoint currentMousePosition;

@end
@implementation CBInputReceiver


- (instancetype)initWithSharedViewController:(UIViewController *) sharedViewController socket:(CBSocket *) socket {
    
    NSParameterAssert(sharedViewController);
    NSParameterAssert(socket);
    
    if (self = [super init]) {
        
        self.sharedViewController = sharedViewController;
        self.socket = socket;
    }
    
    return self;
}

- (void) start {
    
    //create overlay layer to draw the mouse movements
    self.overlay = [CALayer new];
    self.overlay.delegate = self;
    self.overlay.backgroundColor = [[UIColor clearColor] CGColor];
    self.overlay.frame = self.sharedViewController.view.layer.frame;
    
    //add the overlay as a sublayer onto the existing view controller
    [self.sharedViewController.view.layer addSublayer:self.overlay];
    
    [self.socket listen:@"mouse-down" withListener:^(NSString *messageName, NSDictionary *messageArguments) {
        
        CGPoint mousePosition = [self parseMousePosition:messageArguments];
        [self drawMouseOnOverlay:mousePosition];
        
    }];
    
}

- (void) stop {
    
    //remove the sublayer from the share view controller
    [self.overlay removeFromSuperlayer];
    
    self.overlay = nil;
    
    //(TODO) how do you remove the listener associated with it? is it important?
    
}


#pragma mark Input Methods
- (void) drawMouseOnOverlay:(CGPoint) mousePosition {
    
    //the mouse point is set and will be 'picked up' the next time draw is called
    self.currentMousePosition = mousePosition;
    [self.overlay setNeedsDisplay];
}


#pragma marker Layer Delegate
- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    CGContextClearRect(ctx, layer.bounds);
    
    CGRect rectangle = CGRectMake(self.currentMousePosition.x, self.currentMousePosition.y, 10, 10);
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    CGContextSetFillColorWithColor(ctx, redColor.CGColor);
    CGContextFillRect(ctx, rectangle);
    
}

#pragma mark Utility Methods
- (CGPoint) parseMousePosition: (NSDictionary *) targetPoint {
    
    float xPercentage = [targetPoint[@"X"] floatValue];
    float yPercentage = [targetPoint[@"Y"] floatValue];
    
    float width = self.sharedViewController.view.frame.size.width;
    float height = self.sharedViewController.view.frame.size.height;
    
    
    
    return CGPointMake((xPercentage * width), (yPercentage * height));
}

@end
