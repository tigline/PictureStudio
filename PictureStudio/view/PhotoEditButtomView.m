//
//  PhotoEditButtomView.m
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "PhotoEditButtomView.h"


@interface PhotoEditButtomView ()
@property (strong, nonatomic) UIButton *combineBtn;
@property (strong, nonatomic) UIButton *scrollBtn;
@property (strong, nonatomic) UIButton *editBtn;
@property (strong, nonatomic) UIButton *combineBtnH;
@property (strong, nonatomic) UIButton *clearBtn;
@property (strong, nonatomic) UILabel  *selectLabel;
@property (strong, nonatomic) CALayer* segmentingLineFrist;
@property (strong, nonatomic) CALayer* segmentingLineSecond;
@property (strong, nonatomic) CALayer* segmentingLineThird;
@property (strong, nonatomic) CALayer* segmentingLineFourth;
@end

@implementation PhotoEditButtomView
#define btnHeight 34*ScreenHeightRatio
#define btnWidth 72*ScreenWidthRatio

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{

    
    
}
- (void)setupUI {
    [self setBackgroundColor:UIColor.barColor];
    self.clipsToBounds = YES;
    //[self addSubview:self.selectLabel];
    [self addSubview:self.clearBtn];
    [self addSubview:self.combineBtn];
    [self addSubview:self.scrollBtn];
    [self addSubview:self.editBtn];
    self.layer.shadowOpacity = 0.99;
    self.layer.shadowColor = UIColor.navShadowColor.CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.masksToBounds = NO;
    
}
- (void)setManager:(HXPhotoManager *)manager {
    _manager = manager;
    
    UIColor *themeColor = [UIColor colorWithRed:84/255.0 green:130/255.0 blue:1 alpha:1];
    [self.combineBtn setTitleColor:themeColor forState:UIControlStateNormal];
    [self.combineBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.scrollBtn setTitleColor:themeColor forState:UIControlStateNormal];
    [self.scrollBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.editBtn setTitleColor:themeColor forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

    //[self.clearBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.clearBtn setTintColor:[UIColor grayColor]];

}
- (void)setSelectCount:(NSInteger)selectCount {
    _selectCount = selectCount;

    if (selectCount > 0) {
        self.clearBtn.enabled = YES;
    } else {
        self.clearBtn.enabled = NO;
    }
    
    if(selectCount > 1) {
        if (_manager.isAllScreenShotPhoto) {
            self.combineBtn.enabled = YES;
            self.scrollBtn.enabled = YES;
            self.editBtn.enabled = NO;
        } else {
            self.combineBtn.enabled = YES;
            self.scrollBtn.enabled = NO;
            self.editBtn.enabled = NO;
        }
        
    } else if (selectCount == 1) {
        self.combineBtn.enabled = NO;
        self.scrollBtn.enabled = NO;
        self.editBtn.enabled = YES;
    } else {
        self.combineBtn.enabled = NO;
        self.scrollBtn.enabled = NO;
        self.editBtn.enabled = NO;
    }
}



- (void)didCombineClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidCombineBtn)]) {
        [self.delegate datePhotoBottomViewDidCombineBtn];
    }
}
- (void)didEditClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidEditBtn)]) {
        [self.delegate datePhotoBottomViewDidEditBtn];
    }
}
- (void)didScrollClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidEditBtn)]) {
        [self.delegate datePhotoBottomViewDidScrollBtn];
    }
}
- (void)didClearClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidClearBtn)]) {
        [self.delegate datePhotoBottomViewDidClearBtn];
    }
}

