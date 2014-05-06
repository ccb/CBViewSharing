//
//  Server.m
//  DoThisNow
//
//  Created by Chris Burns on 4/28/14.
//  Copyright (c) 2014 Chris Burns. All rights reserved.
//

#import "CBServer.h"

#import "CBDefaults.h"

#import <AFNetworking/AFNetworking.h>

@interface CBServer ()

@property (strong) NSURL *baseAddress;
@property (nonatomic, strong) AFHTTPClient *http;

@end
@implementation CBServer

- (instancetype) initWithBaseAddress:(NSURL *) baseAddress {
    
    if (self = [super init]) {
        
        self.baseAddress = baseAddress;
        self.http = [AFHTTPClient clientWithBaseURL:self.baseAddress];
    }
    
    
    return self;
}


#pragma POST methods 
- (void) post:(NSString *) path withJSON:(NSDictionary *) json completion:(RequestCompletion) completion {
    
    NSMutableURLRequest *request = [self.http requestWithMethod:@"POST" path:REGISTRATION_ROUTE parameters:nil];
    AFJSONRequestOperation *registrationOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if(JSON) {
            completion(JSON, nil);
        }
        
        else {
            completion(nil, [NSError errorWithDomain:@"ViewSharingServer" code:404 userInfo:nil]);
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        completion(nil, error);
    }];
    
    [registrationOperation start];

}

- (void) post:(NSString *) path withData:(NSData *) data completion:(RequestCompletion) completion {
    
    NSString *completePath = [NSString stringWithFormat:@"/session/%@/%@", self.sessionIdentifier, path]; //how to provide the session identifier?
    
    NSMutableURLRequest *request = [self.http multipartFormRequestWithMethod:@"POST" path:completePath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
    }];
    
    //create an operation and dispatch it.
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completion(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        completion(nil, error);
    }];
    
    [operation start];
}

@end
