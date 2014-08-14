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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *photoLibrary = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoLibrary.frame = CGRectMake(0, 0, 100, 40);
    photoLibrary.center = CGPointMake(160, 240);
    [photoLibrary setTitle:@"相册" forState:UIControlStateNormal];
    photoLibrary.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:photoLibrary];
    [photoLibrary addTarget:self action:@selector(photoLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
}

/** 打开相册 */
- (void)photoLibraryButton:(UIButton *)button
{
    LYImagePickerViewController *vc = [[LYImagePickerViewController alloc] initWithShowType:ImageShowTypeSavedPhotos
                                                                                     maxNum:9];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)imageViewControllerView:(LYImagePickerViewController *)imagePickerVC didFinishSelectAssets:(NSMutableArray *)assets
{
    NSLog(@"items -- %@",assets);
}

@end
