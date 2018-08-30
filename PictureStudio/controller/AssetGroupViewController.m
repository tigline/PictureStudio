//
//  MyCollectionViewController.m
//  PictureStudio
//
//  Created by mickey on 2018/8/28.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AssetGroupViewController.h"
#import "UIView+HXExtension.h"
#import "AssetCollectionCell.h"
@interface AssetGroupViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation AssetGroupViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _needRunAnimation = NO;
    self.collectionView.backgroundColor = UIColor.clearColor;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    UINib *itemCellNib = [UINib nibWithNibName:@"AssetCollectionCell" bundle:nil];
    
    [self.collectionView registerNib:itemCellNib forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _flowLayout.minimumLineSpacing = 16;
    _flowLayout.minimumInteritemSpacing = 1;
    _flowLayout.sectionInset = UIEdgeInsetsMake(11, 11, 11, 11);
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _needRunAnimation = YES;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.assetsGroups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.assetsGroups[indexPath.row];
    if (indexPath.row == 0) {
        [cell.bgImageView setImage:[UIImage imageNamed:@"album_list_top"]];
        [cell.bgImageView setHighlightedImage:[UIImage imageNamed:@"album_list_top_p"]];
    }
    if (_indexAssetsGroup == indexPath.row) {
        cell.isSelected = YES;
        [cell setSelectedImage:indexPath.row];
    } else {
        cell.isSelected = NO;
        [cell setSelectedImagenil:indexPath.row];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight;
    if (indexPath.item == 0) {
        itemHeight = 87.4;
    } else {
        itemHeight = 80;
    }
    CGSize size = CGSizeMake(SCREEN_W - 22, itemHeight);
    return size;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //CGRect initFrame = cell.frame;
    //cell.frame = CGRectMake(cell.originX, cell.originY + 3*cell.hx_h, cell.hx_w, cell.hx_h);
    
    if (_needRunAnimation) {
        cell.transform = CGAffineTransformMakeTranslation(0, 4 * cell.hx_h); //CGAffineTransform(translationX: 0, y: CGFloat(4.0 * cell.frame.size.height))
        cell.alpha = 0.5;
        CGFloat duration = 0.5;
        CGFloat offset = 0.08 * indexPath.item;
        [UIView animateWithDuration:(duration + offset) animations:^{
            cell.transform = CGAffineTransformIdentity;
            //cell.frame = initFrame;
            cell.alpha = 1;
        }];
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //_selectedIndexPath = indexPath;

    HXAlbumModel *albumModel = self.assetsGroups[indexPath.row];
    _indexAssetsGroup = indexPath.row;
    //NSDictionary *collection = self.assetsGroups[indexPath.row];
    [self moveCellToHide:albumModel];
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_needRunAnimation) {
        _needRunAnimation = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_needRunAnimation) {
        _needRunAnimation = NO;
    }
}



- (void)moveCellToHide:(HXAlbumModel *)albumModel {
    
    NSArray *indexPathArray = [self.collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSIndexPath *path1 = obj1;
        NSIndexPath *path2 = obj2;
        NSComparisonResult result = [path1 compare:path2];
        //        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    if (self.groupSelectedBlock) {
        self.groupSelectedBlock(albumModel);
    }
    NSInteger index = 0;
    for (NSIndexPath *indexPath in indexPathArray) {
        AssetCollectionCell *cell = (AssetCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.transform = CGAffineTransformIdentity;
        CGFloat offset = index*0.08;
        [UIView animateWithDuration:0.4 + offset animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, 4 * cell.hx_h);
            cell.alpha = 0;
        } completion:^(BOOL finished) {
            if (index == indexPathArray.count - 1) {
                if (self.groupDismissBlock) {
                    self.groupDismissBlock();
                }
            }
        }];
        index += 1;
    }
    
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
