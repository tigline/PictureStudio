//
//  ViewController.m
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "ViewController.h"
#import "LongPictureViewController.h"
#import <Photos/Photos.h>
#import "FilePathUtils.h"
#import "ImgCollectionViewCell.h"
//#import "PhotoCollectionReusableView.h"
#import "AssetTitleView.h"
#import "AHAssetGroupsView.h"
#import "UINavigationBar+Color.h"
#import "CombineIndicatorView.h"
#import "CombinePicture.h"
#import "SharePictureViewController.h"
#import "AboutViewController.h"
#import "PhotoPreviewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HXPhoto3DTouchViewController.h"
#import "ASPopover.h"
#import "AssetTitleButton.h"
#import "AssetGroupViewController.h"
#import "PictureStudio_Bridging_Header.h"
#import "AssetGroupViewController.h"


@interface ViewController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
PhotoEditBottomViewDelegate,
ImgCollectionViewCellDelegate,
UIViewControllerPreviewingDelegate,
UICollectionViewDelegateFlowLayout,
PhotoPreviewControllerDelegate,
UIPopoverPresentationControllerDelegate

>

@property (weak, nonatomic) IBOutlet AssetTitleButton *assetTitleView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *tabelContaintView;

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
//@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *allArray;
@property (strong, nonatomic) NSMutableArray *allScreenShotArray;
@property (strong, nonatomic) NSMutableArray *previewArray;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSMutableArray *videoArray;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *albumModelArray;
@property (strong, nonatomic) UILabel *authorizationLb;
@property (weak, nonatomic) id<UIViewControllerPreviewing> previewingContext;
@property (assign, nonatomic) BOOL orientationDidChange;
@property (strong, nonatomic) NSIndexPath *beforeOrientationIndexPath;
//@property (nonatomic, strong) AssetTitleView *groupTitleView;
@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, strong) UIViewController *assetPopoViewController;
@property (nonatomic, strong) AHAssetGroupsView *assetGroupView;
@property (nonatomic, assign) NSInteger currentSectionIndex;
@property (strong, nonatomic) UIBarButtonItem *aboutMeBtn;
@property (weak, nonatomic) UIActivityIndicatorView *combineIndicatorView;
@property (nonatomic, strong) CombineIndicatorView* indicator;
//@property (weak, nonatomic) PhotoCollectionReusableView *footerView;
@property (assign, nonatomic) __block BOOL canDetectScroll;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (strong, nonatomic) AboutViewController *aboutViewController;
@property (assign, nonatomic) BOOL shouldReloadAsset;
@property (assign, nonatomic) BOOL isScreenshotNotification;
@property (assign, nonatomic) BOOL isLaunch;
@property (assign, nonatomic) BOOL shouldShowIndicator;
@property (assign, nonatomic) BOOL isAssetViewShow;
@property (strong, nonatomic) NSIndexPath *lastAccessed;
@property (strong, nonatomic) NSIndexPath *lastAccessed1;
@property (strong, nonatomic) NSMutableArray *swipeSelectArray;
@property (strong, nonatomic) NSMutableArray *finalselectArray;
@property (assign, nonatomic) BOOL swipePositionChangeX;
@property (assign, nonatomic) BOOL swipePositionChangeY;
@property (assign, nonatomic) CGFloat preSwipeX;
@property (assign, nonatomic) CGFloat preSwipeY;
@property (assign, nonatomic) CGFloat curSwipeYB;
@property (assign, nonatomic) CGFloat curSwipeYE;

@property (assign, nonatomic) CGFloat moveBeginX;
@property (assign, nonatomic) CGFloat moveBeginY;
@property (assign, nonatomic) CGFloat moveEndX;
@property (assign, nonatomic) CGFloat moveEndY;

@property (nonatomic, strong) AssetGroupViewController *assetGroupViewController;

@property (nonatomic, strong) NSTimer *timer;

@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBackgroundColor:UIColor.barColor];
//    [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
//    self.fd_prefersNavigationBarHidden = NO;

//    self.navigationItem.titleView = self.groupTitleView;
    
    [self.view setBackgroundColor: UIColor.barColor];
    [self initCollectionView];
    self.navView.backgroundColor = UIColor.barColor;
    self.navView.layer.shadowColor = UIColor.navShadowColor.CGColor;
    self.navView.layer.shadowOpacity = 0.8f;
    self.navView.layer.shadowRadius = 18;
    self.navView.layer.shadowOffset = CGSizeMake(0, 6);
    [self.view bringSubviewToFront:self.navView];
    [self.assetTitleView buildUI];
    CGFloat width = [self.assetTitleView updateTitleConstraints:YES];
    self.assetTitleView.size = CGSizeMake(width, self.assetTitleView.hx_h);
    self.assetTitleView.center = CGPointMake(self.navView.center.x, self.navView.center.y + 10);
    
    [self askForAuthorize];
    _canDetectScroll = NO;
    _swipeSelectArray = [[NSMutableArray alloc] init];
    _finalselectArray = [[NSMutableArray alloc] init];
    
    _preSwipeX = 0;
    _preSwipeY = 0;
    
    //_assetGroupViewController = [[AssetGroupViewController alloc] init];
    //[self.tabelContaintView addSubview:_assetGroupViewController.view];
    self.tabelContaintView.hidden = YES;
    _isAssetViewShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:)name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setMinimumNumberOfTouches:1];
    [gestureRecognizer setMaximumNumberOfTouches:1];
}

//- (BOOL)prefersStatusBarHidden
//{
//    return _showStatusBar;
//}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)whenBecomeActive:(NSNotificationCenter *)notificaton {
    if (_shouldReloadAsset) {
        //_shouldReloadAsset = NO;
        [self refreshCurrentAssets];
    }
}

- (void)userDidTakeScreenshot:(NSNotificationCenter *)notificaton {
    
    _isScreenshotNotification = YES;
    [self refreshCurrentAssets];
}

