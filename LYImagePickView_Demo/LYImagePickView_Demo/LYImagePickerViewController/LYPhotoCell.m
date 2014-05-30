//
//  PhotoCell.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#import "LYPhotoCell.h"

@implementation LYPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.photoImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoImageButton.frame = CGRectMake(0, 0, Photo_Width, Photo_Width);
        [self addSubview:self.photoImageButton];
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.userInteractionEnabled = NO;
        self.selectButton.frame = CGRectMake(Photo_Width*0.6, Photo_Width*0.6, 22, 22);
        [self addSubview:self.selectButton];
    }
    return self;
}

@end
