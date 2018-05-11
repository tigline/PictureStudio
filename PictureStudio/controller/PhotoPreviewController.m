//
//  PhotoPreviewController.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/5/11.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "PhotoPreviewController.h"
#import "HXPhotoManager.h"
#import "PhotoPreviewCell.h"
#import "ViewController.h"

@interface PhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    
    CGFloat _offsetItemCount;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, assign) double progress;
@property (strong, nonatomic) id alertView;
@end

@interface PhotoPreviewController ()

@end

@implementation PhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //__weak typeof(self) weakSelf = self;
    //ViewController *_tzImagePickerVc = (ViewController *)weakSelf.navigationController;
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithArray:_manager.selectedArray];
        _assetsTemp = [NSMutableArray arrayWithArray:_manager.selectedArray];
    }
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.hx_w + 20) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    ViewController *tzImagePickerVc = (ViewController *)self.navigationController;
//    if (tzImagePickerVc.needShowStatusBar && iOS7Later) {
//        [UIApplication sharedApplication].statusBarHidden = NO;
//    }

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configCustomNaviBar {
    ViewController *tzImagePickerVc = (ViewController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    [_selectButton setImage:[UIImage imageNamed:tzImagePickerVc.photoDefImageName] forState:UIControlStateNormal];
//    [_selectButton setImage:[UIImage imageNamed:tzImagePickerVc.photoSelImageName] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = NO;//!tzImagePickerVc.showSelectBtn;
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    static CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    

    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _numberImageView.backgroundColor = [UIColor clearColor];
    _numberImageView.hidden = NO;//_tzImagePickerVc.selectedModels.count <= 0;
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_manager.selectedCount];
    _numberLabel.hidden = _manager.selectedCount <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    [_originalPhotoButton addSubview:_originalPhotoLabel];
    [_toolBar addSubview:_doneButton];
    [_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLabel];
    [self.view addSubview:_toolBar];
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.hx_w + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:@"PhotoPreviewCell"];

}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //ViewController *_tzImagePickerVc = (ViewController *)self.navigationController;
    
    CGFloat statusBarHeight = kDevice_Is_iPhoneX ? 44 : 20 ;
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = statusBarHeight + self.navigationController.navigationBar.hx_h;
    _naviBar.frame = CGRectMake(0, 0, self.view.hx_w, naviBarHeight);
    _backButton.frame = CGRectMake(10, 10 + statusBarHeightInterval, 44, 44);
    _selectButton.frame = CGRectMake(self.view.hx_w - 54, 10 + statusBarHeightInterval, 42, 42);
    
    _layout.itemSize = CGSizeMake(self.view.hx_w + 20, self.view.hx_h);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.hx_w + 20, self.view.hx_h);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }

    
    CGFloat toolBarHeight = kDevice_Is_iPhoneX ? 44 + (83 - 49) : 44;
    CGFloat toolBarTop = self.view.hx_h - toolBarHeight;
    _toolBar.frame = CGRectMake(0, toolBarTop, self.view.hx_w, toolBarHeight);

    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.hx_w - _doneButton.hx_w - 12, 0, _doneButton.hx_w, 44);
    _numberImageView.frame = CGRectMake(_doneButton.originX - 30 - 2, 7, 30, 30);
    _numberLabel.frame = _numberImageView.frame;
    

}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    //ViewController *_tzImagePickerVc = (ViewController *)self.navigationController;
    HXPhotoModel *model = _models[_currentIndex];
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_manager.selectedCount >= 9) {
            NSString *title = [NSString stringWithFormat:@"Select a maximum of %d photos", 9];
            [self.view showImageHUDText:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_manager beforeSelectedListAddPhotoModel:model];
//            if (self.photos) {
//                [_tzImagePickerVc.selectedAssets addObject:_assetsTemp[_currentIndex]];
//                [self.photos addObject:_photosTemp[_currentIndex]];
//            }
            
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_manager.selectedArray];
        

        for (NSInteger i = 0; i < selectedModels.count; i++) {
            id asset = selectedModels[i];
            if ([asset isEqual:_assetsTemp[_currentIndex]]) {
                [_manager beforeSelectedListdeletePhotoModel:asset];
                break;
            }
        }
