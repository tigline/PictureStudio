//
//  ArtAssetGroupsView.m
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "AHAssetGroupsView.h"
#import "AHAssetGroupCell.h"
#import "UIView+HXExtension.h"

@interface AHAssetGroupsView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSIndexPath  *selectedIndexPath;

@end

static CGFloat kHeightAssetsGroupCell = 80;

@implementation AHAssetGroupsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5f];
        [self tableView];
    }
    return self;
}

- (void)setAssetsGroups:(NSArray *)assetsGroups
{
    _assetsGroups = assetsGroups;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.assetsGroups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //AHAssetGroupCell *cell = [[AHAssetGroupCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier: @"AHAssetGroupCell"];
    AHAssetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AHAssetGroupCell"];
    //cell.assetsGroup = self.assetsGroups[indexPath.row];
    cell.model = self.assetsGroups[indexPath.row];
    if (indexPath.row == 0) {
        [cell.bgImage setImage:[UIImage imageNamed:@"album_list_top"]];
        [cell.bgImage setHighlightedImage:[UIImage imageNamed:@"album_list_top_p"]];
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


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        return 87.4;
    }
    return kHeightAssetsGroupCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndexPath = indexPath;
    [self.tableView reloadData];
    HXAlbumModel *albumModel = self.assetsGroups[indexPath.row];
    _indexAssetsGroup = indexPath.row;
    //NSDictionary *collection = self.assetsGroups[indexPath.row];
    if (self.groupSelectedBlock) {
        self.groupSelectedBlock(albumModel);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect initFrame = cell.frame;
    cell.frame = CGRectMake(cell.originX, cell.originY + 3*cell.hx_h, cell.hx_w, cell.hx_h);
    cell.alpha = 0.5;
    CGFloat duration = 0.5;
    CGFloat offset = 0.08 * indexPath.row;
    [UIView animateWithDuration:duration + offset  animations:^{
        cell.frame = initFrame;
        cell.alpha = 1;
    }];
}




#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.hx_w, self.hx_h) style:UITableViewStylePlain];
        //[_tableView registerClass:[AHAssetGroupCell class] forCellReuseIdentifier:@"AHAssetGroupCell"];
        
        UINib *mfbCellNib = [UINib nibWithNibName:@"AHAssetGroupCell" bundle:nil];
        [_tableView registerNib:mfbCellNib forCellReuseIdentifier:@"AHAssetGroupCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset=UIEdgeInsetsMake(0,0,0,0);
        _tableView.backgroundColor = UIColor.clearColor;
        
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)touchButton{
    if (!_touchButton) {
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchButton.frame = CGRectMake(0, self.tableView.leftBottom.y, self.size.width, self.size.height -self.tableView.leftBottom.y);
        [self addSubview:_touchButton];
    }
    return _touchButton;
}

@end
