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
#import "MoveCollectionViewFlowLayout.h"
#import "borderView.h"
#import "ShareBoardView.h"
#import "UIImage+HXExtension.h"

@interface ModifyViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CAAnimationDelegate, MoveCellDelegate,ShareBoardViewDelegate>

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

@property (weak, nonatomic) IBOutlet UIButton *realGoldButton;
@property (weak, nonatomic) IBOutlet UIButton *realBlackButton;
@property (weak, nonatomic) IBOutlet UIButton *realWhiteButton;


@property (weak, nonatomic) IBOutlet UICollectionView *showImageCollectionView;
@property (weak, nonatomic) IBOutlet MoveCollectionViewFlowLayout *moveCollectionViewLayout;


//@property (strong, nonatomic) UIScrollView *showImageScrollView;
@property (strong, nonatomic) UIScrollView *shareScrollView;
@property (strong, nonatomic) PhotoSaveBottomView *toolBarView;
@property (strong, nonatomic) ShareBoardView *shareBoardView;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) BOOL isFinish;
@property (assign, nonatomic) BOOL isEdittMove;
@property (assign, nonatomic) BOOL canTap;

@property (assign, nonatomic) NSInteger movePartCount;

@property (strong, nonatomic) UIScrollView *moveItemUpView;
@property (strong, nonatomic) UIScrollView *moveItemDownView;
@property (strong, nonatomic) NSArray *upImagesArray;
@property (strong, nonatomic) NSArray *downImagesArray;
@property (strong, nonatomic) NSMutableArray *moveItemArray;
@property (strong, nonatomic) UIColor *curBorderColor;
@property (assign, nonatomic) CGFloat curBorderWidth;
@property (nonatomic, assign) NSInteger shareType;

@property (weak, nonatomic) IBOutlet UIView *borderBtnContainView;
@property (strong, nonatomic) UIView *containImageView;
@property (weak, nonatomic) IBOutlet borderView *borderSelectView;
@property (weak, nonatomic) IBOutlet UIButton *thinBorder;
@property (weak, nonatomic) IBOutlet UIButton *midBorder;
@property (weak, nonatomic) IBOutlet UIButton *boldBorder;
@property (weak, nonatomic) IBOutlet UIButton *noBoder;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UIButton *goldButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderSelectViewHeight;

@end

