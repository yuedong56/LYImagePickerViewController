//
//  AlbumItem.h
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

#define IOS7_And_Later (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? YES : NO)

#import <Foundation/Foundation.h>

@interface LYAlbumItem : NSObject

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *posterImage;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *persistentID;
@property (nonatomic, strong) NSURL *URL;

@end