//
//  Server.h
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBServer : NSObject

typedef void (^RequestCompletion)(NSDictionary *response, NSError *error);

- (void) post:(NSString *) path withJSON:(NSDictionary *) json completion:(RequestCompletion) completion;

- (void) post:(NSString *) path withData:(NSData *) data completion:(RequestCompletion) completion;


- (instancetype) initWithBaseAddress:(NSURL *) baseAddress;

@property (strong, nonatomic) NSString *sessionIdentifier;
@end