static NSString * const identifier = @"moveCell";

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    [self.view addSubview:self.shareBoardView];
    
    self.moveItemArray = [[NSMutableArray alloc] init];

    self.view.backgroundColor = UIColor.backgroundColor;
    __weak typeof(self) weakSelf = self;
    _interactionController = [[SwipeEdgeInteractionController alloc] initWithViewController:self interationDirection:left completion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//    [self.view addGestureRecognizer:tap1];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
//    tap2.numberOfTapsRequired = 2;
//    [tap1 requireGestureRecognizerToFail:tap2];
//    [self.view addGestureRecognizer:tap2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollFinish) name:@"scrollFinish" object:nil];
    _moveCollectionViewLayout.canPress = YES;
    _moveCollectionViewLayout.modifyDelegate = self;
    self.showImageCollectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.moveCollectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_resultModels) {
        __weak typeof(self) weakSelf = self;

        [weakSelf.showImageCollectionView reloadData];
        //[self.view addSubview:self.toolBarView];//创建保存图片区域
        //[self setInMoveState:50 index:0];
    }
    if (_manager.selectedCount > 3 && !_isFinish && !_isCombineView) {
        [self.view showLoadingHUDText:LocalString(@"scroll_ing")];
    }
    //[self.navigationController.navigationBar setHidden:YES];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.canTap = YES;
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
    _resultModels = [self.manager getScrollResult];
    __weak typeof(self) weakSelf = self;

    [weakSelf.showImageCollectionView reloadData];
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
    
    _borderSelectViewHeight.constant *= ScreenHeightRatio;
    
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
    [_borderBtn setImage:[UIImage imageNamed:@"tool_border_l"] forState:UIControlStateSelected];
    
    [_noBoder setImage:[UIImage imageNamed:@"border_none"] forState:UIControlStateNormal];
    [_noBoder setImage:[UIImage imageNamed:@"border_none_p"] forState:UIControlStateSelected];
    
    [_thinBorder setImage:[UIImage imageNamed:@"border_thin"] forState:UIControlStateNormal];
    [_thinBorder setImage:[UIImage imageNamed:@"border_thin_p"] forState:UIControlStateSelected];
    
    [_midBorder setImage:[UIImage imageNamed:@"border_mid"] forState:UIControlStateNormal];
    [_midBorder setImage:[UIImage imageNamed:@"border_mid_p"] forState:UIControlStateSelected];
    
    [_boldBorder setImage:[UIImage imageNamed:@"border_bold"] forState:UIControlStateNormal];
    [_boldBorder setImage:[UIImage imageNamed:@"border_bold_p"] forState:UIControlStateSelected];

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
    if (_showImageCollectionView.zoomScale > 1.0) {
        _showImageCollectionView.contentInset = UIEdgeInsetsZero;
        [_showImageCollectionView setZoomScale:1.0 animated:YES];
        
    } else {
        CGPoint touchPoint = [tap locationInView:self.containImageView];
        CGFloat newZoomScale = _showImageCollectionView.maximumZoomScale;
        CGFloat xsize = self.view.frame.size.width / newZoomScale;
        CGFloat ysize = self.view.frame.size.height / newZoomScale;
        [_showImageCollectionView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    //    if (self.singleTapGestureBlock) {
    //        self.singleTapGestureBlock();
    //    }
}

#pragma mark - Button Action

- (IBAction)onMoveBtnTap:(id)sender {
    UIButton *moveBtn = (UIButton*)sender;
    moveBtn.selected = !moveBtn.selected;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.moveCollectionViewLayout;
    
    if (moveBtn.selected == YES) {
        self.view.backgroundColor = UIColor.grayColor;
        self.isEdittMove = YES;
        flowLayout.minimumLineSpacing = 10;
        //[self.showImageCollectionView reloadData];
        
    } else {
        self.isEdittMove = NO;
        flowLayout.minimumLineSpacing = 0;
        //[self.showImageCollectionView reloadData];
        
    }
}

- (IBAction)onBorderBtnTap:(id)sender {
    _borderSelectView.hidden = NO;
    UIButton *borderBtn = (UIButton*)sender;
    borderBtn.selected = !borderBtn.selected;
    if (_canTap&&borderBtn.selected == YES) {
        self.canTap = NO;
        self.view.backgroundColor = UIColor.borderBgColor;
        self.curBorderColor = UIColor.blackColor;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.borderViewBottom.constant = -self.borderSelectView.hx_h;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.canTap = YES;
            self.noBoder.selected = YES;
            //[self.showImageCollectionView reloadData];
        }];
    } else if(_canTap&&borderBtn.selected == NO) {
        self.canTap = NO;
        [self setEditBorderState:NO width:0 color:nil];
        self.view.backgroundColor = UIColor.backgroundColor;
        [UIView animateWithDuration:0.5 animations:^{
            self.borderViewBottom.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.canTap = YES;
            [self.showImageCollectionView reloadData];
        }];
    }
}


