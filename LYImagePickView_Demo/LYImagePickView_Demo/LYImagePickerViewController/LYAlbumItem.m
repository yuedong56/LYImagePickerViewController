//
//  AlbumItem.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#import "LYAlbumItem.h"

@implementation LYAlbumItem

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.photos = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

@end
