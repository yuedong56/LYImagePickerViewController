//
//  LYPhotosViewController.m
//  LYImagePickView_Demo
//
//  Created by 老岳 on 14-5-29.
//  Copyright (c) 2014年 老岳. All rights reserved.
//

#define CellReuseIdentifier @"CellReuseIdentifier"

#import "LYPhotosViewController.h"
#import "LYPhotoCell.h"

@interface LYPhotosViewController ()

@end

@implementation LYPhotosViewController

- (instancetype)initWithItem:(LYAlbumItem *)item
{
    self = [super init];
    if (self) {
        self.albumItem = item;
        self.title = item.name;
        self.selectItems = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self initPhotoCollectionView];
    [self initControlView];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNumber *preStatusBarStyle = [NSNumber numberWithInt:[[UIApplication sharedApplication] statusBarStyle]];
    [[NSUserDefaults standardUserDefaults] setObject:preStatusBarStyle forKey:kPreStatusBarStyle];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    UIStatusBarStyle preStatusBarStyle = [[[NSUserDefaults standardUserDefaults] objectForKey:kPreStatusBarStyle] intValue];
    [[UIApplication sharedApplication] setStatusBarStyle:preStatusBarStyle];
}

- (void)initPhotoCollectionView
{
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(Photo_Width, Photo_Width)];    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    collectionViewLayout.minimumInteritemSpacing = 2;
    collectionViewLayout.minimumLineSpacing = 2;
    
    self.photoCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-ControlView_Height-(IOS7_And_Later?0:64)) collectionViewLayout:collectionViewLayout];
    self.photoCollectView.backgroundColor = [UIColor whiteColor];
    [self.photoCollectView registerClass:[LYPhotoCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    
    self.photoCollectView.delegate = self;
    self.photoCollectView.dataSource = self;
    
    [self.view addSubview:self.photoCollectView];
}

- (void)initControlView
{
    self.controlView = [[ControlView alloc] initWithFrame:CGRectMake(0, self.photoCollectView.frame.size.height, Screen_Width, ControlView_Height)];
    [self.controlView.doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.controlView];
}

- (void)reloadData
{
    [self.photoCollectView reloadData];
    
    if (self.albumItem.photos.count)
    {
        [self.photoCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.albumItem.photos.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

#pragma mark - button Events
- (void)cancelButtonClick:(id)object
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Button Events
/** 选择某张图片 触发事件 */
- (void)photoButtonPress:(UIButton *)button event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.photoCollectView];
    NSIndexPath *indexPath = [self.photoCollectView indexPathForItemAtPoint:currentTouchPosition];
    
    if (indexPath)
    {
        LYPhotoItem *item = [self.albumItem.photos objectAtIndex:indexPath.row];
        
        if (self.selectItems.count<MaxPhotoNum || item.isSelected)
        {
            item.isSelected = !item.isSelected;
            if (item.isSelected) {
                [self.selectItems addObject:item.asset];
            } else {
                [self.selectItems removeObject:item.asset];
            }
            
            [self.photoCollectView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }
        else
        {
            NSString *msg = [NSString stringWithFormat:@"最多只能上传%d张图片！", MaxPhotoNum];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        [self refreshControlViewWithSelectNum:self.selectItems.count];
    }
}

/** 发送按钮 触发事件 */
- (void)doneButtonClick:(UIButton *)button
{
    [self.delegate photosViewController:self didFinishSelectAssets:self.selectItems];
}

/** 刷新控制视图 */
- (void)refreshControlViewWithSelectNum:(NSInteger)selectNum
{
    self.controlView.numLabel.text = [NSString stringWithFormat:@"%d/%d",selectNum,MaxPhotoNum];
    self.controlView.doneButton.enabled = selectNum;
}

#pragma mark - UICollectionView Datasource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albumItem.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier
                                                                forIndexPath:indexPath];
    if (!cell) {
        cell = [[LYPhotoCell alloc] initWithFrame:CGRectMake(0, 0, Photo_Width, Photo_Width)];
    }
    
    LYPhotoItem *item = [self.albumItem.photos objectAtIndex:indexPath.row];
    UIImage *image = [[UIImage alloc] initWithCGImage:item.asset.thumbnail];
    [cell.photoImageButton setImage:image forState:UIControlStateNormal];
    [cell.photoImageButton addTarget:self action:@selector(photoButtonPress:event:) forControlEvents:UIControlEventTouchUpInside];
    
    if (item.isSelected) {
        [cell.selectButton setImage:[UIImage imageNamed:@"edt_alarm_selected.png"] forState:UIControlStateNormal];
    } else {
        [cell.selectButton setImage:nil forState:UIControlStateNormal];;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"(%ld,%ld)",(long)indexPath.section,(long)indexPath.row);
}

@end



@implementation ControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        //选中个数
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ControlView_Height, ControlView_Height)];
        self.numLabel.textColor = [UIColor grayColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.backgroundColor = [UIColor clearColor];
        self.numLabel.text = [NSString stringWithFormat:@"0/%d", MaxPhotoNum];
        [self addSubview:self.numLabel];
        
        //发送按钮
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"backButton_n" ofType:@"png"]] forState:UIControlStateNormal];
        [self.doneButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"backButton_h" ofType:@"png"]] forState:UIControlStateHighlighted];
        [self.doneButton setTitle:@"发送" forState:UIControlStateNormal];
        self.doneButton.enabled = NO;
        
        float done_w = 80;
        float done_h = 38;
        self.doneButton.frame = CGRectMake((Screen_Width-done_w)-10, (ControlView_Height-done_h)/2, done_w, done_h);
        [self addSubview:self.doneButton];
    }
    return self;
}

@end

