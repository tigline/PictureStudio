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
@property (strong, nonatomic) UIButton *clearBtn;
@property (strong, nonatomic) UILabel  *selectLabel;
@property (strong, nonatomic) CALayer* segmentingLineFrist;
@end

@implementation PhotoEditButtomView
#define btnHeight 45

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
    [self setBackgroundColor:[UIColor clearColor]];
    self.clipsToBounds = YES;
    [self addSubview:self.bgView];
    [self addSubview:self.selectLabel];
    [self addSubview:self.clearBtn];
    [self addSubview:self.combineBtn];
    [self addSubview:self.scrollBtn];
//    [self addSubview:self.editBtn];
    
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
        self.clearBtn.hidden = NO;
    } else {
        self.clearBtn.hidden = YES;
    }
    
    if(_manager.isAllScreenShotPhoto && selectCount > 1) {
        //self.clearBtn.hidden = NO;
        self.scrollBtn.hidden = NO;
        self.selectLabel.hidden = YES;
    } else {
        //self.clearBtn.hidden = YES;
        self.scrollBtn.hidden = YES;
        self.selectLabel.hidden = NO;
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


- (void)showClearBtn {

    CGFloat btnWidth = self.bgView.frame.size.width/6;
    CGFloat pointY = 0;//(self.bgView.size.height - btnHeight)/2 - kBottomMargin/2;
    self.clearBtn.hidden = NO;
    
    self.combineBtn.frame = CGRectMake(btnWidth, pointY, btnWidth*5, btnHeight);
    
//    _segmentingLineFrist = [CALayer layer];
//    _segmentingLineFrist.frame = CGRectMake(btnWidth, 14, 0.6, 18);
    _segmentingLineFrist.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    //[self.bgView.layer addSublayer:_segmentingLineFrist];
}
- (void)hideClearBtn {
    
    self.clearBtn.hidden = YES;
    CGFloat btnWidth = self.bgView.frame.size.width/2;
    CGFloat pointY = 0;//(self.bgView.size.height - btnHeight)/2 - kBottomMargin/2;
    self.combineBtn.frame = CGRectMake(btnWidth/2, pointY, btnWidth, btnHeight);
    
//    CALayer* segmentingLineFrist = [CALayer layer];
//    segmentingLineFrist.frame = CGRectMake(btnWidth, 14, 0.6, 18);
    _segmentingLineFrist.backgroundColor = [[UIColor clearColor] CGColor];
//    [self.bgView.layer addSublayer:segmentingLineFrist];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_selectCount > 0) {
        return;
    }
    
    
    self.bgView.frame = self.bounds;
    CGFloat btnWidth = self.bgView.frame.size.width/6;
    CGFloat pointY = 0;//(self.bgView.size.height - btnHeight)/2 - kBottomMargin/2;
    
    
    self.selectLabel.frame = CGRectMake(btnWidth*1.5, pointY, btnWidth*3, btnHeight);
    
    self.clearBtn.frame = CGRectMake(0, pointY, btnWidth, btnHeight);
    self.clearBtn.hidden = YES;
    
    self.scrollBtn.frame = CGRectMake(btnWidth*1.5, pointY, btnWidth*3, btnHeight);
    self.scrollBtn.hidden = YES;
    
    
    

    
    
    /* 完整版本 按钮位置
    CGFloat btnWidth = self.bgView.frame.size.width/3;
    CGFloat pointY = (self.bgView.size.height - btnHeight)/2;
    
    self.combineBtn.frame = CGRectMake(0, pointY, btnWidth, btnHeight);
    self.scrollBtn.frame = CGRectMake(btnWidth, pointY, btnWidth, btnHeight);
    self.editBtn.frame = CGRectMake(btnWidth*2, pointY, btnWidth, btnHeight);
    
    CALayer* segmentingLineFrist = [CALayer layer];
    segmentingLineFrist.frame = CGRectMake(btnWidth, 13, 0.6, 18);
    segmentingLineFrist.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:segmentingLineFrist];
    
    CALayer* segmentingLineSecond = [CALayer layer];
    segmentingLineSecond.frame = CGRectMake(btnWidth*2, 13, 0.6, 18);
    segmentingLineSecond.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:segmentingLineSecond];
    */
    
    
}
- (UIToolbar *)bgView {
    if (!_bgView) {
        _bgView = [[UIToolbar alloc] init];
        
    }
    return _bgView;
}

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
        
        self.bgView.frame = self.bounds;
        [_clearBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_clearBtn.imageView setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
        //_clearBtn.imageView.contentMode = UIViewContentModeCenter;
        //[_clearBtn setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        _clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_clearBtn addTarget:self action:@selector(didClearClick) forControlEvents:UIControlEventTouchUpInside];
        //_clearBtn.enabled = NO;
    }
    return _clearBtn;
}

- (UIButton *)combineBtn {
    if (!_combineBtn) {
        _combineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.bgView.frame = self.bounds;
        [_combineBtn setImage:[UIImage imageNamed:@"tab_combine_active"] forState:UIControlStateNormal];
        [_combineBtn setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        [_combineBtn setTitle:LocalString(@"combine") forState:UIControlStateNormal];
        _combineBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _combineBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        _combineBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _combineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_combineBtn addTarget:self action:@selector(didCombineClick) forControlEvents:UIControlEventTouchUpInside];
        _combineBtn.enabled = NO;
    }
    return _combineBtn;
}

- (UIButton *)scrollBtn {
    if (!_scrollBtn) {
        _scrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollBtn setImage:[UIImage imageNamed:@"tab_scroll_active"] forState:UIControlStateNormal];
        [_scrollBtn setImage:[UIImage imageNamed:@"tab_scroll"] forState:UIControlStateDisabled];
        [_scrollBtn setTitle:LocalString(@"scroll") forState:UIControlStateNormal];
        _scrollBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_scrollBtn addTarget:self action:@selector(didScrollClick) forControlEvents:UIControlEventTouchUpInside];
        _scrollBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _scrollBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _scrollBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        //_scrollBtn.enabled = NO;

    }
    return _scrollBtn;
}
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_editBtn setTintColor:[UIColor clearColor]];
        [_editBtn setImage:[UIImage imageNamed:@"tab_edit_active"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"tab_edit"] forState:UIControlStateDisabled];
        [_editBtn setTitle:LocalString(@"edit") forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_editBtn addTarget:self action:@selector(didEditClick) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.enabled = NO;
    }
    return _editBtn;
}

@end
