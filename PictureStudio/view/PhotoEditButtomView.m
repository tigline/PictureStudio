//
//  PhotoEditButtomView.m
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "PhotoEditButtomView.h"


@interface PhotoEditButtomView ()
@property (strong, nonatomic) UIButton *previewBtn;

@property (strong, nonatomic) UIButton *editBtn;
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
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context, 1.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0.314, 0.486, 0.859, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context, 138, 50/4);
    //下一点
    CGContextAddLineToPoint(context, 138, 50/2);
    //下一点
    CGContextAddLineToPoint(context, 159, 50/4);
    //绘制完成
    CGContextStrokePath(context);
    
    
}
- (void)setupUI {
    [self setBackgroundColor:[UIColor clearColor]];
    self.clipsToBounds = YES;
    [self addSubview:self.bgView];
    [self addSubview:self.previewBtn];
    [self addSubview:self.originalBtn];
    [self addSubview:self.editBtn];
    
}
- (void)setManager:(HXPhotoManager *)manager {
    _manager = manager;
    self.originalBtn.hidden = self.manager.configuration.hideOriginalBtn;
    if (manager.type == HXPhotoManagerSelectedTypePhoto) {
        self.editBtn.hidden = !manager.configuration.photoCanEdit;
    }else if (manager.type == HXPhotoManagerSelectedTypeVideo) {
        self.originalBtn.hidden = YES;
        self.editBtn.hidden = !manager.configuration.videoCanEdit;
    }else {
        if (!manager.configuration.videoCanEdit && !manager.configuration.photoCanEdit) {
            self.editBtn.hidden = YES;
        }
    }
    self.originalBtn.selected = self.manager.original;
    
    [self.previewBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.previewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //self.doneBtn.backgroundColor = [self.manager.configuration.themeColor colorWithAlphaComponent:0.5];
    [self.originalBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.originalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [self.originalBtn setImage:[HXPhotoTools hx_imageNamed:self.manager.configuration.originalNormalImageName] forState:UIControlStateNormal];
    //    [self.originalBtn setImage:[HXPhotoTools hx_imageNamed:self.manager.configuration.originalSelectedImageName] forState:UIControlStateSelected];
    [self.editBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    if ([self.manager.configuration.themeColor isEqual:[UIColor whiteColor]]) {
        //[self.doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[self.doneBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    }
    if (self.manager.configuration.selectedTitleColor) {
        //[self.doneBtn setTitleColor:self.manager.configuration.selectedTitleColor forState:UIControlStateNormal];
        //[self.doneBtn setTitleColor:[self.manager.configuration.selectedTitleColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    }
}
- (void)setSelectCount:(NSInteger)selectCount {
    _selectCount = selectCount;
    if (selectCount <= 0) {
        self.previewBtn.enabled = NO;
        //self.doneBtn.enabled = NO;
        //[self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        self.previewBtn.enabled = YES;
        
        
    }
    
    //self.doneBtn.backgroundColor = self.doneBtn.enabled ? self.manager.configuration.themeColor : [self.manager.configuration.themeColor colorWithAlphaComponent:0.5];
    //[self changeDoneBtnFrame];
    
    
    if (self.manager.selectedPhotoArray.count) {
        self.editBtn.enabled = self.manager.configuration.photoCanEdit;
    }else{
        self.editBtn.enabled = NO;
    }
    
    if (self.manager.selectedPhotoArray.count == 0) {
        self.originalBtn.enabled = NO;
        self.originalBtn.selected = NO;
        [self.manager setOriginal:NO] ;
    }else {
        self.originalBtn.enabled = YES;
    }
}

- (void)didPreviewClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidPreviewBtn)]) {
        [self.delegate datePhotoBottomViewDidPreviewBtn];
    }
}
- (void)didEditBtnClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidEditBtn)]) {
        [self.delegate datePhotoBottomViewDidEditBtn];
    }
}
- (void)didOriginalClick:(UIButton *)button {
    button.selected = !button.selected;
    [self.manager setOriginal:button.selected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    
    CGFloat btnWidth = self.bgView.frame.size.width/3;
    CGFloat pointY = (self.bgView.size.height - btnHeight)/2;
    
    self.previewBtn.frame = CGRectMake(0, pointY, btnWidth, btnHeight);
    self.previewBtn.backgroundColor = [UIColor clearColor];
    
    self.originalBtn.frame = CGRectMake(btnWidth, pointY, btnWidth, btnHeight);
    
    
    self.editBtn.frame = CGRectMake(btnWidth*2, pointY, btnWidth, btnHeight);
    
    
}
- (UIToolbar *)bgView {
    if (!_bgView) {
        _bgView = [[UIToolbar alloc] init];
        
    }
    return _bgView;
}
- (UIButton *)previewBtn {
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.bgView.frame = self.bounds;
        [_previewBtn setImage:[UIImage imageNamed:@"tab_combine_active"] forState:UIControlStateNormal];
        [_previewBtn setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        [_previewBtn setTitle:@"Combine" forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _previewBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _previewBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _previewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_previewBtn addTarget:self action:@selector(didPreviewClick) forControlEvents:UIControlEventTouchUpInside];
        _previewBtn.enabled = NO;
    }
    return _previewBtn;
}

- (UIButton *)originalBtn {
    if (!_originalBtn) {
        _originalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_originalBtn setImage:[UIImage imageNamed:@"tab_scroll_active"] forState:UIControlStateNormal];
        [_originalBtn setImage:[UIImage imageNamed:@"tab_scroll"] forState:UIControlStateDisabled];
        [_originalBtn setTitle:@"Scroll" forState:UIControlStateNormal];
        _originalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_originalBtn addTarget:self action:@selector(didOriginalClick:) forControlEvents:UIControlEventTouchUpInside];
        _originalBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _originalBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _originalBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        _originalBtn.enabled = NO;
        _originalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _originalBtn;
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
        [_editBtn addTarget:self action:@selector(didEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.enabled = NO;
    }
    return _editBtn;
}

@end
