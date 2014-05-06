//
//  UIView+ImageRepresentation.m
//  PWMS
//
//  Created by Chris Burns on 11/14/13.
//  Copyright (c) 2013 Chris Burns. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>


#import "UIView+ImageRepresentation.h"

@implementation UIView (ImageRepresentation)


- (UIImage *) imageRepresentation

{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);

    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window.layer renderInContext:UIGraphicsGetCurrentContext()];
        
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return image;
}


@end
