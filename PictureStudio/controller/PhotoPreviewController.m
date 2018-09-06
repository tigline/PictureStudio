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
#import "UINavigationBar+Color.h"

@interface PhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,DatePhotoViewControllerDelegate> {
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

    
    CGFloat _offsetItemCount;
}
@property (nonatomic, assign) BOOL isHideNaviBar;

@property (nonatomic, assign) double progress;
@property (strong, nonatomic) id alertView;
@end

@interface PhotoPreviewController ()

@end

@implementation PhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.navigationBar setColor:nil];
    //__weak typeof(self) weakSelf = self;
    
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithArray:_manager.selectedArray];
        //_assetsTemp = [NSMutableArray arrayWithArray:_manager.selectedArray];
    }
    [self configCollectionView];
    //[self configCustomNaviBar];
    [self configBottomToolBar];
    //self.view.clipsToBounds = YES;
    self.navigationItem.title = @"未选择";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.hx_w + 20) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];


}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)configCustomNaviBar {

    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = UIColor.whiteColor;
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectButton setImage:[UIImage imageNamed:@"photo_unselect"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"photo_select_bg"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//    _selectButton.hidden = NO;//!tzImagePickerVc.showSelectBtn;
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectButton setImage:[UIImage imageNamed:@"photo_unselect"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"photo_select"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_selectButton];

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
    CGFloat toolBarHeight = kDevice_Is_iPhoneX ? 44 + (83 - 49) : 44;
//    CGFloat statusBarHeight = kDevice_Is_iPhoneX ? 44 : 20 ;
//    CGFloat statusBarHeightInterval = statusBarHeight - 20;
//    CGFloat naviBarHeight = statusBarHeight + kNavigationBarHeight;
//    _naviBar.frame = CGRectMake(0, 0, self.view.hx_w, naviBarHeight);
    //_backButton.frame = CGRectMake(10, 10 + statusBarHeightInterval, 44, 44);
    //_selectButton.frame = CGRectMake(self.view.hx_w - 54, 10 + statusBarHeightInterval, 42, 42);
    
    _layout.itemSize = CGSizeMake(self.view.hx_w + 20, self.view.hx_h - kNavigationBarHeight - toolBarHeight);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, kNavigationBarHeight, self.view.hx_w + 20, self.view.hx_h - kNavigationBarHeight - toolBarHeight);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }

    
    
    CGFloat toolBarTop = self.view.hx_h - toolBarHeight;
    _toolBar.frame = CGRectMake(0, toolBarTop, self.view.hx_w, toolBarHeight);
    _selectButton.frame = CGRectMake((self.view.hx_w - toolBarHeight)/2, 0, toolBarHeight, toolBarHeight);
    //_selectButton.center = _toolBar.center;

 
    

}
#pragma mark - didSelectDelegate

- (void)datePhotoViewControllerDidChangeSelect:(HXPhotoModel *)model selected:(BOOL)selected
{
    
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    //ViewController *_tzImagePickerVc = (ViewController *)self.navigationController;
    HXPhotoModel *model = _models[_currentIndex];
    if (selectButton.isSelected) {
        NSArray *selectedModels = [NSArray arrayWithArray:_manager.selectedArray];
        
        
        for (NSInteger i = 0; i < selectedModels.count; i++) {
            id asset = selectedModels[i];
            if ([asset isEqual:_models[_currentIndex]]) {
                [_manager beforeSelectedListdeletePhotoModel:asset];
                break;
            }
        }
        
    } else {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        NSString *str = [self.manager maximumOfJudgment:model];
        if (str) {
            [self.view showImageHUDText:str];
            return;
        } else {
            [_manager beforeSelectedListAddPhotoModel:model];
            //            if (self.photos) {
            //                [_tzImagePickerVc.selectedAssets addObject:_assetsTemp[_currentIndex]];
            //                [self.photos addObject:_photosTemp[_currentIndex]];
            //            }
            
        }

    }
//    else {
//        [self.view showImageHUDText:LocalString(@"right_operate_tips")];
//        return;
//    }
    
    
    model.selected = !selectButton.isSelected;
    if ([self.delegate respondsToSelector:@selector(datePhotoPreviewControllerDidSelect:model:)]) {
        [self.delegate datePhotoPreviewControllerDidSelect:self model:model];
    }
    [self refreshNaviBarAndBottomBarState];

}

- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
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

    
    __weak typeof(self) weakSelf = self;
    PhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPreviewCell" forIndexPath:indexPath];
    HXPhotoModel *model = self.models[indexPath.item];
    cell.model = model;

    [cell setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didTapPreviewCell];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //[(PhotoPreviewCell *)cell recoverSubviews];
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    //[(PhotoPreviewCell *)cell recoverSubviews];
    
}

#pragma mark - Private Method

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)refreshNaviBarAndBottomBarState {
    
    HXPhotoModel *model = _models[_currentIndex];
    _selectButton.selected = model.selected;
    
    if (model.selected) {
        self.navigationItem.title = [NSString stringWithFormat:@"选择第%@张截图",model.selectIndexStr];
    } else {
        self.navigationItem.title = @"未选择";
    }
//    _numberLabel.text = [NSString stringWithFormat:@"%zd",_manager.selectedCount];
//    _numberImageView.hidden = (_manager.selectedCount <= 0 || _isHideNaviBar || _isCropImage);
//    _numberLabel.hidden = (_manager.selectedCount <= 0 || _isHideNaviBar || _isCropImage);
//
//
//    if (_isSelectOriginalPhoto) [self showPhotoBytes];
//
//    _doneButton.hidden = NO;
//    _selectButton.hidden = NO;//!_tzImagePickerVc.showSelectBtn;

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
