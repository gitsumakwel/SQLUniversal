//
//  Facebook.m
//  AssignmentManager
//
//  Created by ジャスペル on 9/18/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import "Facebook.h"
@implementation Facebook

[FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_location",@"user_birthday",@"user_hometown"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
    switch(state) {
        case FBSessionStateOpen:
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                if(error) {
                    NSLog(@"error: %@", error);
                } else {
                    //retrieve user's details here as shown below
                    NSLog(@"FB user first name: %@", user.first_name);
                    NSLog(@"FB user  last name: %@", user.last_name);
                    NSLog(@"FB user   birthday: %@", user.birthday);
                    NSLog(@"FB user   location: %@", user.location);
                    NSLog(@"FB user   username: %@", user.username);
                    NSLog(@"            gender: %@", [user objectForKey:@"gender"]);
                    NSLog(@"             email: %@", [user objectForKey:@"email"]);
                    NSLog(@"          Location: %@", [NSString stringWithFormat:@"%@\n\n",user.location[@"name"]]);
                } //else
            }];
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default: break;
    }
}];

@end
