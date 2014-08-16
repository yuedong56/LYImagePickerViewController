//
//  RootViewController.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#import "RootViewController.h"
#import "UIViewController+Rotate.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 120, 50);
    button.center = self.view.center;
    [button setTitle:@"Open Album" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
}

/** 打开相册 */
- (void)button:(UIButton *)button
{
    LYImagePickerViewController *vc = [[LYImagePickerViewController alloc] initWithShowType:ImageShowTypeSavedPhotos
                                                                                     maxNum:9];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:NULL];
}

#pragma mark - LYImagePickerViewController delegate
- (void)imageViewController:(LYImagePickerViewController *)imagePickerVC didFinishSelectAssets:(NSMutableArray *)assets
{
    NSLog(@"%s, items -- %@",__FUNCTION__, assets);

    [imagePickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imageViewControllerDidCancel:(LYImagePickerViewController *)imagePickerVC
{
    [imagePickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

