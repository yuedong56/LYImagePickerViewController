//
//  LYPhotosViewController.h
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#define ControlView_Height 50.0f

#import <UIKit/UIKit.h>
#import "LYAlbumItem.h"
#import "LYPhotoItem.h"

#define kPreStatusBarStyle @"kPreStatusBarStyle"

@protocol PhotosVCDelegate;
@class ControlView;
@interface LYPhotosViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int maxPhotoNumber;   //最大选择照片数目
}
@property (nonatomic, strong) LYAlbumItem *albumItem;
@property (nonatomic, strong) UICollectionView *photoCollectView;
@property (nonatomic, strong) ControlView *controlView;

@property (nonatomic, weak) id <PhotosVCDelegate> delegate;

/** 存储选中的图片 */
@property (nonatomic, strong) NSMutableArray *selectItems;

- (id)initWithItem:(LYAlbumItem *)item maxNum:(int)maxNum;

- (void)reloadData;

@end



#pragma mark - 发送按钮所在界面
@interface  ControlView: UIView

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *doneButton;

- (instancetype)initWithFrame:(CGRect)frame maxNum:(int)maxNum;

@end



@protocol PhotosVCDelegate <NSObject>

/** 点击发送按钮 */
- (void)photosViewController:(LYPhotosViewController *)photoVC didFinishSelectAssets:(NSMutableArray *)assets;

/** 点击取消按钮 */
- (void)photosViewControllerDidCancel:(LYPhotosViewController *)photoVC;

@end

