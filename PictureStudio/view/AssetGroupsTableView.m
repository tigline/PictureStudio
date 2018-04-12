//
//  AssetGroupsTableView.m
//  PictureStudio
//
//  Created by mickey on 2018/4/8.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AssetGroupsTableView.h"
#import "UIView+HXExtension.h"
#import "AssetGroupTableViewCell.h"

@interface AssetGroupsTableView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSIndexPath  *selectedIndexPath;

@end

static CGFloat kHeightAssetsGroupCell = 47.8;

@implementation AssetGroupsTableView

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
    static NSString *identifier = @"ALiAssetGroupCell";
    
    AssetGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];;
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ALiAssetGroupCell"];
    }
    cell.model = self.assetsGroups[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightAssetsGroupCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndexPath = indexPath;
    [self.tableView reloadData];
    
    HXAlbumModel *albumModel = self.assetsGroups[indexPath.row];
    if (self.groupSelectedBlock) {
        self.groupSelectedBlock(albumModel);
    }
}


#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height) style:UITableViewStylePlain];
        [_tableView registerClass:[AssetGroupTableViewCell class] forCellReuseIdentifier:@"ALiAssetGroupCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorInset=UIEdgeInsetsMake(0,0,0,0);
        //_tableView.backgroundColor = [UIColor clearColor];
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