- (IBAction)onBackBtnTap:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    __weak typeof(self) weakSelf = self;

    [weakSelf dismissViewControllerAnimated:NO completion:nil];

    
}
- (IBAction)onNextBtnTap:(id)sender {
    __weak typeof(self) weakSelf = self;
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    __block NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.resultModels.count; i++) {
        PhotoCutModel *model = self.resultModels[i];
        if (i == 0) {
            model.originPhoto = [model.originPhoto addBorderForImage:_curBorderWidth borderColor:_curBorderColor beginY:_curBorderWidth bottomY:_curBorderWidth*0.5];
        } else if(i == self.resultModels.count - 1) {
            model.originPhoto = [model.originPhoto addBorderForImage:_curBorderWidth borderColor:_curBorderColor beginY:_curBorderWidth*0.5 bottomY:_curBorderWidth];
        } else {
            model.originPhoto = [model.originPhoto addBorderForImage:_curBorderWidth borderColor:_curBorderColor beginY:_curBorderWidth*0.5 bottomY:_curBorderWidth*0.5];
        }
        if (i == self.resultModels.count - 1) {
            model.isEND = YES;
        } else {
            model.isEND = NO;
        }
        [self.resultModels replaceObjectAtIndex:i withObject:model];
        [tempArray addObject:model.originPhoto];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.manager combineScrollPhotos:tempArray resultImage:^(UIImage *combineImage) {
            weakSelf.resultImage = combineImage;
            [weakSelf showShareBoard];
        } completeIndex:^(NSInteger index) {
            
        }];
    });
    
    
    
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.manager combinePhotosWithDirection:weakSelf.manager.isCombineVertical resultImage:^(UIImage *combineImage) {
//            if (combineImage == nil)
//            {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"资源受限，拼图失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *open = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf.toolBarView setSaveBtnsHiddenValue:NO];
//                    [weakSelf.toolBarView setSaveLabelHidden:YES];
//                    //                        [weakSelf.view showImageHUDText:LocalString(@"save_success")];
//                    //[button setTitle:LocalString(@"save_failed") forState:UIControlStateNormal];
//                }];
//                [alert addAction:open];
//                [self.navigationController presen tViewController:alert animated:YES completion:nil];
//            }
//
//            weakSelf.resultImage = combineImage;
////            if(weakSelf.isFromShare) {
////                weakSelf.isFromShare = NO;
////                [weakSelf.toolBarView setSaveBtnsHiddenValue:NO];
////                [weakSelf.toolBarView setSaveLabelHidden:YES];
////                [weakSelf savePhotoBottomViewDidShareBtn];
//            } else {
//
//                NSLog(@"11111");
//
//                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                    [PHAssetChangeRequest creationRequestForAssetFromImage:combineImage];
//                } completionHandler:^(BOOL success, NSError * _Nullable error) {
//                    NSLog(@"success = %d, error = %@", success, error);
//
//                    if (success) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [weakSelf.toolBarView setSaveBtnsHiddenValue:NO];
//                            [weakSelf.toolBarView setSaveLabelHidden:YES];
//                            [weakSelf.view showImageHUDText:LocalString(@"save_success")];
//                            //[button setTitle:LocalString(@"open_ablum") forState:UIControlStateNormal];
//                        });
//
//                    } else {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [weakSelf.view handleLoading];
//                            //[weakSelf.view showImageHUDText:LocalString(@"save_failed")];
//                            [button setTitle:LocalString(@"save_failed") forState:UIControlStateNormal];
//                        });
//
//                    }
//                }];
//            }
//        } completeIndex:^(NSInteger index) {
//            //                dispatch_async(dispatch_get_main_queue(), ^{
//            //[weakSelf.toolBarView setProgressViewValue:index];
//            //                });
//        }];
//    });
}

#pragma mark boder selectAction

- (void)runCurveView:(UIButton*)colorDot angle:(double)angle {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        colorDot.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)noBorderTapped:(UIButton *)sender {
    sender.selected = YES;
    self.thinBorder.selected = NO;
    self.midBorder.selected = NO;
    self.boldBorder.selected = NO;
    self.curBorderWidth = 0;
    [self setEditBorderState:YES width:0 color:self.curBorderColor];
    [self.showImageCollectionView reloadData];
}


- (IBAction)thinBorderTapped:(UIButton *)sender {
    sender.selected = YES;
    self.noBoder.selected = NO;
    self.midBorder.selected = NO;
    self.boldBorder.selected = NO;
    self.curBorderWidth = 5;
    [self setEditBorderState:YES width:5 color:self.curBorderColor];
    [self.showImageCollectionView reloadData];
}

