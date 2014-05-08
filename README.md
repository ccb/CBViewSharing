CBViewSharing is an API which allows developers to add view sharing to their application. With applications running on the desktop users can often get help by sharing their screen with someone who can help them. So far this isn't possible on the iPad or iPhone. This project attempts to rectify this situation by allowing developers to provide view sharing for their specific app but not the whole screen. 

This project is still in its early stages and shouldn't be used for any production environments.

#Getting Started

The SDK required for iOS is provided via Cocoapods. The server component can be found [here](https://github.com/ccb/ViewSharingServer).
Podfile 

```ruby

platform :ios '7.0'
pod "CBViewSharing", "0.0.1"


```


#Usage

To use CBViewSharing you must create an `CBViewSharing` object by providing a base URL to your server. 

```objective-c

[[CBViewSharing alloc] initWithBaseAddress:@"http://your-server:3000"];

```

From this you can request a session and a invitation URL to provide to your users. This is done with a block which can potentially fail with an `NSError`. When the session is returned you should cache it, start it and set a delegate.

```objective-c

[self.viewSharing createSharingSessionWithViewController:self completion:^(CBViewSharingSession *session, NSString *invitationURL, NSError *error) {
        
	[session start];
	session.delegate = weakSelf;

	weakSelf.currentSharingSession = session;
        
}];

```

As the session is used the delegate will report various state transitions. For example, when the participant opens the URL the session will fire the `sessionDidStartSharing:` message, likewise when it ends the `sessionDidStopSharing:` message is sent. Sessions can only be used once and will stop if the user cancels it (which should be supported) or if the participant navigates away from the page displaying the view.

```objective-c

-(void) sessionWasCreated:(CBViewSharingSession *) session;
-(void) sessionDidStartSharing:(CBViewSharingSession *) session;
-(void) sessionDidStopSharing:(CBViewSharingSession *) session;
-(void) session:(CBViewSharingSession *) session didFailWithError:(NSError *) error;

```