- (void)refreshCurrentAssets {
    _shouldShowIndicator = NO;
    if (_albumModel != nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __weak typeof(self) weakSelf = self;
            [self.manager getAllPhotoAndCurrentAlbums:^(HXAlbumModel *currentAlbumModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (currentAlbumModel) {
                        weakSelf.assetGroupView.indexAssetsGroup = currentAlbumModel.index;
                        [weakSelf getPhotoListByAblumModel:currentAlbumModel];
                    }
                });
            } albums:^(NSArray *albums) {
                weakSelf.albumModelArray = [NSMutableArray arrayWithArray:albums];
            } AlbumName:_albumModel.albumName];
        });
    }
}

- (void)didEnterBackground:(NSNotificationCenter *)notificaton {
    _shouldReloadAsset = YES;
}



- (void)askForAuthorize
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _manager = [[HXPhotoManager alloc] init];
                [self setPhotoManager];
                [self setupUI];
                _canDetectScroll = NO;
                [self getAlbumModelList:YES];
                _isLaunch = YES;
                
            });
        }else{
            NSLog(@"Denied or Restricted");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self buildRestrictedUI];
            });
        }
    }];
}

- (void)buildRestrictedUI
{
    UIButton *tipBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    tipBtn.titleLabel.numberOfLines = 3;
    tipBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [tipBtn setTitle:@"相册权限未开启，请在设置中\n选择当前应用,\n开启相册功能点击去设置" forState:UIControlStateNormal];
    tipBtn.frame = CGRectMake((SCREEN_W - SCREEN_W/1.5)/2, (SCREEN_H/2)-25, SCREEN_W/1.5, 150);
    tipBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipBtn];
    [self.view bringSubviewToFront:tipBtn];
    [tipBtn addTarget:self action:@selector(openAuthorization) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openAuthorization
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相册权限未开启" message:@"相册权限未开启，请在设置中选择当前应用,开启相册功能" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:open];
    [alert addAction:cancel];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //_showStatusBar = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //_showStatusBar = NO;

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //[self addCornerRadiusInCollectionView];
}


- (void)getAlbumModelList:(BOOL)isFirst {
    //_shouldShowIndicator = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        [self.manager getAllPhotoAlbums:^(HXAlbumModel *firstAlbumModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (firstAlbumModel) {
                    weakSelf.assetGroupView.indexAssetsGroup = firstAlbumModel.index;
                    [weakSelf getPhotoListByAblumModel:firstAlbumModel];
                }
            });
        } albums:^(NSArray *albums) {
            weakSelf.albumModelArray = [NSMutableArray arrayWithArray:albums];
        } isFirst:isFirst];
    });
}

- (void)getPhotoListByAblumModel:(HXAlbumModel *)albumModel {
    __weak typeof(self) weakSelf = self;
    _canDetectScroll = NO;
    if (_shouldShowIndicator) {
        //[self.view showLoadingHUDText:LocalString(@"load_ablum")];
    }
    __block HXPhotoModel *mHXPhotoModel;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        weakSelf.albumModel = albumModel;
        [weakSelf.allArray removeAllObjects];
        [weakSelf.allScreenShotArray removeAllObjects];
        [weakSelf.manager getPhotoListWithAlbumModel:albumModel complete:^(NSArray *allList, NSArray *previewList, NSArray *photoList, NSArray *videoList, NSArray *dateList, HXPhotoModel *firstSelectModel) {
            weakSelf.dateArray = [NSMutableArray arrayWithArray:dateList];
            weakSelf.allArray = [NSMutableArray arrayWithArray:allList];
            weakSelf.previewArray = [NSMutableArray arrayWithArray:previewList];
            
            #pragma mark - 开发最近长截图
 //----------------------------------------------------------------------------------
            for (int i = 0; i < [weakSelf.allArray count]; i++)
            {
                mHXPhotoModel = [weakSelf.allArray objectAtIndex:i];
                NSDate *sendDate=[NSDate date];
                NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                if (mHXPhotoModel.isScreenShot)
                {
                    if ([self dateTimeDifferenceWithStartTime:[formatter stringFromDate:mHXPhotoModel.creationDate] endTime: [formatter stringFromDate:sendDate]] < 121)
                    {
                        [weakSelf.allScreenShotArray addObject:mHXPhotoModel];
                    }
                }
            }
            
            if ([weakSelf.allScreenShotArray count] > 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _mRecentScrollView = [[RecentScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 49.5*2)/2,self.bottomView.frame.origin.y - 64.5*2, 49.5*2, 64.5*2)];
                    
                    
                    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RecentScrollViewClick:)];

                    [_mRecentScrollView addGestureRecognizer:tapGesturRecognizer];
                });
                mHXPhotoModel = [weakSelf.allScreenShotArray objectAtIndex:0];
                if ( mHXPhotoModel.type == HXPhotoModelMediaTypeCameraPhoto)
                {
                    _mRecentScrollView.image = mHXPhotoModel.thumbPhoto;
                }
                else
                {
                    [HXPhotoTools getImageWithModel:mHXPhotoModel completion:^(UIImage *image, HXPhotoModel *model) {
                        _mRecentScrollView.image = image;
                    }];
                }
            }
            else
            {
                if (_mRecentScrollView != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:1.0f animations:^{
                            _mRecentScrollView.alpha = 0.0f;
                        }];
                    });
                }
            }
//----------------------------------------------------------------------------------
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat bottomMargin = 0.0;
                if (kDevice_Is_iPhoneX) {
                    bottomMargin = weakSelf.bottomView.hx_h;
                } else {
                    bottomMargin = ButtomViewHeight;
                }

                //weakSelf.collectionView.frame = CGRectMake(11*ScreenWidthRatio, 84, AblumViewWidth, SCREEN_H - bottomMargin - 20);
 
                [weakSelf.assetTitleView setTitle:weakSelf.albumModel.albumName forState:UIControlStateNormal];
                CGFloat width = [weakSelf.assetTitleView updateTitleConstraints:NO];
                self.assetTitleView.size = CGSizeMake(width, self.assetTitleView.hx_h);
                self.assetTitleView.center = CGPointMake(self.navView.center.x, self.navView.center.y + 10);
