//
//  ModifyViewController.m
//  PictureStudio
//
//  Created by mickey on 2018/9/9.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "ModifyViewController.h"
#import <Photos/Photos.h>
#import "HXPhotoDefine.h"
#import "AppDelegate.h"
#import "PhotoSaveBottomView.h"
#import "UIView+HXExtension.h"
#import "HXPhotoDefine.h"
#import "ToastView.h"
#import "ShareBoardView.h"
#import "PhotoCutModel.h"
#import "SwipeEdgeInteractionController.h"
#import "HXPhotoManager.h"
#import "MoveItemCell.h"
#import "ModifyCollectionViewCell.h"
#import "MoveItemView/MoveItemCell.h"
#import "MoveInfoModel.h"

@interface ModifyViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ModifyCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveBtn;
@property (weak, nonatomic) IBOutlet UIButton *borderBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnMaginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnMaginRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveBtnMaginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBtnMaginRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewMaginTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnToTop;


@property (weak, nonatomic) IBOutlet UIScrollView *showImageScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *showImageCollectionView;

//@property (strong, nonatomic) UIScrollView *showImageScrollView;
@property (strong, nonatomic) UIScrollView *shareScrollView;
@property (strong, nonatomic) PhotoSaveBottomView *toolBarView;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) BOOL isFinish;
@property (assign, nonatomic) BOOL isEdittMove;
@property (assign, nonatomic) NSInteger movePartCount;

@property (strong, nonatomic) UIScrollView *moveItemUpView;
@property (strong, nonatomic) UIScrollView *moveItemDownView;
@property (strong, nonatomic) NSArray *upImagesArray;
@property (strong, nonatomic) NSArray *downImagesArray;
@property (strong, nonatomic) NSMutableArray *moveItemArray;

@property (strong, nonatomic) UIView *containImageView;

@end

static NSString * const identifier = @"moveCell";

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showImageCollectionView.hidden = YES;
    [self initView];
    
    [self createScrollView];
    self.moveItemArray = [[NSMutableArray alloc] init];

    self.view.backgroundColor = UIColor.backgroundColor;
    __weak typeof(self) weakSelf = self;
    _interactionController = [[SwipeEdgeInteractionController alloc] initWithViewController:self interationDirection:left completion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    //self.fd_prefersNavigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollFinish) name:@"scrollFinish" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_resultModels) {
        //
        [self CreateShowImgaeView:_resultModels];//创建图片显示区域
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.showImageCollectionView reloadData];
        });
        
        //[self.view addSubview:self.toolBarView];//创建保存图片区域
        //[self setInMoveState:50 index:0];
    }
    if (_manager.selectedCount > 3 && !_isFinish) {
        [self.view showLoadingHUDText:LocalString(@"scroll_ing")];
    }
    //    [self.navigationController.navigationBar setHidden:YES];
    //    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_manager.isScrollSuccess) {
        //[self showScrollError];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.manager setScrollResult:nil];
    
    //[self.navigationController.navigationBar setHidden:NO];
}

- (void)scrollFinish {
    _isFinish = YES;
    [self.view handleLoading];
    [self CreateShowImgaeView:[self.manager getScrollResult]];
    _resultModels = [self.manager getScrollResult];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.showImageCollectionView reloadData];
    });
    //[self.showImageCollectionView reloadData];
    //[self setInMoveState:200 index:0];

}

