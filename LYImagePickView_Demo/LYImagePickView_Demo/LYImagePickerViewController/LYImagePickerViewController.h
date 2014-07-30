//
//  LYImagePickerViewController.h
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#define Cell_Height 80.0f

typedef enum {
    /** 显示相簿列表界面 */
    ImageShowTypeAlbum = 0,
    /** 显示相机胶卷界面 */
    ImageShowTypeSavedPhotos
} ImageShowType;

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LYAlbumItem.h"
#import "LYPhotoItem.h"
#import "LYPhotosViewController.h"

@protocol LYImagePickerViewControllerDelegate;
@interface LYImagePickerViewController : UITableViewController<PhotosVCDelegate>

/**
 * @brief 弹出时显示的页面
 * @param showType 两种显示方式，ImageShowTypeAlbum：显示相簿列表界面；ImageShowTypeDetail：显示相机胶卷界面
 */
@property (nonatomic, assign) ImageShowType showType;

@property (nonatomic, weak) id <LYImagePickerViewControllerDelegate> delegate;

/**
 * @brief 参数showType为ImageShowTypeAlbum时，显示相簿列表界面，ImageShowTypeDetail时，显示相机胶卷界面
*/
- (id)initWithShowType:(ImageShowType)showType;

@end


@protocol LYImagePickerViewControllerDelegate <NSObject>

/**
 * @brief 点击发送按钮（未dismiss相册页面就执行，即viewWillAppear执行前运行此代理方法）
 */
- (void)imageViewControllerView:(LYImagePickerViewController *)imagePickerVC willFinishSelectAssets:(NSMutableArray *)assets;

/**
 * @brief 点击发送按钮（dismiss相册页面后才执行，即viewWillAppear执行后运行此代理方法）
 */
- (void)imageViewControllerView:(LYImagePickerViewController *)imagePickerVC didFinishSelectAssets:(NSMutableArray *)assets;

@end