//                [CATransaction begin];
//                [CATransaction setDisableActions:YES];
                
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.collectionView reloadData];
                    if (_isScreenshotNotification || _shouldReloadAsset) {
                        _isScreenshotNotification = NO;
                        _shouldReloadAsset = NO;
                    } else {
                        if (_mRecentScrollView == nil)
                        {
                             [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_allArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                        }
                        else
                        {
                            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_allArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                        }
                    }
                    if (_mRecentScrollView != nil)
                    {
                        [self.view addSubview:_mRecentScrollView];
                    }
                }];
                
//                if (_isScreenshotNotification || _shouldReloadAsset) {
//                    _isScreenshotNotification = NO;
//                    _shouldReloadAsset = NO;
//                } else {
//                    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_allArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
//                }
//                [weakSelf.view layoutIfNeeded];
//                [CATransaction commit];
                
                _canDetectScroll = YES;
                //[weakSelf.view handleLoading];
//                if (weakSelf.isLaunch && [weakSelf.manager shouldShowTipView]) {
//                    [weakSelf showTipView];
//                    weakSelf.isLaunch = NO;
//                }
                
                
            });
        }];
    });
}

- (void)setPhotoManager {
    
    self.manager.configuration.photoMaxNum = 24;
    self.manager.configuration.rowCount = 3;
    self.manager.configuration.saveSystemAblum = YES;
    [self.manager selectedListTransformBefore];
    [self.manager setScreenWidthSize:[[UIScreen mainScreen] currentMode].size.width];
}

- (IBAction)assetButtonClicked:(id)sender {

    _isAssetViewShow = !_isAssetViewShow;
    if (_isAssetViewShow) {
        [self getAssetsGroup];
        self.assetGroupView.indexAssetsGroup = self.currentSectionIndex;
    } else {
        [self hideAssetsGroupView];
        self.collectionView.hidden = NO;
    }
    
    
}


- (void)setupUI {
    
    
    self.currentSectionIndex = 0;
    //__weak typeof(self) weakSelf = self;
//    self.assetTitleView.titleViewDidClick = ^{
//
//    };
    
    _assetPopoViewController =  [self popoverViewController];
//    UIButton *aboutButton = [[UIButton alloc] init];
//    [aboutButton setImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal];
//
//    [aboutButton addTarget:self action:@selector(aboutMe:) forControlEvents:UIControlEventTouchDown];
    
//    _aboutMeBtn = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    
//    _aboutMeBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage alloc]init] style:UIBarButtonItemStyleDone target:self action:@selector(aboutMe:)];
//    [_aboutMeBtn setBackgroundImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [_aboutMeBtn setBackgroundImage:[UIImage imageNamed:@"about_pressed"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem = _aboutMeBtn;

    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    _indicator=[[CombineIndicatorView alloc]initWithFrame:CGRectMake(80, 120, 120, 120) superView:self.view];
    
    self.bottomView.delegate = self;
    [self changeSubviewFrame];
}

- (void)changeSubviewFrame {
    
    CGFloat bottomMargin = kBottomMargin;
    CGFloat leftMargin = 0;
    CGFloat rightMargin = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    //self.collectionView.frame = CGRectMake(11*ScreenWidthRatio, 84, AblumViewWidth, height - ButtomViewHeight - 10);
    
    if (kDevice_Is_iPhoneX) {
        bottomMargin = 21;
        leftMargin = 35;
        rightMargin = 35;
        width = [UIScreen mainScreen].bounds.size.width - 70;
    }
    CGFloat bottomViewY = height - ButtomViewHeight - bottomMargin;
    self.bottomView.frame = CGRectMake(0, bottomViewY, viewWidth, ButtomViewHeight + bottomMargin);
}

- (IBAction)aboutMeTouchTap:(id)sender {
    UIButton *button = (UIButton *)sender;
    //[button setImage:[UIImage imageNamed:@"about_pressed"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.9 animations:^{
        [button setImage:[UIImage imageNamed:@"nav_about_p"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [button setImage:[UIImage imageNamed:@"nav_about"] forState:UIControlStateNormal];
        _aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self presentViewController:_aboutViewController animated:YES completion:nil];
    }];
}


- (void)aboutMe:(id)sender {
    UIButton *button = (UIButton *)sender;
    //[button setImage:[UIImage imageNamed:@"about_pressed"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.9 animations:^{
        [button setImage:[UIImage imageNamed:@"about_pressed"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [button setImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal];
        _aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self presentViewController:_aboutViewController animated:YES completion:nil];
    }];
}



- (NSInteger)dateItem:(HXPhotoModel *)model {
    NSInteger dateItem = model.dateItem;
    
    if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
        
        dateItem = [self.allArray indexOfObject:model];
        
    }else {
        
        dateItem = [self.allArray indexOfObject:model];
        
    }
    
    return dateItem;
}

#pragma mark -scrollView delegate

/*
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
    if (_mRecentScrollView != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0f animations:^{
                _mRecentScrollView.alpha = 0.0f;
            }];
        });
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentHeight = scrollView.contentSize.height - self.view.hx_h;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY < contentHeight) {
        //向下
        if (_canDetectScroll) {
            self.collectionView.frame = CGRectMake(11*ScreenWidthRatio, 84, AblumViewWidth, self.view.hx_h);
        }
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        
    } else if (scrollView.contentOffset.y > _lastContentOffset) {
        //向上
        CGFloat bottomMargin = 0.0;
        if (kDevice_Is_iPhoneX) {
            bottomMargin = self.bottomView.hx_h;
        } else {
            bottomMargin = ButtomViewHeight;
        }
        if (_canDetectScroll && contentOffsetY > contentHeight) {
            self.collectionView.frame = CGRectMake(11*ScreenWidthRatio, 84, AblumViewWidth, self.view.hx_h - bottomMargin);
        }
        //[self.navigationController setNavigationBarHidden:YES animated:YES];

    }
}
*/

//- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView
//{
//
//}
//#pragma mark - UITouch Event
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.collectionView];
//    _moveBeginX = touchPoint.x;
//    _moveBeginY = touchPoint.y;
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
////    CGPoint touchPoint = [[touches anyObject] locationInView:self.collectionView];
////
////    for (ImgCollectionViewCell *cell in self.collectionView.visibleCells) {
////
////
////
////    }
//
//
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //CGPoint touchPoint = [[touches anyObject] locationInView:self.collectionView];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    self.collectionView.scrollEnabled = YES;
    float pointerX = [gestureRecognizer locationInView:self.collectionView].x;
    float pointerY = [gestureRecognizer locationInView:self.collectionView].y;
    //**************在滚动过程中 判断 手势 是否反向**************
    if (isGotoScroll){
        if (isGotoScrolldown){
            if (_preSwipeY > pointerY){
                isGotoScroll = NO;
                isGotoScrolldown = NO;
                [self removeTimer];
            }
        }else{
            if (_preSwipeY < pointerY){
                isGotoScroll = NO;
                isGotoScrolldown = NO;
                [self removeTimer];
            }
        }
    }
    //****************************
    _preSwipeY = pointerY;
    
    for (ImgCollectionViewCell *cell in [self.collectionView visibleCells])
    {
        float cellSX = cell.frame.origin.x;
        float cellEX = cell.frame.origin.x + cell.frame.size.width;
        float cellSY = cell.frame.origin.y;
        float cellEY = cell.frame.origin.y + cell.frame.size.height;
        
        currentArray= [[NSMutableArray alloc] initWithCapacity:1024];
        
        if (pointerX >= cellSX && pointerX <= cellEX && pointerY >= cellSY && pointerY <= cellEY)
        {
            NSIndexPath *touchOver = [self.collectionView indexPathForCell:cell];
            
            //判断滑动，开启自动上下滑动
            [self goToScrollWithHeight:pointerY];
            
            if (_lastAccessed != touchOver){
                if (!isFirstSelect){
                    isFirstSelect = YES;
                    firstCell = touchOver.item;
                    if (cell.selectBtn.selected){
                        cell.matchY = NO;
                        isFirstCellSelect = NO;
                    }else {
                        cell.matchY = YES;
                        isFirstCellSelect = YES;
                    }
                    [lastArray addObject:[NSString stringWithFormat:@"%ld",(long)touchOver.item]];
                }else{
                    currentCell = touchOver.item;
                    NSInteger max = currentCell;
                    NSInteger min = firstCell;
                    //
                    BOOL isScrollDown = YES;//默认用户是向下滑动
                    if (max < firstCell)
                    {
                        //说明是向上滑动
                        isScrollDown = NO;
                        max = firstCell;
                        min = currentCell;
                    }
                    for (NSInteger i = min; i <= max; i ++)
                    {
                        [currentArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                    
                    [self setDateCurrentArray:currentArray withLastArray:lastArray withIsScrollDown:isScrollDown];
                    
                    for (int i = 0; i < [addArray count]; i ++){
                        for (ImgCollectionViewCell *setCell in self.collectionView.visibleCells){
                            NSIndexPath *setTouchOver = [self.collectionView indexPathForCell:setCell];
                            if (setTouchOver.item == [[addArray objectAtIndex:i] integerValue]){
                                if (isFirstCellSelect){
                                    if (!setCell.selectBtn.selected){
                                        setCell.matchY = YES;
                                    }
                                }else{
                                    if (setCell.selectBtn.selected){
                                        setCell.matchY = NO;
                                    }
                                }
                            }
                        }
                    }
                    
                    for (int i = 0; i < [minusArray count]; i ++){
                        for (ImgCollectionViewCell *minuscell in self.collectionView.visibleCells){
                            NSIndexPath *minustouchOver = [self.collectionView indexPathForCell:minuscell];
                            if (minustouchOver.item == [[minusArray objectAtIndex:i] integerValue]){
                                if (minuscell.selectBtn.selected){
                                    minuscell.matchY = NO;
                                }else {
                                    minuscell.matchY = YES;
                                }
                            }
                        }
                    }
                }
                
                _lastAccessed = touchOver;
            }
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //当手势结束后 初始化一些数据
        _lastAccessed = nil;
        self.collectionView.scrollEnabled = YES;
        isFirstSelect = NO;
        lastArray = [[NSMutableArray alloc] initWithCapacity:1024];
        NSLog(@"-------UIGestureRecognizerStateEnded------");
        [self removeTimer];
        isGotoScroll = NO;
        isGotoScrolldown = NO;
    }
    
    
}

-(void)goToScrollWithHeight:(float)pointerY
{
    if (!isGotoScroll)
    {
        if ((self.view.frame.size.height -(pointerY - self.collectionView.contentOffset.y)) < (self.view.hx_w - 41)/3){
            [self addTimer];
            isGotoScroll = YES;
            isGotoScrolldown = YES;
        }
        if (pointerY - self.collectionView.contentOffset.y < (self.view.hx_w - 41)/3){
            [self addTimer];
            isGotoScroll = YES;
            isGotoScrolldown = NO;
        }
    }
}


//开启定时器
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(change:) userInfo:nil repeats:YES];
}

//关闭定时器
- (void)removeTimer{
    if (_timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
            _timer=nil;
        }
    }
}

//定时器执行方法,当前滑动每次自动滑动30 可优化
- (void)change:(NSTimer *)time{
    if (isGotoScrolldown){
        if (self.collectionView.contentOffset.y >=  self.collectionView.contentSize.height - [UIScreen mainScreen].bounds.size.height - 10){
            [self removeTimer];
        }else{
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + 10) animated:NO];
        }
    }else{
        if (self.collectionView.contentOffset.y <= 10){
            [self removeTimer];
        }else{
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y - 10) animated:NO];
        }
    }
}