- (IBAction)midBorderTapped:(UIButton *)sender {
    sender.selected = YES;
    self.noBoder.selected = NO;
    self.thinBorder.selected = NO;
    self.boldBorder.selected = NO;
    self.curBorderWidth = 10;
    [self setEditBorderState:YES width:10 color:self.curBorderColor];
    [self.showImageCollectionView reloadData];
}

- (IBAction)boldBorderTapped:(UIButton *)sender {
    sender.selected = YES;
    self.noBoder.selected = NO;
    self.midBorder.selected = NO;
    self.thinBorder.selected = NO;
    self.curBorderWidth = 18;
    [self setEditBorderState:YES width:18 color:self.curBorderColor];
    [self.showImageCollectionView reloadData];
}

- (IBAction)borderColorTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
 
    CGPoint startPoint = [self.borderSelectView.layer convertPoint:self.colorButton.center toLayer:self.view.layer];
    CGPoint gEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realGoldButton.center toLayer:self.view.layer];
    CGPoint gControlPointInSuperView = CGPointMake(gEndPointInSuperView.x + 4*ScreenWidthRatio,  gEndPointInSuperView.y + 40*ScreenHeightRatio);
    CGPoint gEndPoint = [self.view.layer convertPoint:gEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint gControlPoint = [self.view.layer convertPoint:gControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint bEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realBlackButton.center toLayer:self.view.layer];
    CGPoint bControlPointInSuperView = CGPointMake(startPoint.x + 3*ScreenWidthRatio,  startPoint.y + 28*ScreenHeightRatio);
    CGPoint bEndPoint = [self.view.layer convertPoint:bEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint bControlPoint = [self.view.layer convertPoint:bControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint wEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realWhiteButton.center toLayer:self.view.layer];
    CGPoint wControlPointInSuperView = CGPointMake(startPoint.x + 1.5*ScreenWidthRatio,  startPoint.y + 18*ScreenHeightRatio);
    CGPoint wEndPoint = [self.view.layer convertPoint:wEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint wControlPoint = [self.view.layer convertPoint:wControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    if (sender.selected == YES) {
        [self.goldButton setCurveAnimation:self startPoint:self.colorButton.center controlPoint:gControlPoint endPoint:gEndPoint duration:0.2];
        [self.blackButton setCurveAnimation:self startPoint:self.colorButton.center controlPoint:bControlPoint endPoint:bEndPoint duration:0.25];
        [self.whiteButton setCurveAnimation:self startPoint:self.colorButton.center controlPoint:wControlPoint endPoint:wEndPoint duration:0.3];
        //dispatch_after(0.8, dispatch_get_main_queue(), ^{
        
        [self performSelector:@selector(delayMethods) withObject:nil afterDelay:0.5];
        //});
    } else {
        self.borderBtnContainView.hidden = YES;
        [self.goldButton setCurveAnimation:self startPoint:gEndPoint controlPoint:gControlPoint endPoint:self.colorButton.center duration:0.3];
        [self.blackButton setCurveAnimation:self startPoint:bEndPoint controlPoint:bControlPoint endPoint:self.colorButton.center duration:0.25];
        [self.whiteButton setCurveAnimation:self startPoint:wEndPoint controlPoint:wControlPoint endPoint:self.colorButton.center duration:0.2];
        

    }

}

- (void)delayMethods {
    self.borderBtnContainView.hidden = NO;
}

- (IBAction)selectGoldBorder:(UIButton *)sender {
    CGPoint startPoint = [self.borderSelectView.layer convertPoint:self.colorButton.center toLayer:self.view.layer];
    CGPoint gEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realGoldButton.center toLayer:self.view.layer];
    CGPoint gControlPointInSuperView = CGPointMake(gEndPointInSuperView.x + 4*ScreenWidthRatio,  gEndPointInSuperView.y + 40*ScreenHeightRatio);
    CGPoint gEndPoint = [self.view.layer convertPoint:gEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint gControlPoint = [self.view.layer convertPoint:gControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint bEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realBlackButton.center toLayer:self.view.layer];
    CGPoint bControlPointInSuperView = CGPointMake(startPoint.x + 3*ScreenWidthRatio,  startPoint.y + 28*ScreenHeightRatio);
    CGPoint bEndPoint = [self.view.layer convertPoint:bEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint bControlPoint = [self.view.layer convertPoint:bControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint wEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realWhiteButton.center toLayer:self.view.layer];
    CGPoint wControlPointInSuperView = CGPointMake(startPoint.x + 1.5*ScreenWidthRatio,  startPoint.y + 18*ScreenHeightRatio);
    CGPoint wEndPoint = [self.view.layer convertPoint:wEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint wControlPoint = [self.view.layer convertPoint:wControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    self.borderBtnContainView.hidden = YES;
    self.curBorderColor = UIColor.whiteColor;
    [self setEditBorderState:YES width:self.curBorderWidth color:UIColor.goldColor];
    [self.colorButton setImage:[UIImage imageNamed:@"border_color_gold" ] forState:UIControlStateNormal];
    self.colorButton.selected = NO;
    [self.goldButton setCurveAnimation:self startPoint:gEndPoint controlPoint:gControlPoint endPoint:self.colorButton.center duration:0.3];
    [self.blackButton setCurveAnimation:self startPoint:bEndPoint controlPoint:bControlPoint endPoint:self.colorButton.center duration:0.25];
    [self.whiteButton setCurveAnimation:self startPoint:wEndPoint controlPoint:wControlPoint endPoint:self.colorButton.center duration:0.2];
    [self.showImageCollectionView reloadData];
}
- (IBAction)selectBlackBorder:(UIButton *)sender {
    CGPoint startPoint = [self.borderSelectView.layer convertPoint:self.colorButton.center toLayer:self.view.layer];
    CGPoint gEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realGoldButton.center toLayer:self.view.layer];
    CGPoint gControlPointInSuperView = CGPointMake(gEndPointInSuperView.x + 4*ScreenWidthRatio,  gEndPointInSuperView.y + 40*ScreenHeightRatio);
    CGPoint gEndPoint = [self.view.layer convertPoint:gEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint gControlPoint = [self.view.layer convertPoint:gControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint bEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realBlackButton.center toLayer:self.view.layer];
    CGPoint bControlPointInSuperView = CGPointMake(startPoint.x + 3*ScreenWidthRatio,  startPoint.y + 28*ScreenHeightRatio);
    CGPoint bEndPoint = [self.view.layer convertPoint:bEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint bControlPoint = [self.view.layer convertPoint:bControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint wEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realWhiteButton.center toLayer:self.view.layer];
    CGPoint wControlPointInSuperView = CGPointMake(startPoint.x + 1.5*ScreenWidthRatio,  startPoint.y + 18*ScreenHeightRatio);
    CGPoint wEndPoint = [self.view.layer convertPoint:wEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint wControlPoint = [self.view.layer convertPoint:wControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    self.borderBtnContainView.hidden = YES;
    self.curBorderColor = UIColor.blackColor;
    [self setEditBorderState:YES width:self.curBorderWidth color:UIColor.blackColor];
    [self.colorButton setImage:[UIImage imageNamed:@"border_color_black" ] forState:UIControlStateNormal];
    self.colorButton.selected = NO;
    [self.goldButton setCurveAnimation:self startPoint:gEndPoint controlPoint:gControlPoint endPoint:self.colorButton.center duration:0.3];
    [self.blackButton setCurveAnimation:self startPoint:bEndPoint controlPoint:bControlPoint endPoint:self.colorButton.center duration:0.25];
    [self.whiteButton setCurveAnimation:self startPoint:wEndPoint controlPoint:wControlPoint endPoint:self.colorButton.center duration:0.2];
    [self.showImageCollectionView reloadData];
}
- (IBAction)selectWhiteBorder:(UIButton *)sender {
    CGPoint startPoint = [self.borderSelectView.layer convertPoint:self.colorButton.center toLayer:self.view.layer];
    CGPoint gEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realGoldButton.center toLayer:self.view.layer];
    CGPoint gControlPointInSuperView = CGPointMake(gEndPointInSuperView.x + 4*ScreenWidthRatio,  gEndPointInSuperView.y + 40*ScreenHeightRatio);
    CGPoint gEndPoint = [self.view.layer convertPoint:gEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint gControlPoint = [self.view.layer convertPoint:gControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint bEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realBlackButton.center toLayer:self.view.layer];
    CGPoint bControlPointInSuperView = CGPointMake(startPoint.x + 3*ScreenWidthRatio,  startPoint.y + 28*ScreenHeightRatio);
    CGPoint bEndPoint = [self.view.layer convertPoint:bEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint bControlPoint = [self.view.layer convertPoint:bControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    CGPoint wEndPointInSuperView = [self.borderBtnContainView.layer convertPoint:self.realWhiteButton.center toLayer:self.view.layer];
    CGPoint wControlPointInSuperView = CGPointMake(startPoint.x + 1.5*ScreenWidthRatio,  startPoint.y + 18*ScreenHeightRatio);
    CGPoint wEndPoint = [self.view.layer convertPoint:wEndPointInSuperView toLayer:self.borderSelectView.layer];
    CGPoint wControlPoint = [self.view.layer convertPoint:wControlPointInSuperView toLayer:self.borderSelectView.layer];
    
    self.borderBtnContainView.hidden = YES;
    self.curBorderColor = UIColor.whiteColor;
    [self setEditBorderState:YES width:self.curBorderWidth color:UIColor.whiteColor];
    [self.colorButton setImage:[UIImage imageNamed:@"border_color_white" ] forState:UIControlStateNormal];
    self.colorButton.selected = NO;
    [self.goldButton setCurveAnimation:self startPoint:gEndPoint controlPoint:gControlPoint endPoint:self.colorButton.center duration:0.3];
    [self.blackButton setCurveAnimation:self startPoint:bEndPoint controlPoint:bControlPoint endPoint:self.colorButton.center duration:0.25];
    [self.whiteButton setCurveAnimation:self startPoint:wEndPoint controlPoint:wControlPoint endPoint:self.colorButton.center duration:0.2];
    [self.showImageCollectionView reloadData];
}



- (ShareBoardView *)shareBoardView {
    if (!_shareBoardView) {
        _shareBoardView = [[ShareBoardView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - SaveViewHeight - kBottomMargin, self.view.hx_w, ShareBoardHeight)];
        _shareBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _shareBoardView.shareDelegate = self;
        _shareBoardView.hidden = YES;
    }
    return _shareBoardView;
}


- (void)showShareBoard {
    
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY - ShareBoardHeight+1, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         //_isShowShareBoardView = YES;
                         
                     }];
}

- (void)hideShareBoard {
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY + ShareBoardHeight-1, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         [_shareBoardView setHidden:YES];
                         //_isShowShareBoardView = NO;
                     }];
}

- (NSArray *)setEditBorderState:(BOOL)isBorder width:(CGFloat)width color:(UIColor*)color {
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:self.resultModels];
    for (int i = 0; i < self.resultModels.count; i++) {
        PhotoCutModel *model = tempArray[i];
        model.editBorder = isBorder;
        model.borderWidth = width;
        model.borderColor = color;
        if (i == tempArray.count - 1) {
            model.isEND = YES;
        } else {
            model.isEND = NO;
        }
        [self.resultModels replaceObjectAtIndex:i withObject:model];
    }
    return self.resultModels;
}

- (void)shareBoardViewDidWeChatBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatSession];
    _shareType = UMSocialPlatformType_WechatSession;
}

- (void)shareBoardViewDidMomentBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    _shareType = UMSocialPlatformType_WechatTimeLine;
}

- (void)shareBoardViewDidWeiboBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_Sina];
    _shareType = UMSocialPlatformType_Sina;
}

- (void)shareBoardViewDidMoreBtn {
    NSLog(@"shareMoreImageOnClick");
    _shareType = 100;
    if(_resultImage == nil) {
//        _isFromShare = YES;
//        [self savePhotoBottomViewDidSaveBtn:nil];
        
    } else {
        
        NSArray *activityItems = @[_resultImage];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        //不出现在活动项目
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
        [self presentViewController:activityVC animated:YES completion:nil];
        // 分享之后的回调
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                NSLog(@"completed");
                //分享 成功
            } else  {
                NSLog(@"cancled");
                //分享 取消
            }
        };
    }
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    if(_resultImage == nil) {
//        _isFromShare = YES;
//        [self savePhotoBottomViewDidSaveBtn:nil];
        
    } else {
        NSLog(@"11111");
        NSURL *url;
        switch (platformType) {
            case UMSocialPlatformType_Sina://新浪  判断手机是否安装新浪
                url = [NSURL URLWithString:@"sinaweibo://"];
                if (![[UIApplication sharedApplication] canOpenURL:url])
                {
                    //[self showAlertView:@"请先安装微博"];
                    return;
                }
                break;
            case UMSocialPlatformType_WechatSession://微信聊天 判断手机是否安装微信
            case UMSocialPlatformType_WechatTimeLine://微信朋友圈
                url = [NSURL URLWithString:@"weixin://"];
                if (![[UIApplication sharedApplication] canOpenURL:url])
                {
                    //[self showAlertView:@"请先安装微信"];
                    return;
                }
                break;
            default:
                break;
        }
        
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"icon"];
        UIImage *saveImage = _resultImage;
        
        [shareObject setShareImage:saveImage];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                if ([error.localizedDescription containsString:@"2008"]) {
                    //[self showShareError:platformType];
                }
            }else{
                NSLog(@"response data is %@",data);
                //[self shareReturnByCode:0];
            }
        }];
    }
}


