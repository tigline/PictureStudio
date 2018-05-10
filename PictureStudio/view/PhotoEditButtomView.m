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
@end

@implementation PhotoEditButtomView
#define btnHeight 40

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
    [self addSubview:self.clearBtn];
    [self addSubview:self.combineBtn];
//    [self addSubview:self.scrollBtn];
//    [self addSubview:self.editBtn];
    
}
- (void)setManager:(HXPhotoManager *)manager {
    _manager = manager;
    [self.combineBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.combineBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.scrollBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.scrollBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.editBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.clearBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.clearBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}
- (void)setSelectCount:(NSInteger)selectCount {
    _selectCount = selectCount;
    if (selectCount > 0) {
        self.clearBtn.enabled = YES;
    } else {
        self.clearBtn.enabled = NO;
    }
    
    if(selectCount == 1) {
        self.combineBtn.enabled = NO;
        self.scrollBtn.enabled = NO;
        self.editBtn.enabled = YES;
    }else if(_manager.isAllScreenShotPhoto) {
        self.combineBtn.enabled = YES;
        self.scrollBtn.enabled = YES;
        self.editBtn.enabled = NO;
    }else if(selectCount > 1){
        self.combineBtn.enabled = NO;
        self.scrollBtn.enabled = YES;
        self.editBtn.enabled = NO;
    }else {
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


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    
    CGFloat btnWidth = self.bgView.frame.size.width/4;
    CGFloat pointY = (self.bgView.size.height - btnHeight)/2;
    
    
    self.clearBtn.frame = CGRectMake(0, pointY, btnWidth, btnHeight);
    
    self.combineBtn.frame = CGRectMake(btnWidth, pointY, btnWidth*3, btnHeight);
    
    CALayer* segmentingLineFrist = [CALayer layer];
    segmentingLineFrist.frame = CGRectMake(btnWidth, 13, 0.6, 18);
    segmentingLineFrist.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:segmentingLineFrist];
    
    
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

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.bgView.frame = self.bounds;
        [_clearBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        //_clearBtn.imageView.contentMode = UIViewContentModeCenter;
        //[_clearBtn setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        [_clearBtn setTitle:@"Clear" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _clearBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _clearBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_clearBtn addTarget:self action:@selector(didClearClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.enabled = NO;
    }
    return _clearBtn;
}

- (UIButton *)combineBtn {
    if (!_combineBtn) {
        _combineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.bgView.frame = self.bounds;
        [_combineBtn setImage:[UIImage imageNamed:@"tab_combine_active"] forState:UIControlStateNormal];
        [_combineBtn setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        [_combineBtn setTitle:@"Combine" forState:UIControlStateNormal];
        _combineBtn.titleLabel.font = [UIFont systemFontOfSize:17];
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
        [_scrollBtn setTitle:@"Scroll" forState:UIControlStateNormal];
        _scrollBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_scrollBtn addTarget:self action:@selector(didScrollClick) forControlEvents:UIControlEventTouchUpInside];
        _scrollBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _scrollBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _scrollBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        _scrollBtn.enabled = NO;
        _scrollBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _scrollBtn;
}
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_editBtn setTintColor:[UIColor clearColor]];
        [_editBtn setImage:[UIImage imageNamed:@"tab_edit_active"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"tab_edit"] forState:UIControlStateDisabled];
        [_editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_editBtn addTarget:self action:@selector(didEditClick) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.enabled = NO;
    }
    return _editBtn;
}

@end