-(void)setDateCurrentArray:(NSMutableArray*)curArray withLastArray:(NSMutableArray*)lArray withIsScrollDown:(BOOL)isScrollDown{
    [addArray removeAllObjects];
    [minusArray removeAllObjects];
    addArray= [[NSMutableArray alloc] initWithCapacity:1024];
    minusArray= [[NSMutableArray alloc] initWithCapacity:1024];
    
    for (int i = 0; i < [curArray count]; i++)
    {
        //当前需要控制的值 之前的数组中是否存在
        BOOL isExist = NO;
        for (int j = 0; j < [lArray count]; j++)
        {
            if ([[curArray objectAtIndex:i] isEqualToString:[lArray objectAtIndex:j]])
            {
                isExist = YES;
            }
        }
        
        if (!isExist)
        {
            [addArray addObject:[curArray objectAtIndex:i]];
        }
    }
    
    for (int i = 0; i < [lArray count]; i++)
    {
        //当前需要控制的值 之前的数组中是否存在
        BOOL isExist = NO;
        for (int j = 0; j < [curArray count]; j++)
        {
            if ([[curArray objectAtIndex:j] isEqualToString:[lArray objectAtIndex:i]])
            {
                isExist = YES;
            }
        }
        
        if (!isExist)
        {
            [minusArray addObject:[lArray objectAtIndex:i]];
        }
    }
    
    for ( int i = 0; i < [minusArray count]; i++)
    {
        [lastArray removeObject:[minusArray objectAtIndex:i]];
    }
    for ( int i = 0; i < [addArray count]; i++)
    {
        [lastArray addObject:[addArray objectAtIndex:i]];
    }
    
    //这一步 将获取的的lastArray 做排序，已图片标号的正确性
    //     [lastArray sortUsingSelector:@selector(compare:)];
    //    //通过倒序的方法进行降序排列
    //    NSEnumerator *enumerator = [lastArray reverseObjectEnumerator];
    //
    //    lastArray =[[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
    if (!isScrollDown)
    {
        [addArray sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            return [obj2 intValue] > [obj1 intValue];
        }];
    }
}



- (void) selectCellForCollectionView:(ImgCollectionViewCell *)cell
{
    [self.manager beforeSelectedListAddPhotoModel:cell.model];
    NSString *str = [self.manager maximumOfJudgment:cell.model];
    if (str) {
        [self.view showImageHUDText:str];
        return;
    }
    if (cell.model.type != HXPhotoModelMediaTypeCameraVideo && cell.model.type != HXPhotoModelMediaTypeCameraPhoto) {
        cell.model.thumbPhoto = cell.imageView.image;
    }

    cell.selectMaskLayer.hidden = NO;
    
    cell.selectBtn.selected = YES;
    [cell.selectBtn setTitle:cell.model.selectIndexStr forState:UIControlStateSelected];
    
//    [collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//    [self collectionView:collection didSelectItemAtIndexPath:indexPath];
}

//- (void) deselectCellForCollectionView:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
- (void) deselectCellForCollectionView:(ImgCollectionViewCell *)cell
{
//    [collection deselectItemAtIndexPath:indexPath animated:YES];
//    [self collectionView:collection didDeselectItemAtIndexPath:indexPath];
    [self.manager beforeSelectedListdeletePhotoModel:cell.model];
    
    cell.model.selectIndexStr = @"";
    cell.selectMaskLayer.hidden = YES;
    cell.selectBtn.selected = NO;
    cell.model.selected = NO;
}


#pragma mark - < UICollectionViewDataSource >
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoModel *model;
    model = self.allArray[indexPath.item];
    model.rowCount = self.manager.configuration.rowCount;
    model.dateCellIsVisible = YES;
    
    ImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DateCellId" forIndexPath:indexPath];
    cell.collectionViewCelldelegate = self;
    
    cell.model = model;
    
    
    if ([self respondsToSelector:@selector(traitCollection)]) {
        
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                
                [self registerForPreviewingWithDelegate:(id)self sourceView:cell];
            }
        }
    }
    

    //cell.singleSelected = self.manager.configuration.singleSelected;
    return cell;
    
}

#pragma mark - < UICollectionViewDelegate >
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.topViewController != self) {
        return;
    }
    HXPhotoModel *model;
    model = self.allArray[indexPath.item];
    //ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

    PhotoPreviewController *photoPreviewVc = [[PhotoPreviewController alloc] init];
    photoPreviewVc.currentIndex = indexPath.row;
    photoPreviewVc.models = self.allArray;
    photoPreviewVc.manager = _manager;
    photoPreviewVc.delegate = self;
    //[self pushPhotoPrevireViewController:photoPreviewVc];

    [self.navigationController pushViewController:photoPreviewVc animated:YES];
//    ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    

//    NSInteger currentIndex = [self.previewArray indexOfObject:cell.model];
//    HXDatePhotoPreviewViewController *previewVC = [[HXDatePhotoPreviewViewController alloc] init];
//    previewVC.delegate = self;
//    previewVC.modelArray = self.previewArray;
//    previewVC.manager = self.manager;
//    previewVC.currentModelIndex = currentIndex;
//    self.navigationController.delegate = previewVC;
//    [self.navigationController pushViewController:previewVC animated:YES];

    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection];
    
//    ImgCollectionViewCell *indexcell = (ImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
////    cell.model.selectIndexStr = @"";
////    cell.selectMaskLayer.hidden = YES;
////    cell.selectBtn.selected = NO;
////    cell.model.selected = NO;
//    cell.selected = indexcell.selected;
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        //        NSSLog(@"headerSection消失");
    }
}




//设置每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake((AblumViewWidth - 20*ScreenWidthRatio)/3,(AblumViewWidth - 20*ScreenWidthRatio)/3);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
//    return CGSizeMake(self.collectionView.hx_w, 50);
//
//}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
////    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
////        PhotoCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"sectionFooterId" forIndexPath:indexPath];
////        footerView.photoCount = self.allArray.count;
////        self.footerView = footerView;
////        return footerView;
////    }
//    return nil;
//}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath) {
        return nil;
    }
    if (![[self.collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[ImgCollectionViewCell class]]) {
        return nil;
    }
    ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        return nil;
    }

    //设置突出区域
    previewingContext.sourceRect = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
    HXPhotoModel *model = cell.model;
    HXPhoto3DTouchViewController *vc = [[HXPhoto3DTouchViewController alloc] init];
    vc.model = model;
    vc.indexPath = indexPath;
    vc.image = cell.imageView.image;
    vc.preferredContentSize = model.previewViewSize;
    return vc;
}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    HXPhoto3DTouchViewController *vc = (HXPhoto3DTouchViewController *)viewControllerToCommit;
    ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:vc.indexPath];
 

    PhotoPreviewController *previewVC = [[PhotoPreviewController alloc] init];
    previewVC.delegate = self;
    previewVC.models = self.allArray;
    previewVC.manager = self.manager;
    cell.model.tempImage = vc.imageView.image;
    NSInteger currentIndex = [self.previewArray indexOfObject:cell.model];
    previewVC.currentIndex = currentIndex;
    self.navigationController.delegate = previewVC;
    [self.navigationController pushViewController:previewVC animated:YES];
    
