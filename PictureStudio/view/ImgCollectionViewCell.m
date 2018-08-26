//
//  ImgTableViewCell.m
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "ImgCollectionViewCell.h"
#import "HXPhotoTools.h"
#import "UIButton+Extension.h"

@interface ImgCollectionViewCell ()<ImgCollectionViewCellDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *maskView;
@property (copy, nonatomic) NSString *localIdentifier;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (strong, nonatomic) UILabel *stateLb;
@property (strong, nonatomic) CAGradientLayer *bottomMaskLayer;

@end

@implementation ImgCollectionViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //self.layer.borderWidth = 1*ScreenWidthRatio;
    //self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    //    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;;
    //    self.layer.shadowOpacity = 0.8f;
    //    self.layer.shadowOffset = CGSizeMake(0, 0);
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.maskView];
    //self.selectBgColor = [UIColor colorWithRed:102/255.0 green:153/255.0 blue:1.0 alpha:1.0];
    
}
- (void)bottomViewPrepareAnimation {
    self.maskView.alpha = 0;
}
- (void)bottomViewStartAnimation {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.maskView.alpha = 1;
    } completion:nil];
}
//- (void)setSingleSelected:(BOOL)singleSelected {
//    _singleSelected = singleSelected;
//    if (singleSelected) {
//        [self.selectBtn removeFromSuperview];
//    }
//}

- (void)setMatchY:(BOOL)matchY
{
    if (matchY) {
        //        self.selectMaskLayer.hidden = !_model.selected;
        //        self.selectBtn.selected = _model.selected;
        //        [self.selectBtn setTitle:_model.selectIndexStr forState:UIControlStateSelected];
        //self.selectBtn.selected = NO;
        [self.collectionViewCelldelegate imgCollectionViewCell:self didSelectBtn:self.selectBtn];
    } else {
        //self.selectBtn.selected = YES;
        [self.collectionViewCelldelegate imgCollectionViewCell:self didSelectBtn:self.selectBtn];
        
        //[self.collectionViewCelldelegate imgCollectionViewCell:self didSelectBtn:self.selectBtn];
        //        _model.selectIndexStr = @"";
        //        _selectMaskLayer.hidden = YES;
        //        _selectBtn.selected = NO;
        //self.selectCount = [self.manager selectedCount];
        
    }
}



- (void)setModel:(HXPhotoModel *)model {
    _model = model;
    
    __weak typeof(self) weakSelf = self;
    if ( model.type == HXPhotoModelMediaTypeCameraPhoto) {
        
        self.imageView.image = model.thumbPhoto;
        
    }else {
        self.imageView.image = nil;
        PHImageRequestID requestID = [HXPhotoTools getImageWithModel:model completion:^(UIImage *image, HXPhotoModel *model) {
            if (weakSelf.model == model) {
                weakSelf.imageView.image = image;
            }
        }];
        self.requestID = requestID;
    }
    self.selectMaskLayer.hidden = !model.selected;
    self.selectBtn.selected = model.selected;
    
    [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
    //self.selectBtn.backgroundColor = model.selected ? self.selectBgColor :nil;
    
}

- (void)setSelectBgColor:(UIColor *)selectBgColor {
    _selectBgColor = selectBgColor;
    if ([selectBgColor isEqual:[UIColor whiteColor]] && !self.selectedTitleColor) {
        [self.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    [self.selectBtn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (void)didSelectClick:(UIButton *)button {
    if ([self.collectionViewCelldelegate respondsToSelector:@selector(imgCollectionViewCell:didSelectBtn:)]) {
        [self.collectionViewCelldelegate imgCollectionViewCell:self didSelectBtn:button];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    [CATransaction begin];
    //    [CATransaction setDisableActions:YES];
    self.imageView.frame = self.bounds;
    self.maskView.frame = self.bounds;
    //self.stateLb.frame = CGRectMake(0, self.hx_h - 18, self.hx_w - 4, 18);
    //self.bottomMaskLayer.frame = CGRectMake(0, self.hx_h - 25, self.hx_w, 25);
    self.selectBtn.frame = CGRectMake(self.hx_w - 28, self.hx_w - 28, 25, 25);
    self.selectMaskLayer.frame = self.bounds;
    //    [CATransaction commit];
    

        

        

}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (touchPoint.x > self.hx_w/3 && touchPoint.y > self.hx_h/3) {
        [self didSelectClick:_selectBtn];
    } else {
        [self.superview touchesEnded:touches withEvent:event];
    }
    
}

- (void)dealloc {
    self.model.dateCellIsVisible = NO;
}
#pragma mark - < 懒加载 >



- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        //_imageView.alpha = 1.0f;
    }
    return _imageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        //[_maskView.layer addSublayer:self.bottomMaskLayer];
        [_maskView.layer addSublayer:self.selectMaskLayer];
        //[_maskView addSubview:self.stateLb];
        [_maskView addSubview:self.selectBtn];
    }
    return _maskView;
}

- (CALayer *)selectMaskLayer {
    if (!_selectMaskLayer) {
        _selectMaskLayer = [CALayer layer];
        _selectMaskLayer.hidden = YES;
        _selectMaskLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    }
    return _selectMaskLayer;
}

//- (UILabel *)stateLb {
//    if (!_stateLb) {
//        _stateLb = [[UILabel alloc] init];
//        _stateLb.textColor = [UIColor whiteColor];
//        _stateLb.textAlignment = NSTextAlignmentRight;
//        _stateLb.font = [UIFont systemFontOfSize:12];
//    }
//    return _stateLb;
//}
- (CAGradientLayer *)bottomMaskLayer {
    if (!_bottomMaskLayer) {
        _bottomMaskLayer = [CAGradientLayer layer];
        _bottomMaskLayer.colors = @[
                                    (id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                                    (id)[[UIColor blackColor] colorWithAlphaComponent:0.35].CGColor
                                    ];
        _bottomMaskLayer.startPoint = CGPointMake(0, 0);
        _bottomMaskLayer.endPoint = CGPointMake(0, 1);
        _bottomMaskLayer.locations = @[@(0.15f),@(0.9f)];
        _bottomMaskLayer.borderWidth  = 0.0;
    }
    return _bottomMaskLayer;
}
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"photo_unselect"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"photo_select_bg"] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
        _selectBtn.layer.cornerRadius = 25 / 2;
    }
    return _selectBtn;
}

@end
