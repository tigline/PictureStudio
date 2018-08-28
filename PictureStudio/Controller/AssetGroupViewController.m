//
//  AssetGroupViewController.m
//  PictureStudio
//
//  Created by mickey on 2018/8/27.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AssetGroupViewController.h"
#import "AssetTableViewCell.h"
#import "AHAssetGroupCell.h"
#import "AHAssetGroupsView.h"
#import "AssetCollectionCell.h"

@interface AssetGroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSIndexPath  *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UICollectionView *assetGroupView;
//@property (strong, nonatomic) UICollectionView *assetGroupView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@end

@implementation AssetGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.orangeColor;
    [self initAssetGroupView];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initAssetGroupView {
    //_assetGroupView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.hx_w, self.view.hx_h) collectionViewLayout:self.flowLayout];
    //_assetGroupView.collectionViewLayout = self.flowLayout;
    _assetGroupView.dataSource = self;
    _assetGroupView.delegate = self;
    _assetGroupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _assetGroupView.alwaysBounceVertical = YES;
    [_assetGroupView registerClass:[AssetCollectionCell class]
        forCellWithReuseIdentifier:@"AssetCollectionCell"];

}

- (void)reloadCollectionView {
    [_assetGroupView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.assetGroupView reloadData];
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 16;
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.sectionInset = UIEdgeInsetsMake(11, 11, 11, 11);
        //        if (iOS9_Later) {
        //            _flowLayout.sectionHeadersPinToVisibleBounds = YES;
        //        }
    }
    return _flowLayout;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsGroups.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight;
    if (indexPath.item == 0) {
        itemHeight = 80;
    } else {
        itemHeight = 87.4;
    }
    CGSize size = CGSizeMake(SCREEN_W - 22, itemHeight);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   AssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCollectionCell" forIndexPath:indexPath];
    cell.model = self.assetsGroups[indexPath.row];
    if (indexPath.row == 0) {
        [cell.bgImageView setImage:[UIImage imageNamed:@"album_list_top"]];
        [cell.bgImageView setHighlightedImage:[UIImage imageNamed:@"album_list_top_p"]];
    }
    if (_indexAssetsGroup == indexPath.row) {
        //cell.isSelected = YES;
        [cell setSelectedImage:indexPath.row];
    } else {
        cell.isSelected = NO;
        [cell setSelectedImagenil:indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect initFrame = cell.frame;
    cell.frame = CGRectMake(cell.originX, cell.originY + 3*cell.hx_h, cell.hx_w, cell.hx_h);
    cell.alpha = 0.5;
    CGFloat duration = 0.5;
    CGFloat offset = 0.08 * indexPath.row;
    [UIView animateWithDuration:(duration + offset) animations:^{
        cell.frame = initFrame;
        cell.alpha = 1;
    }];
}

//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    
//}





@end