//    HXPhotoModel *model;
//    model = self.allArray[indexPath.item];
//    PhotoPreviewController *photoPreviewVc = [[PhotoPreviewController alloc] init];
//    photoPreviewVc.currentIndex = indexPath.row;
//    photoPreviewVc.models = self.allArray;
//    photoPreviewVc.manager = _manager;
    

    
    
}

#pragma mark - < ImgCollectionViewCellDelegate >
- (void)imgCollectionViewCellRequestICloudAssetComplete:(ImgCollectionViewCell *)cell {
    if (cell.model.dateCellIsVisible) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:cell.model] inSection:cell.model.dateSection];
        if (indexPath) {
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

- (void)imgCollectionViewCell:(ImgCollectionViewCell *)cell didSelectBtn:(UIButton *)selectBtn {
    
    if (_mRecentScrollView != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0f animations:^{
                _mRecentScrollView.alpha = 0.0f;
            }];
        });
    }
    
    if (selectBtn.selected) {
        if (cell.model.type != HXPhotoModelMediaTypeCameraPhoto) {
            cell.model.thumbPhoto = nil;
            cell.model.previewPhoto = nil;
        }
        [self.manager beforeSelectedListdeletePhotoModel:cell.model];
        cell.model.selectIndexStr = @"";
        cell.selectMaskLayer.hidden = YES;
        selectBtn.selected = NO;
        //cell.selected = NO;
    }else {
        NSString *str = [self.manager maximumOfJudgment:cell.model];
        if (str) {
            [self.view showImageHUDText:str];
            [self removeTimer];
            return;
        }
        if (cell.model.type != HXPhotoModelMediaTypeCameraVideo && cell.model.type != HXPhotoModelMediaTypeCameraPhoto) {
            cell.model.thumbPhoto = cell.imageView.image;
        }
        [self.manager beforeSelectedListAddPhotoModel:cell.model];
        cell.selectMaskLayer.hidden = NO;
        selectBtn.selected = YES;
        //cell.selected = YES;
        [selectBtn setTitle:cell.model.selectIndexStr forState:UIControlStateSelected];
    }
//    else {
//        [self.view showImageHUDText:LocalString(@"right_operate_tips")];
//        return;
//    }

    if (!selectBtn.selected) {
        NSMutableArray *indexPathList = [NSMutableArray array];
        NSInteger index = 0;
        for (HXPhotoModel *model in [self.manager selectedArray]) {
            model.selectIndexStr = [NSString stringWithFormat:@"%ld",index + 1];
            if (model.currentAlbumIndex == self.albumModel.index) {
                if (model.dateCellIsVisible) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection];
                    [indexPathList addObject:indexPath];
                }
            }
            index++;
        }
        if (indexPathList.count > 0) {
            [self.collectionView reloadItemsAtIndexPaths:indexPathList];
        }
    }
    self.bottomView.selectCount = [self.manager selectedCount];
    if ([self.delegate respondsToSelector:@selector(datePhotoViewControllerDidChangeSelect:selected:)]) {
        [self.delegate datePhotoViewControllerDidChangeSelect:cell.model selected:selectBtn.selected];
    }
}

- (void)datePhotoPreviewControllerDidSelect:(PhotoPreviewController *)previewController model:(HXPhotoModel *)model {
    NSMutableArray *indexPathList = [NSMutableArray array];
    if (model.currentAlbumIndex == self.albumModel.index) {
        [indexPathList addObject:[NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection]];
    }
    if (!model.selected) {
        NSInteger index = 0;
        for (HXPhotoModel *subModel in [self.manager selectedArray]) {
            subModel.selectIndexStr = [NSString stringWithFormat:@"%ld",index + 1];
            if (subModel.currentAlbumIndex == self.albumModel.index && subModel.dateCellIsVisible) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:subModel] inSection:subModel.dateSection];
                [indexPathList addObject:indexPath];
            }
            index++;
        }
    }
    if (indexPathList.count > 0) {
        [self.collectionView reloadItemsAtIndexPaths:indexPathList];
    }
    self.bottomView.selectCount = [self.manager selectedCount];
    if ([self.delegate respondsToSelector:@selector(datePhotoViewControllerDidChangeSelect:selected:)]) {
        [self.delegate datePhotoViewControllerDidChangeSelect:model selected:model.selected];
    }
}
#pragma mark - <PhotoEditBottomViewDelegate>

- (void)datePhotoBottomViewDidCombineBtn {
    
    self.manager.isCombineVertical = YES;
    [self performSegueWithIdentifier:@"toLongPictureView" sender:nil];
    
}

- (void)datePhotoBottomViewDidClearBtn {

    for (HXPhotoModel *model in [self.manager selectedArray]) {
        if (model.dateCellIsVisible) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection];
            
            ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.model.selectIndexStr = @"";
            cell.selectMaskLayer.hidden = YES;
            cell.selectBtn.selected = NO;
            cell.model.selected = NO;
            cell.selected = NO;
            
            if (cell == nil) {
                model.selectIndexStr = @"";
                model.selected = NO;
                [self.allArray replaceObjectAtIndex:model.dateSection withObject:model];

                [UIView performWithoutAnimation:^{
                    
                    [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
                    
                }];
                
            }
            
            
        }
    }
    [self.manager clearSelectedList];
    self.bottomView.selectCount = [self.manager selectedCount];
    [_swipeSelectArray removeAllObjects];

    
}