- (BOOL)prefersStatusBarHidden {
    if (kDevice_Is_iPhoneX) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initView {
    
    _scrollViewMaginTop.constant = 10*ScreenHeightRatio + kTopMargin;
    _bottomViewHeight.constant = ButtomViewHeight + kBottomMargin;
    _backBtnWidth.constant = 34*ScreenWidthRatio;
    _backBtnMaginLeft.constant = 20*ScreenWidthRatio;
    
    _nextBtnWidth.constant = 34*ScreenWidthRatio;
    _nextBtnMaginRight.constant = 20*ScreenWidthRatio;
    
    _moveBtnWidth.constant = 72*ScreenWidthRatio;
    _moveBtnHeight.constant = 34*ScreenHeightRatio;
    _borderBtnWidth.constant = 72*ScreenWidthRatio;
    _borderBtnHeight.constant = 34*ScreenHeightRatio;
    
    _moveBtnMaginLeft.constant = 106*ScreenWidthRatio;
    _borderBtnMaginRight.constant = 106*ScreenWidthRatio;
    
    _bottomBtnToTop.constant = 13*ScreenHeightRatio;
    _bottomView.layer.shadowOpacity = 0.99;
    _bottomView.layer.shadowColor = UIColor.navShadowColor.CGColor;
    _bottomView.layer.shadowRadius = 4;
    _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    _bottomView.layer.masksToBounds = NO;
    
    [_backBtn setImage:[UIImage imageNamed:@"tool_back"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"tool_back_p"] forState:UIControlStateHighlighted];
    
    [_nextBtn setImage:[UIImage imageNamed:@"tool_forward"] forState:UIControlStateNormal];
    [_nextBtn setImage:[UIImage imageNamed:@"tool_forward_p"] forState:UIControlStateHighlighted];
    
    [_moveBtn setImage:[UIImage imageNamed:@"tool_move"] forState:UIControlStateNormal];
    [_moveBtn setImage:[UIImage imageNamed:@"tool_move_l"] forState:UIControlStateSelected];
    
    [_borderBtn setImage:[UIImage imageNamed:@"tool_border"] forState:UIControlStateNormal];
    [_borderBtn setImage:[UIImage imageNamed:@"tool_border_l"] forState:UIControlStateHighlighted];

}

- (void)createScrollView {
    //_showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.view.hx_w, self.view.hx_h - kBottomMargin - kTopMargin - ButtomViewHeight)];
    //_showImageScrollView.delegate = self;
    //[self.view addSubview:_showImageScrollView];
    //_showImageScrollView.backgroundColor = [UIColor backgroundColor];
    _showImageScrollView.bouncesZoom = YES;
    _showImageScrollView.maximumZoomScale = 2.5;
    _showImageScrollView.minimumZoomScale = 1.0;
    //_showImageScrollView.multipleTouchEnabled = YES;
    //_showImageScrollView.scrollsToTop = NO;
    _showImageScrollView.showsHorizontalScrollIndicator = NO;
    _showImageScrollView.showsVerticalScrollIndicator = NO;
//    _showImageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _showImageScrollView.delaysContentTouches = NO;
    _showImageScrollView.canCancelContentTouches = YES;
    _showImageScrollView.alwaysBounceVertical = NO;
    //_showImageScrollView.userInteractionEnabled = YES;
    
    _containImageView = [[UIView alloc] init];
    _containImageView.clipsToBounds = YES;
    
    //_containImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_showImageScrollView addSubview:_containImageView];
    
//    if (@available(iOS 11.0, *)) {
//        _showImageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//
//    }
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnImage:)];
//    [_showImageScrollView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self.view addGestureRecognizer:tap2];
}


- (void)CreateShowImgaeView:(NSArray *)resultArray
{
    //    self.showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10*ScreenWidthRatio, kTopMargin + 10*ScreenHeightRatio, 355*ScreenWidthRatio, 517*ScreenHeightRatio)];
    
    //CGFloat maginTop = kDevice_Is_iPhoneX ? 10 : 10;
    _containImageView = [[UIView alloc] init];
    //_containImageView.clipsToBounds = YES;
    
    //_containImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_showImageScrollView addSubview:_containImageView];
    if (resultArray != nil ){
        CGRect cgpos;
        NSInteger count = resultArray.count;
        for (int i = 0; i < count; i++) {
            PhotoCutModel *mode = [resultArray objectAtIndex:i];
            UIImage *image = mode.originPhoto;
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            CGFloat itemHeight = (mode.endY - mode.beginY);
            UIScrollView *itemView = [[UIScrollView alloc]init];
            
            CGFloat contentViewOffset;
            if(i == 0) {
                contentViewOffset = 0;
            } else {
                contentViewOffset = _containImageView.hx_h;
            }
            
            CGFloat ratio = (_showImageScrollView.hx_w)/imageView.hx_w;
            
            cgpos.origin.x = 0;
            cgpos.origin.y = contentViewOffset;
            cgpos.size.width = _showImageScrollView.hx_w;
            cgpos.size.height = itemHeight*ratio;
            itemView.frame = cgpos;
            
            [_containImageView addSubview:itemView];
            itemView.contentSize = CGSizeMake(_showImageScrollView.hx_w, imageView.hx_h*ratio);
            itemView.contentOffset = CGPointMake(0, mode.beginY*ratio);
            itemView.scrollEnabled = NO;
            
            CGFloat lastOffset;
            if (i == resultArray.count - 1 || i == 0) {
                lastOffset = cgpos.size.height;
            } else {
                lastOffset = cgpos.size.height;
            }
            
            _containImageView.size = CGSizeMake(cgpos.size.width, _containImageView.hx_h + lastOffset);
            //itemView.contentSize = CGSizeMake(_showImageScrollView.hx_w - 20, itemView.contentSize.height*1.5);
            
            imageView.size = CGSizeMake(_showImageScrollView.hx_w, itemView.contentSize.height);
            [itemView addSubview:imageView];

            [self addLayerBorder:imageView count:count index:i direction:YES];
            //[self addLayerBorder:imageView count:count index:i direction:isCombineVertical];
            
        }
        _containImageView.frame = CGRectMake(0, 0, _showImageScrollView.hx_w, _containImageView.hx_h);
        
        //_containImageView.layer.borderWidth = 1*ScreenWidthRatio;
        //_containImageView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        [_showImageScrollView setContentSize:CGSizeMake(_showImageScrollView.hx_w, _containImageView.hx_h)];
    }
}

