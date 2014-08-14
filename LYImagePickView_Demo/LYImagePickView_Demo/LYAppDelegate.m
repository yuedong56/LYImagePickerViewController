//
//  LYAppDelegate.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#import "LYAppDelegate.h"
#import "RootViewController.h"

@implementation LYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [application setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 130, 100, 100)];
    logo.image = [UIImage imageNamed:@"laoyue.jpg"];
    [self.window addSubview:logo];
    
    self.window.rootViewController = [RootViewController new];
    
    return YES;
}

@end