#pragma mark ModifyCellDelegate
- (void)onUpDragItemTap:(NSInteger)index {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.moveCollectionViewLayout;
    //flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    
    
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
        model.canMoveHeight = cutModel.endY - cutModel.beginY;
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
            model.canMoveHeight = cutModel.endY - cutModel.beginY;
            model.itemHeight = [self getMoveItemHeight:model.photoArray];
            [_moveItemArray addObject:model];
        }
    }
    
    [self.showImageCollectionView reloadData];
    self.showImageCollectionView.scrollEnabled = false;
    
}

- (void)onDownDragItemTap:(NSInteger)index{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.moveCollectionViewLayout;
    //flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    
    
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
        model.itemFrameHeight = _showImageCollectionView.hx_h;
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
    self.showImageCollectionView.scrollEnabled = false;
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint preTouchPoint = [[touches anyObject] previousLocationInView:self.view];
    CGPoint curTouchPoint = [[touches anyObject] locationInView:self.view];
    CGFloat touchOffset = curTouchPoint.y - preTouchPoint.y;
 
    //CGRectS(self.originX, self.originY + touchOffset, self.hx_w, self.hx_h+touchOffset);
}


#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_showImageCollectionView.hx_w > _showImageCollectionView.contentSize.width) ? ((_showImageCollectionView.hx_w - _showImageCollectionView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_showImageCollectionView.hx_h > _showImageCollectionView.contentSize.height) ? ((_showImageCollectionView.hx_h - _showImageCollectionView.contentSize.height) * 0.5) : 0.0;
    self.containImageView.center = CGPointMake(_showImageCollectionView.contentSize.width * 0.5 + offsetX, _showImageCollectionView.contentSize.height * 0.5 + offsetY);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MoveCellDelegate