-(void)addLayerBorder:(UIImageView *)imageView count:(NSInteger)count index:(NSInteger)index direction:(BOOL)isVertical {
    UIColor *color = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    CGFloat width = 1*ScreenWidthRatio;
    if (isVertical) {
        if (index == 0) {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
        } else if (index == count - 1) {
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        } else {
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
        }
    } else {
        if (index == 0) {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        } else if (index == count - 1) {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        } else {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        }
    }
    
}

- (void)setInMoveState:(CGFloat)borderY index:(NSInteger)index {
    
//    for (UIView *subview in self.containImageView.subviews) {
//        [subview removeFromSuperview];
//    }
//    self.containImageView = nil;
//    _containImageView = [[UIView alloc] init];
//    _containImageView.clipsToBounds = YES;
//
//    [_showImageScrollView addSubview:_containImageView];
    _upImagesArray = [_resultModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index + 1)]];
    _downImagesArray = [_resultModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 1, _resultModels.count - index - 1)]];
    
    CGRect upFrame = CGRectMake(0, 0, _showImageScrollView.hx_w, borderY);
    _moveItemUpView = [self createMoveItemViewWithFrame:upFrame itemArray:_upImagesArray toBottom:YES];
    _moveItemUpView.delegate = self;
    [_showImageScrollView addSubview:_moveItemUpView];
    
    CGRect downFrame = CGRectMake(0, borderY, _showImageScrollView.hx_w, _showImageScrollView.hx_h - borderY);
    _moveItemDownView = [self createMoveItemViewWithFrame:downFrame itemArray:_downImagesArray toBottom:NO];
    [_showImageScrollView addSubview:_moveItemDownView];
    
}