- (void)didcombineBtnHClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidcombineBtnH)]) {
        [self.delegate datePhotoBottomViewDidcombineBtnH];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_selectCount > 0) {
        return;
    }
    
    CGFloat pointY = (self.hx_h - btnHeight)/2;

    self.clearBtn.frame = CGRectMake(22*ScreenWidthRatio, (self.hx_h - 22*ScreenWidthRatio)/2, 22*ScreenWidthRatio, 22*ScreenWidthRatio);
    
    self.combineBtn.frame = CGRectMake(self.clearBtn.rightBottom.x + 42*ScreenWidthRatio, pointY, btnWidth, btnHeight);
    
    self.scrollBtn.frame = CGRectMake(self.combineBtn.rightBottom.x + 20*ScreenWidthRatio, pointY, btnWidth, btnHeight);

    self.editBtn.frame = CGRectMake(self.scrollBtn.rightBottom.x + 20*ScreenWidthRatio, pointY, btnWidth, btnHeight);


}
//- (UIToolbar *)bgView {
//    if (!_bgView) {
//        _bgView = [[UIToolbar alloc] init];
//
//    }
//    return _bgView;
//}

- (UILabel *)selectLabel {
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc]init];
        _selectLabel.text = LocalString(@"operate_tips");
        _selectLabel.textAlignment = NSTextAlignmentCenter;
        _selectLabel.textColor = [UIColor lightGrayColor];
        _selectLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _selectLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_clearBtn setImage:[UIImage imageNamed:@"cancel_blue_p"] forState:UIControlStateNormal];
        [_clearBtn setImage:[UIImage imageNamed:@"cancel_blue_p"] forState:UIControlStateSelected];
        [_clearBtn setImage:[UIImage imageNamed:@"tool_unselect"] forState:UIControlStateDisabled];
        _clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_clearBtn addTarget:self action:@selector(didClearClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.enabled = NO;
    }
    return _clearBtn;
}

- (UIButton *)combineBtn {
    if (!_combineBtn) {
        _combineBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_combineBtn setImage:[UIImage imageNamed:@"tool_combine_p"] forState:UIControlStateNormal];
        [_combineBtn setImage:[UIImage imageNamed:@"tool_combine_l"] forState:UIControlStateHighlighted];
        [_combineBtn setImage:[UIImage imageNamed:@"tool_combine_u"] forState:UIControlStateDisabled];
        _combineBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        _combineBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10*ScreenWidthRatio, 0, 0);
//        _combineBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10*ScreenWidthRatio, 0, 0);
        _combineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_combineBtn addTarget:self action:@selector(didCombineClick) forControlEvents:UIControlEventTouchUpInside];
        _combineBtn.enabled = NO;
        
    }
    return _combineBtn;
}

- (UIButton *)scrollBtn {
    if (!_scrollBtn) {
        _scrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollBtn setImage:[UIImage imageNamed:@"tool_scroll_p"] forState:UIControlStateNormal];
        [_scrollBtn setImage:[UIImage imageNamed:@"tool_scroll_l"] forState:UIControlStateHighlighted];
        [_scrollBtn setImage:[UIImage imageNamed:@"tool_scroll_u"] forState:UIControlStateDisabled];
        _scrollBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_scrollBtn addTarget:self action:@selector(didScrollClick) forControlEvents:UIControlEventTouchUpInside];
        _scrollBtn.enabled = NO;

    }
    return _scrollBtn;
}
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_editBtn setTintColor:[UIColor clearColor]];
        [_editBtn setImage:[UIImage imageNamed:@"tool_edit_p"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"tool_edit_l"] forState:UIControlStateHighlighted];
        [_editBtn setImage:[UIImage imageNamed:@"tool_edit_u"] forState:UIControlStateDisabled];
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_editBtn addTarget:self action:@selector(didEditClick) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.enabled = NO;
    }
    return _editBtn;
}
- (UIButton *)combineBtnH {
    if (!_combineBtnH) {
        _combineBtnH = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_editBtn setTintColor:[UIColor clearColor]];
        [_combineBtnH setImage:[UIImage imageNamed:@"tab_combine_active"] forState:UIControlStateNormal];
        [_combineBtnH setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        _combineBtnH.titleLabel.font = [UIFont systemFontOfSize:12];

        _combineBtnH.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_combineBtnH addTarget:self action:@selector(didcombineBtnHClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _combineBtnH;
}

@end