- (void)updateMoveOffset:(MoveInfoModel *)model moveOffset:(CGFloat)offset {
//    model.itemFrameHeight += offset;
//    [self.moveItemArray replaceObjectAtIndex:model.index withObject:model];
//    _isEdittMove = YES;
//    [self.showImageCollectionView reloadData];
    MoveItemCell *cell;
    if (model.index == 0) {
        
        if (model.isMoveDown) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:model.index + 1 inSection:0];
            cell = (MoveItemCell *)[self.showImageCollectionView cellForItemAtIndexPath:indexPath];
            cell.frame = CGRectMake(cell.originX, cell.originY + offset, cell.hx_w, cell.hx_h - offset);
            [cell setDragItemHidden:YES];
        } else {
            
        }
    } else {
        if (model.isMoveDown) {
            
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:model.index - 1 inSection:0];
            cell = (MoveItemCell *)[self.showImageCollectionView cellForItemAtIndexPath:indexPath];
            if ([cell getContentOffset] > 0) {
                cell.frame = CGRectMake(cell.originX, cell.originY, cell.hx_w, cell.hx_h + offset);
                [cell setContentOffset:-offset];
            } else {
                cell.frame = CGRectMake(cell.originX, cell.originY + offset, cell.hx_w, cell.hx_h);
            }
            
                
        
            
            
            [cell setDragItemHidden:YES];
        }
        
    }
    
}