- (UIScrollView *)createMoveItemViewWithFrame:(CGRect )frame itemArray:(NSArray *)itemArray toBottom:(BOOL)toBottom {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    UIView *containView = [[UIView alloc] init];
    containView.clipsToBounds = YES;
    [scrollView addSubview:containView];
    
    
    CGRect cgpos;
    NSInteger count = itemArray.count;
    for (int i = 0; i < count; i++) {
        PhotoCutModel *mode = [itemArray objectAtIndex:i];
        UIImage *image = mode.originPhoto;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat itemHeight = (mode.endY - mode.beginY);
        //MoveItemView *itemView = [[MoveItemView alloc]initWithFrame:CGRectZero];
        
        CGFloat contentViewOffset;
        if(i == 0) {
            contentViewOffset = 0;
        } else {
            contentViewOffset = containView.hx_h;
        }
        
        CGFloat ratio = (_showImageScrollView.hx_w)/imageView.hx_w;
        
        cgpos.origin.x = 0;
        cgpos.origin.y = contentViewOffset;
        cgpos.size.width = _showImageScrollView.hx_w;
        cgpos.size.height = itemHeight*ratio;
        //itemView.frame = cgpos;
        //MoveItemView *itemView = [[MoveItemView alloc]initWithFrame:cgpos model:mode];
        UIScrollView *itemView = [[UIScrollView alloc]initWithFrame:cgpos];
        
        [containView addSubview:itemView];
        itemView.contentSize = CGSizeMake(_showImageScrollView.hx_w, imageView.hx_h*ratio);
        itemView.contentOffset = CGPointMake(0, mode.beginY*ratio);
        itemView.scrollEnabled = NO;
        
        CGFloat lastOffset;
        if (i == itemArray.count - 1 || i == 0) {
            lastOffset = cgpos.size.height;
        } else {
            lastOffset = cgpos.size.height;
        }
        
        containView.size = CGSizeMake(cgpos.size.width, containView.hx_h + lastOffset);
        //itemView.contentSize = CGSizeMake(_showImageScrollView.hx_w - 20, itemView.contentSize.height*1.5);
        
        imageView.size = CGSizeMake(_showImageScrollView.hx_w, itemView.contentSize.height);
        [itemView addSubview:imageView];
        [self addLayerBorder:imageView count:count index:i direction:YES];
        //[self addLayerBorder:imageView count:count index:i direction:isCombineVertical];
        
    }
    containView.frame = CGRectMake(0, 0, _showImageScrollView.hx_w, containView.hx_h);
    [scrollView setContentSize:CGSizeMake(_showImageScrollView.hx_w, containView.hx_h)];
    if (toBottom) {
        CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
        [scrollView setContentOffset:bottomOffset animated:NO];
        //[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        
    }
    return scrollView;
}

#pragma mark ModifyCellDelegate
- (void)onUpDragItemTap:(NSInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.showImageCollectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    CGRect rectInCollectionView = [self.showImageCollectionView convertRect:cellRect toView:self.showImageCollectionView];
    CGRect rectInWindow = [self.showImageCollectionView convertRect:rectInCollectionView toView:[self.showImageCollectionView superview]];
    self.isEdittMove = YES;
    self.showImageCollectionView.scrollEnabled = NO;
    if (index == 0) {
        _movePartCount = 1;
        MoveInfoModel * model = [[MoveInfoModel alloc] init];
        model.index = index;
        model.itemFrameHeight = _showImageCollectionView.hx_h;
        model.isMoveUp = YES;
        model.isMoveDown = NO;
        model.photoArray = self.resultModels;
        PhotoCutModel *cutModel = [self.resultModels objectAtIndex:index];
        model.canMoveHeight = cutModel.beginY - cutModel.endY;
        model.itemHeight = [self getMoveItemHeight:model.photoArray];
        [_moveItemArray addObject:model];
        
    } else {
        _movePartCount = 2;
        for (int i = 1; i >= 0; i--) {
            MoveInfoModel * model = [[MoveInfoModel alloc] init];
            model.index = index - i;
            model.isMoveUp = YES;
            if (i == 1) {
                model.itemFrameHeight = rectInWindow.origin.y - _showImageCollectionView.frame.origin.y;
                model.isMoveUp = NO;
                model.isMoveDown = YES;
                model.photoArray = [_resultModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index)]];
            } else {
                model.itemFrameHeight = _showImageCollectionView.hx_h - rectInWindow.origin.y + _showImageCollectionView.frame.origin.y;
                model.isMoveUp = YES;
                model.isMoveDown = NO;
                model.photoArray = [_resultModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, _resultModels.count - index)]];
            }
            
            PhotoCutModel *cutModel = [self.resultModels objectAtIndex:index - i];
            model.canMoveHeight = cutModel.beginY - cutModel.endY;
            model.itemHeight = [self getMoveItemHeight:model.photoArray];
            [_moveItemArray addObject:model];
        }
    }
    
    [self.showImageCollectionView reloadData];
}

