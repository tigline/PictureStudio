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

static CGFloat kHeightAssetsGroupCell = 47.8;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //AHAssetGroupCell *cell = [[AHAssetGroupCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier: @"AHAssetGroupCell"];
    AHAssetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AHAssetGroupCell"];
    //cell.assetsGroup = self.assetsGroups[indexPath.row];
    cell.model = self.assetsGroups[indexPath.row];
    if (_indexAssetsGroup == indexPath.row) {
        //cell.isSelected = YES;
        [cell setSelectedImage];
    } else {
        cell.isSelected = NO;
        [cell setSelectedImagenil];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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


#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height) style:UITableViewStylePlain];
        //[_tableView registerClass:[AHAssetGroupCell class] forCellReuseIdentifier:@"AHAssetGroupCell"];
        
        UINib *mfbCellNib = [UINib nibWithNibName:@"AHAssetGroupCell" bundle:nil];
        [_tableView registerNib:mfbCellNib forCellReuseIdentifier:@"AHAssetGroupCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset=UIEdgeInsetsMake(0,0,0,0);
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