//        for (HXPhotoModel *model_item in selectedModels) {
//            if ([[[HXPhotoManager manager] getAssetIdentifier:model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]]) {
//                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
//                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
//                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
//                    TZAssetModel *model = selectedModelsTmp[i];
//                    if ([model isEqual:model_item]) {
//                        [_tzImagePickerVc.selectedModels removeObjectAtIndex:i];
//                        break;
//                    }
//                }
//                // [_tzImagePickerVc.selectedModels removeObject:model_item];
//                if (self.photos) {
//                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
//                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedAssets];
//                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
//                        id asset = selectedAssetsTmp[i];
//                        if ([asset isEqual:_assetsTemp[_currentIndex]]) {
//                            [_tzImagePickerVc.selectedAssets removeObjectAtIndex:i];
//                            break;
//                        }
//                    }
//                    // [_tzImagePickerVc.selectedAssets removeObject:_assetsTemp[_currentIndex]];
//                    [self.photos removeObject:_photosTemp[_currentIndex]];
//                }
//                break;
//            }
//        }
    }
    model.selected = !selectButton.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.selected) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [selectButton.layer addAnimation:anim forKey:@""];
  
    }

}

- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)doneButtonClick {

}



- (void)didTapPreviewCell {
    self.isHideNaviBar = !self.isHideNaviBar;
    _naviBar.hidden = self.isHideNaviBar;
    _toolBar.hidden = self.isHideNaviBar;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.hx_w + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.hx_w + 20);
    
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //ViewController *_tzImagePickerVc = (ViewController *)self.navigationController;
    HXPhotoModel *model = _models[indexPath.row];
    
    PhotoPreviewCell *cell;
    __weak typeof(self) weakSelf = self;

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPreviewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PhotoPreviewCell alloc]init];
    }
        cell.model = model;
//        PhotoPreviewCell *photoPreviewCell = (PhotoPreviewCell *)cell;
//        photoPreviewCell.model = model;
//        __weak typeof(_tzImagePickerVc) weakTzImagePickerVc = _tzImagePickerVc;
//        __weak typeof(_collectionView) weakCollectionView = _collectionView;
//        __weak typeof(photoPreviewCell) weakCell = photoPreviewCell;
//        [photoPreviewCell setImageProgressUpdateBlock:^(double progress) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            __strong typeof(weakTzImagePickerVc) strongTzImagePickerVc = weakTzImagePickerVc;
//            __strong typeof(weakCollectionView) strongCollectionView = weakCollectionView;
//            __strong typeof(weakCell) strongCell = weakCell;
//            strongSelf.progress = progress;
//            if (progress >= 1) {
//                if (strongSelf.isSelectOriginalPhoto) [strongSelf showPhotoBytes];
//                if (strongSelf.alertView && [strongCollectionView.visibleCells containsObject:strongCell]) {
//                    //[strongTzImagePickerVc hideAlertView:strongSelf.alertView];
//                    strongSelf.alertView = nil;
//                    [strongSelf doneButtonClick];
//                }
//            }
//        }];
    
    
    
    [cell setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didTapPreviewCell];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [(PhotoPreviewCell *)cell recoverSubviews];
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    [(PhotoPreviewCell *)cell recoverSubviews];
    
}

#pragma mark - Private Method

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)refreshNaviBarAndBottomBarState {
    
    HXPhotoModel *model = _models[_currentIndex];
    _selectButton.selected = model.selected;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_manager.selectedCount];
    _numberImageView.hidden = (_manager.selectedCount <= 0 || _isHideNaviBar || _isCropImage);
    _numberLabel.hidden = (_manager.selectedCount <= 0 || _isHideNaviBar || _isCropImage);
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    
    
    _doneButton.hidden = NO;
    _selectButton.hidden = YES;//!_tzImagePickerVc.showSelectBtn;
//    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
//    if (![[TZImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
//        _numberLabel.hidden = YES;
//        _numberImageView.hidden = YES;
//        _selectButton.hidden = YES;
//        _originalPhotoButton.hidden = YES;
//        _originalPhotoLabel.hidden = YES;
//        _doneButton.hidden = YES;
//    }
}

- (void)showPhotoBytes {

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