- (void)onDownDragItemTap:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.showImageCollectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    CGRect rectInCollectionView = [self.showImageCollectionView convertRect:cellRect toView:self.showImageCollectionView];
    CGRect rectInWindow = [self.showImageCollectionView convertRect:rectInCollectionView toView:[self.showImageCollectionView superview]];
    
    self.isEdittMove = YES;
    self.showImageCollectionView.scrollEnabled = NO;
    if (index == self.resultModels.count - 1) {
        _movePartCount = 1;
        MoveInfoModel * model = [[MoveInfoModel alloc] init];
        model.index = index;
        model.itemFrameHeight = _showImageScrollView.hx_h;
        model.isMoveUp = NO;
        model.isMoveDown = YES;
        model.photoArray = self.resultModels;
        PhotoCutModel *cutModel = [self.resultModels objectAtIndex:index];
        model.canMoveHeight = cutModel.endY - cutModel.beginY;
        model.itemHeight = [self getMoveItemHeight:model.photoArray];
        [_moveItemArray addObject:model];
    } else {
        _movePartCount = 2;
        for (int i = 0; i < 2; i++) {
            MoveInfoModel * model = [[MoveInfoModel alloc] init];
            model.index = index + i;
            
            if (i == 0) {
                model.itemFrameHeight = rectInWindow.size.height - _showImageCollectionView.frame.origin.y + rectInWindow.origin.y;
                model.isMoveUp = NO;
                model.isMoveDown = YES;
                model.photoArray = [_resultModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index + 1)]];
            } else {
                model.itemFrameHeight = _showImageCollectionView.hx_h - cellRect.size.height + _showImageCollectionView.frame.origin.y - rectInWindow.origin.y;
                model.isMoveUp = YES;
                model.isMoveDown = NO;
                model.photoArray = [_resultModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 1, _resultModels.count - index - 1)]];
            }
            
            PhotoCutModel *cutModel = [self.resultModels objectAtIndex:index + i];
            model.canMoveHeight = cutModel.endY - cutModel.beginY;
            model.itemHeight = [self getMoveItemHeight:model.photoArray];
            [_moveItemArray addObject:model];
        }
    }
    [self.showImageCollectionView reloadData];
}

- (CGFloat)getMoveItemHeight:(NSArray *)modelArray {
    CGFloat height = 0;
    for (int i = 0; i < modelArray.count; i ++) {
        PhotoCutModel *cutModel = [modelArray objectAtIndex:i];
        CGFloat cutHeight = cutModel.endY - cutModel.beginY;
        CGFloat ratio = (_showImageCollectionView.hx_w)/cutModel.originPhoto.size.width;
        CGFloat addHeight = cutHeight*ratio;
        height += addHeight;
    }
    return height;
    
}