#pragma mark - 开发最近长截图
//----------------------------------------------------------------------------------
-(void)RecentScrollViewClick:(id)tap {
    if (self.allScreenShotArray.count < 2) {
        
    } else {
        __block NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        for (int i = 0; i < self.allScreenShotArray.count; i++) {
            HXPhotoModel *model;
            model = [self.allScreenShotArray objectAtIndex:i];
            PHAsset *phAsset = model.asset;
            PHImageRequestOptions * options=[[PHImageRequestOptions alloc]init];
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.synchronous=YES;
            [imageManager requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize
                                   contentMode:PHImageContentModeDefault
                                       options:options
                                 resultHandler:^(UIImage *result, NSDictionary *info)
             {
                 [photoArray addObject:result];
             }];
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [CombinePicture CombinePictures:photoArray complete:^(NSArray* resultModels) {
                if ([weakSelf.allScreenShotArray count]> 3) {
                    [weakSelf.manager setScrollResult:resultModels];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollFinish" object:nil];
                } else {
                    [weakSelf.manager setScrollResult:resultModels];
                    [self performSegueWithIdentifier:@"toSharePictureView" sender:resultModels];
                }
            }success:^(BOOL success) {
                weakSelf.manager.isScrollSuccess = success;
            }];
        });
        
        if ([weakSelf.allScreenShotArray count]> 3) {
            [self performSegueWithIdentifier:@"toSharePictureView" sender:nil];
        }
    }
}
//----------------------------------------------------------------------------------

- (void)datePhotoBottomViewDidScrollBtn {
    if (_manager.selectedArray.count < 2) {
        
    } else {
        __block NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        for (int i = 0; i < _manager.selectedArray.count; i++) {
            HXPhotoModel *model;
            model = _manager.selectedArray[i];
            PHAsset *phAsset = model.asset;
            PHImageRequestOptions * options=[[PHImageRequestOptions alloc]init];
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.synchronous=YES;
            [imageManager requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize
                                   contentMode:PHImageContentModeDefault
                                       options:options
                                 resultHandler:^(UIImage *result, NSDictionary *info)
             {
                 [photoArray addObject:result];
             }];
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [CombinePicture CombinePictures:photoArray complete:^(NSArray* resultModels) {
                if (weakSelf.manager.selectedCount > 3) {
                    [weakSelf.manager setScrollResult:resultModels];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollFinish" object:nil];
                } else {
                    [weakSelf.manager setScrollResult:resultModels];
                    [self performSegueWithIdentifier:@"toSharePictureView" sender:resultModels];
                }
            }success:^(BOOL success) {
                weakSelf.manager.isScrollSuccess = success;
            }];
        });
        
        if (_manager.selectedCount > 3) {
            [self performSegueWithIdentifier:@"toSharePictureView" sender:nil];
        }
        
        
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            [weakSelf performSegueWithIdentifier:@"toSharePictureView" sender:nil];
//        });

    }
}
- (void)datePhotoBottomViewDidEditBtn {
    
}
- (void)datePhotoBottomViewDidcombineBtnH {
    self.manager.isCombineVertical = NO;
    [self performSegueWithIdentifier:@"toLongPictureView" sender:nil];
}

- (void)datePhotoBottomSelectNotAllScreenShot {
    [self.view showImageHUDText:LocalString(@"right_operate_tips")];
}

- (void)hideAsetTabelView {
    
}

#pragma mark - < 懒加载 >

-(UIViewController*)popoverViewController
{
    //创建弹窗所在的view controller
    UIViewController* popoverVC = [[UIViewController alloc] init];
    
    popoverVC.modalPresentationStyle = UIModalPresentationPopover;
    popoverVC.preferredContentSize = CGSizeMake(280*ScreenWidthRatio, 280*ScreenHeightRatio);
//    UIToolbar *view = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280*ScreenWidthRatio, 280*ScreenWidthRatio)];
//    [popoverVC setView:view];
    UIView *blackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280*ScreenWidthRatio, 280*ScreenHeightRatio)];
    blackV.backgroundColor = [UIColor colorWithRed:122/255.0 green:123/255.0 blue:234/255.0 alpha:0.7];
    //[popoverVC.view addSubview:blackV];
    

    [popoverVC setView:self.assetGroupView];
    //popoverVC.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:239/255.0 alpha:1.0];
    
    //
    //[popoverVC.view setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:1]];
    
    return popoverVC;
}


- (AHAssetGroupsView *)assetGroupView
{
    if (_assetGroupView == nil) {
        _assetGroupView = [[AHAssetGroupsView alloc] initWithFrame:CGRectMake(0, 0, 280*ScreenWidthRatio, 280*ScreenHeightRatio)];
        _assetGroupView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
        //_assetGroupView = [[ALiAssetGroupsView alloc] init];
        //_assetGroupView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_assetGroupView.touchButton addTarget:self action:@selector(hideAssetsGroupView) forControlEvents:UIControlEventTouchUpInside];
        WEAKSELF(weakSelf);
        _assetGroupView.groupSelectedBlock = ^(HXAlbumModel *selectedAlbumModel){
            [weakSelf groupViewDidSelected:selectedAlbumModel];
        };
        //[self.view addSubview:_assetGroupView];
    }
    return _assetGroupView;
}


- (PhotoEditButtomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PhotoEditButtomView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - ButtomViewHeight - kBottomMargin, self.view.hx_w, ButtomViewHeight + kBottomMargin)];
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bottomView.manager = self.manager;
        _bottomView.delegate = self;
    }
    return _bottomView;
}



- (void)addCornerRadiusInCollectionView {
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    CGRect bounds = _collectionView.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height) byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){5.0, 15.0}].CGPath;
    _collectionView.layer.mask = maskLayer;
}

- (void)initCollectionView {

        //CGFloat collectionHeight = self.view.hx_h;

        //_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11*ScreenWidthRatio, 84, AblumViewWidth, collectionHeight) collectionViewLayout:self.flowLayout];
        
        _collectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        _collectionView.layer.shadowOpacity = 1.0;
        _collectionView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.05].CGColor;
        _collectionView.layer.shadowOffset = CGSizeMake(0, 4);
        _collectionView.layer.shadowRadius = 12;
    
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"DateCellId"];
        //[_collectionView registerClass:[PhotoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooterId"];
        //_collectionView.allowsMultipleSelection = YES;
        if ([self respondsToSelector:@selector(traitCollection)]) {
            if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
                if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:_collectionView];
                }
            }
        }
    


    }

