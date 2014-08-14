//
//  PhotoItem.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-30.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#import "LYPhotoItem.h"

@implementation LYPhotoItem

- (id)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{isSelected = %d, \nasset = %@}", self.isSelected, self.asset];
}

@end