#pragma mark scrollView delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentHeight = scrollView.contentSize.height - scrollView.bounds.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    if (contentOffsetY < 0) {
        _moveItemUpView.frame = CGRectMake(0, _moveItemUpView.originY-contentOffsetY, _moveItemUpView.hx_w, _moveItemUpView.hx_h+contentOffsetY);
    } else {
        
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat contentHeight = scrollView.contentSize.height - self.view.hx_h;
//    CGFloat contentOffsetY = scrollView.contentOffset.y;
//
//    if (contentOffsetY < 0) {
//        //self.showImageScrollView.frame = CGRectMake(0, kTopMargin + contentOffsetY, self.view.hx_w, self.view.hx_h);
//    } else if (contentOffsetY < kTopMargin && contentOffsetY > 0) {
//        self.showImageScrollView.frame = CGRectMake(0, kTopMargin - contentOffsetY, self.view.hx_w, self.view.hx_h - ButtomViewHeight);
//    } else if (contentOffsetY < contentHeight && contentOffsetY > kTopMargin) {
//        //向下
//        //if (_canDetectScroll) {
//
//
//        self.showImageScrollView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h - self.toolBarView.hx_h);
//
//        //}
//        //[self.navigationController setNavigationBarHidden:NO animated:YES];
//
//    } else if (scrollView.contentOffset.y > contentHeight) {
//
//
//        //向上
//        CGFloat bottomMargin = 0.0;
//        if (kDevice_Is_iPhoneX) {
//            bottomMargin = self.toolBarView.hx_h;
//        } else {
//            bottomMargin = ButtomViewHeight;
//        }
//        if (contentOffsetY > contentHeight && contentOffsetY < contentHeight+bottomMargin) {
//            self.showImageScrollView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h - bottomMargin - ButtomViewHeight);
//        }
//        //[self.navigationController setNavigationBarHidden:YES animated:YES];
//
//    }
//}
- (void)showScrollError
{
    NSString *strTitle = LocalString(@"scroll_error");
    
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                    message:LocalString(@"scroll_operate_tips")
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_showImageScrollView.zoomScale > 1.0) {
        _showImageScrollView.contentInset = UIEdgeInsetsZero;
        [_showImageScrollView setZoomScale:1.0 animated:YES];
        
    } else {
        CGPoint touchPoint = [tap locationInView:self.containImageView];
        CGFloat newZoomScale = _showImageScrollView.maximumZoomScale;
        CGFloat xsize = self.view.frame.size.width / newZoomScale;
        CGFloat ysize = self.view.frame.size.height / newZoomScale;
        [_showImageScrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    //    if (self.singleTapGestureBlock) {
    //        self.singleTapGestureBlock();
    //    }
}

#pragma mark - Buttom Action

- (IBAction)onMoveBtnTap:(id)sender {
    UIButton *moveBtn = (UIButton*)sender;
    moveBtn.selected = !moveBtn.selected;
    if (moveBtn.selected == YES) {
        self.view.backgroundColor = UIColor.grayColor;
        for (UIView *subview in self.containImageView.subviews) {
            [subview removeFromSuperview];
        }
        self.containImageView = nil;
        _showImageScrollView.hidden = YES;
        self.showImageCollectionView.hidden = NO;
        [self.showImageCollectionView reloadData];
    } else {
        self.view.backgroundColor = UIColor.backgroundColor;
        _showImageScrollView.hidden = NO;
        self.showImageCollectionView.hidden = YES;
        [self CreateShowImgaeView:self.resultModels];
    }
}

- (IBAction)onBorderBtnTap:(id)sender {
    
}


- (IBAction)onBackBtnTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onNextBtnTap:(id)sender {
    
}



#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //[self refreshScrollViewContentSize];
    //_containImageView.frame = CGRectMake(_containImageView.originX, _containImageView.originY, _containImageView.hx_w, _containImageView.hx_h);
    //[_showImageScrollView setContentSize:CGSizeMake(_showImageScrollView.frame.size.width, _showImageScrollView.contentSize.height)];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_showImageScrollView.hx_w > _showImageScrollView.contentSize.width) ? ((_showImageScrollView.hx_w - _showImageScrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_showImageScrollView.hx_h > _showImageScrollView.contentSize.height) ? ((_showImageScrollView.hx_h - _showImageScrollView.contentSize.height) * 0.5) : 0.0;
    self.containImageView.center = CGPointMake(_showImageScrollView.contentSize.width * 0.5 + offsetX, _showImageScrollView.contentSize.height * 0.5 + offsetY);
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (_isEdittMove) {
        MoveItemCell *cell = [self.showImageCollectionView dequeueReusableCellWithReuseIdentifier:@"moveCollectionCell" forIndexPath:indexPath];
        MoveInfoModel *model = [_moveItemArray objectAtIndex:indexPath.row];
        [cell configCell:model];
        return cell;
    } else {
        ModifyCollectionViewCell *cell = [self.showImageCollectionView dequeueReusableCellWithReuseIdentifier:@"modifyCollectionCell" forIndexPath:indexPath];
        PhotoCutModel *model = [self.resultModels objectAtIndex:indexPath.row];
        cell.modifyDelegate = self;
        [cell configCell:model];
        return cell;
    }
    
    
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_isEdittMove) {
        return _movePartCount;
    } else {
        return self.resultModels.count;
    }
    
}

//设置每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (_isEdittMove) {
        MoveInfoModel *model = [self.moveItemArray objectAtIndex:indexPath.row];
        if (model.index == 0 || model.index == self.resultModels.count - 1) {
            size = CGSizeMake(collectionView.hx_w,collectionView.hx_h);
        } else {
            
            size = CGSizeMake(collectionView.hx_w,model.itemFrameHeight);
        }
    } else {
        PhotoCutModel *model = [self.resultModels objectAtIndex:indexPath.row];
        CGFloat imageCutHeight = (model.endY - model.beginY);
        CGFloat ratio = (collectionView.hx_w)/model.originPhoto.size.width;
        CGFloat cellHeight = imageCutHeight*ratio;
        size = CGSizeMake(collectionView.hx_w,cellHeight);
    }
    
    
    return size;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//
//    return CGSizeZero;
//}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (_isEdittMove) {
        return 0;
    } else {
        return 10;
    }
    
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}



@end
