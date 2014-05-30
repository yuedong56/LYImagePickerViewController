//
//  UIViewController+Rotate.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-30.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#import "UIViewController+Rotate.h"

@implementation UIViewController (Rotate)

//ios5.X
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

//ios6.X and later
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