- (void)updateCellState:(MoveInfoModel *)model {
    MoveItemCell *cell;
    if (model.index == 0) {
        
        if (model.isMoveDown) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:model.index + 1 inSection:0];
            cell = (MoveItemCell *)[self.showImageCollectionView cellForItemAtIndexPath:indexPath];

            [cell setDragItemHidden:NO];
        } else {
            
        }
    } else {
        if (model.isMoveDown) {
            
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:model.index - 1 inSection:0];
            cell = (MoveItemCell *)[self.showImageCollectionView cellForItemAtIndexPath:indexPath];
            [cell setDragItemHidden:NO];
        }
        
    }
}

- (void)beginMoveCellAt:(nonnull MoveInfoModel *)model moveDistance:(CGFloat)distance {
    
}


- (void)endMoveCellAt:(nonnull MoveInfoModel *)model moveDistance:(CGFloat)distance {
    
}


#pragma mark - UICollectionViewDelegateFlowLayout


#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (_isEdittMove) {
        MoveItemCell *cell = [self.showImageCollectionView dequeueReusableCellWithReuseIdentifier:@"moveCollectionCell" forIndexPath:indexPath];
        MoveInfoModel *model = [_moveItemArray objectAtIndex:indexPath.row];
        [cell configCell:model];

        cell.moveOffsetBlock = ^(CGFloat offset) {

        };
        return cell;
    } else {
        ModifyCollectionViewCell *cell = [self.showImageCollectionView dequeueReusableCellWithReuseIdentifier:@"modifyCollectionCell" forIndexPath:indexPath];
        PhotoCutModel *model = [self.resultModels objectAtIndex:indexPath.row];
        
        [cell configCell:model isEditMove:self.isEdittMove isEditBorder:model.editBorder width:model.borderWidth color:model.borderColor];
        return cell;
    }
    
    
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (_isEdittMove) {
//        return _movePartCount;
//    } else {
        return self.resultModels.count;
//    }
    
}

//设置每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
//    if (_isEdittMove) {
//        MoveInfoModel *model = [self.moveItemArray objectAtIndex:indexPath.row];
//
//        size = CGSizeMake(collectionView.hx_w,model.itemFrameHeight);
//
//    } else {
        PhotoCutModel *model = [self.resultModels objectAtIndex:indexPath.row];
        CGFloat imageCutHeight = (model.endY - model.beginY);
        CGFloat ratio = (collectionView.hx_w - 2*model.borderWidth)/model.originPhoto.size.width;
        CGFloat cellHeight = imageCutHeight*ratio + model.borderWidth;
        if (indexPath.item == 0 || indexPath.item == self.resultModels.count - 1) {
            cellHeight += 0.5*model.borderWidth;
        }
        size = CGSizeMake(collectionView.hx_w,cellHeight);
//    }
    
    
    return size;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//
//    return CGSizeZero;
//}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
//}
////这个是两行cell之间的间距（上下行cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    if (_isEdittMove) {
//        return 0;
//    } else {
//        return 10;
//    }
//
//}
////两个cell之间的间距（同一行的cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}





@end