- (void)handleGesture {
    
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0.5, 0);
        //        if (iOS9_Later) {
        //            _flowLayout.sectionHeadersPinToVisibleBounds = YES;
        //        }
    }
    return _flowLayout;
}

//- (AssetTitleView *)groupTitleView
//{
//    if (_groupTitleView == nil) {
//        _groupTitleView = [[AssetTitleView alloc] init];
//        _groupTitleView.layer.borderWidth = 1;
//        _groupTitleView.layer.borderColor = UIColor.lightGrayColor.CGColor;
//        _groupTitleView.layer.cornerRadius = 13*ScreenHeightRatio;
//        _groupTitleView.layer.masksToBounds = YES;
//        
//    }
//    return _groupTitleView;
//}

- (UIButton *)touchButton{
    if (!_touchButton) {
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchButton.frame = CGRectMake(0, 0, self.view.size.width, kNavigationBarHeight+10*ScreenHeightRatio);
        [_touchButton setBackgroundColor:[UIColor clearColor]];
        [_touchButton addTarget:self action:@selector(assetsGroupsDidDeselected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchButton;
}

- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}
- (NSMutableArray *)allScreenShotArray {
    if (!_allScreenShotArray) {
        _allScreenShotArray = [NSMutableArray array];
    }
    return _allScreenShotArray;
}
- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (NSMutableArray *)previewArray {
    if (!_previewArray) {
        _previewArray = [NSMutableArray array];
    }
    return _previewArray;
}
- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}
- (void)dealloc {
    NSSLog(@"dealloc");
    [self.collectionView.layer removeAllAnimations];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}


#pragma private method

- (void)groupViewDidSelected:(HXAlbumModel *)selectedAlbumModel
{
    [self hideAssetsGroupView];
     //self.assetGroupView.indexAssetsGroup = selectedAlbumModel.index;
    
    if ([self.albumModel.albumName isEqualToString:selectedAlbumModel.albumName]) {
        return;
    } else {
        //更新标题
        _shouldShowIndicator = YES;
        self.currentSectionIndex = selectedAlbumModel.index;
        [self.assetTitleView setTitle:selectedAlbumModel.albumName forState:UIControlStateNormal];
        CGFloat width = [self.assetTitleView updateTitleConstraints:NO];
        self.assetTitleView.size = CGSizeMake(width, self.assetTitleView.hx_h);
        self.assetTitleView.center = CGPointMake(self.navView.center.x, self.navView.center.y + 10);
        [self getPhotoListByAblumModel:selectedAlbumModel];
    }
    
}

- (void)assetsGroupsDidDeselected {
    
    [self hideAssetsGroupView];
}
- (void)getAssetsGroup
{
    __weak typeof(self) weakSelf = self;
    
    [self.manager getAllPhotoAlbums:^(HXAlbumModel *firstAlbumModel) {
        
    } albums:^(NSArray *albums) {
        weakSelf.albumModelArray = [NSMutableArray arrayWithArray:albums];
        weakSelf.collectionView.hidden = YES;
        weakSelf.tabelContaintView.hidden = NO;
        if (_assetGroupViewController == nil) {
            _assetGroupViewController = [[AssetGroupViewController alloc] initWithNibName:@"AssetGroupViewController" bundle:nil];
            _assetGroupViewController.assetsGroups = albums;
            _assetGroupView.groupSelectedBlock = ^(HXAlbumModel *selectedAlbumModel) {
                [weakSelf groupViewDidSelected:selectedAlbumModel];
            };
            [weakSelf addChildViewController:_assetGroupViewController];
            _assetGroupViewController.view.frame = weakSelf.tabelContaintView.bounds;
            [weakSelf.tabelContaintView addSubview:_assetGroupViewController.view];
            [_assetGroupViewController didMoveToParentViewController:weakSelf];
        } else {
            _assetGroupViewController.assetsGroups = albums;
            [_assetGroupViewController.collectionView reloadData];
        }
        
        
        
        
    } isFirst:NO];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //self.groupTitleView.arrowBtn.transform = CGAffineTransformRotate(self.groupTitleView.arrowBtn.transform, -M_PI_2*1.999);
                     }completion:^(BOOL finished) {
                         [_touchButton removeFromSuperview];
                         _touchButton = nil;
                         
                     }];
    return YES;
}


- (void)hideAssetsGroupView
{
//    for (UIView *subView in self.tabelContaintView.subviews) {
//        [subView removeFromSuperview];
//    }
    
    self.tabelContaintView.hidden = YES;
    
}

-(NSString *)getMessageID
{
    NSTimeInterval  messageId=[[NSDate date] timeIntervalSince1970]*100;
    NSString *strmessageId=[NSString stringWithFormat:@"%lld",(long long)messageId];
    return strmessageId;
}

-(NSString*)returnCurrentTime
{
    //    NSDate *sendDate=[NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *currentDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: currentDate];
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
    NSString* date = [formatter stringFromDate:localeDate];
    return date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidBecomeActiveNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationWillResignActiveNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationUserDidTakeScreenshotNotification];
}

- (void)showTipView {
    NSString *strTitle = @"操作提示";
    NSString *message = @"拼接长截图请选择本机两张及以上截图";
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                    message:message
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toSharePictureView"]) {
        NSArray *modelArray = (NSArray *)sender;
        ((SharePictureViewController *)(segue.destinationViewController)).manager = self.manager;
        ((SharePictureViewController *)(segue.destinationViewController)).resultModels = modelArray;
    } else if ([[segue identifier] isEqualToString:@"toLongPictureView"]) {
        //UIImage *image = (UIImage *)sender;
        ((LongPictureViewController *)(segue.destinationViewController)).manager = self.manager;

    }
    
}


- (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int minute = (int)value;
    return minute;
}

@end



