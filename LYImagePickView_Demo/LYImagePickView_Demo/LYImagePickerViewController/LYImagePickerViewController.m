//
//  LYImagePickerViewController.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#import "LYImagePickerViewController.h"

@interface LYImagePickerViewController ()

/** 所有相簿的数组 */
@property (nonatomic, strong) NSMutableArray *albums;

@property (nonatomic, strong) LYPhotosViewController *savePhotosVC;

@end

@implementation LYImagePickerViewController

- (instancetype)initWithShowType:(ImageShowType)showType
{
    self = [super init];
    if (self)
    {
        self.albums = [NSMutableArray arrayWithCapacity:0];
        self.showType = showType;
        self.title = @"相簿";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if (self.showType == ImageShowTypeAlbum)
    {
        [self reloadAlbumData];
    }
    else if (self.showType == ImageShowTypeSavedPhotos)
    {
        self.savePhotosVC = [[LYPhotosViewController alloc] init];
        self.savePhotosVC.delegate = self;
        [self.navigationController pushViewController:self.savePhotosVC animated:YES];
        [self reloadSavedPhotosData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.showType==ImageShowTypeSavedPhotos && !self.albums.count)
    {
        [self reloadAlbumData];
    }
}

/** 获取相簿信息，并刷新列表
 * ALAssetsGroupLibrary        ...
 * ALAssetsGroupAlbum          来自我的电脑或者是在设备上创建
 * ALAssetsGroupEvent          ...
 * ALAssetsGroupFaces          ...
 * ALAssetsGroupSavedPhotos    相机胶卷
 * ALAssetsGroupPhotoStream    我的照片流
 * ALAssetsGroupAll            全部相簿
 */
- (void)reloadAlbumData
{
    [[self defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                               usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         LYAlbumItem *albumItem = [[LYAlbumItem alloc] init];
         albumItem.name = [group valueForProperty:ALAssetsGroupPropertyName];
         albumItem.posterImage = [[UIImage alloc] initWithCGImage:group.posterImage];
         albumItem.type = [group valueForProperty:ALAssetsGroupPropertyType];
         albumItem.persistentID = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
         albumItem.URL = [group valueForProperty:ALAssetsGroupPropertyURL];
         
         [group enumerateAssetsUsingBlock:^(ALAsset *resultAlAsset, NSUInteger index, BOOL *stop)
          {
              NSString *assetType = [resultAlAsset valueForProperty:ALAssetPropertyType];
              if ([assetType isEqualToString:ALAssetTypePhoto]) {
                  LYPhotoItem *photoItem = [[LYPhotoItem alloc] initWithAsset:resultAlAsset];
                  [albumItem.photos addObject:photoItem];
              }
              if (index == group.numberOfAssets-1) {
                  *stop = YES;
                  [self.albums addObject:albumItem];
                  [self.tableView reloadData];//IOS7以下要加句这个，不知道为啥
              }
          }];
     } failureBlock:^(NSError *error) {
         
     }];
}

/** 刷新相机胶卷列表 */
- (void)reloadSavedPhotosData
{
    [[self defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                               usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         LYAlbumItem *albumItem = [[LYAlbumItem alloc] init];
         albumItem.name = [group valueForProperty:ALAssetsGroupPropertyName];
         albumItem.posterImage = [[UIImage alloc] initWithCGImage:group.posterImage];
         albumItem.type = [group valueForProperty:ALAssetsGroupPropertyType];
         albumItem.persistentID = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
         albumItem.URL = [group valueForProperty:ALAssetsGroupPropertyURL];
         
         [group enumerateAssetsUsingBlock:^(ALAsset *resultAlAsset, NSUInteger index, BOOL *stop)
          {
              NSString *assetType = [resultAlAsset valueForProperty:ALAssetPropertyType];
              if ([assetType isEqualToString:ALAssetTypePhoto]) {
                  LYPhotoItem *photoItem = [[LYPhotoItem alloc] initWithAsset:resultAlAsset];
                  [albumItem.photos addObject:photoItem];
              }
              if (index == group.numberOfAssets-1) {
                  *stop = YES;
                  self.savePhotosVC = [self.savePhotosVC initWithItem:albumItem];
                  [self.savePhotosVC reloadData];
              }
          }];
     } failureBlock:^(NSError *error) {
         
     }];
}

#pragma mark - button Events
- (void)cancelButtonClick:(id)object
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma uitableView datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 2;
    }
    
    LYAlbumItem *item = [self.albums objectAtIndex:indexPath.row];
    cell.imageView.image = item.posterImage;
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"共 (%d) 张",item.photos.count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LYAlbumItem *item = [self.albums objectAtIndex:indexPath.row];
    LYPhotosViewController *vc = [[LYPhotosViewController alloc] initWithItem:item];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LYPhotosVC delegate
- (void)photosViewController:(LYPhotosViewController *)photoVC didFinishSelectAssets:(NSMutableArray *)assets
{
    [self.delegate imageViewControllerView:self willFinishSelectAssets:assets];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate imageViewControllerView:self didFinishSelectAssets:assets];
    }];
}

/**
 * @brief 获取photo句柄单例
 */
- (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
      library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
