//
//  ModifyCollectionViewCell.m
//  PictureStudio
//
//  Created by mickey on 2018/10/24.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "ModifyCollectionViewCell.h"
#import "PhotoCutModel.h"
#import "UIView+HXExtension.h"


@interface ModifyCollectionViewCell()

@end

@implementation ModifyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)configCell:(PhotoCutModel *)model {
    self.model = model;
    UIGestureRecognizer *upItemTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUpItemTouch)];
    [_moveUpItem addGestureRecognizer:upItemTouch];
    UIGestureRecognizer *downItemTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDownItemTouch)];
    [_moveDownItem addGestureRecognizer:downItemTouch];
    for (UIImageView *imageView in _imageScrollView.subviews) {
        [imageView removeFromSuperview];
        
    }
    UIImage *image = model.originPhoto;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];

    CGFloat ratio = self.hx_w/imageView.hx_w;

    _imageScrollView.frame = self.frame;
 
    _imageScrollView.contentSize = CGSizeMake(self.hx_w, imageView.hx_h*ratio);
    _imageScrollView.contentOffset = CGPointMake(0, model.beginY*ratio);
    _imageScrollView.scrollEnabled = NO;

    imageView.size = CGSizeMake(self.hx_w, _imageScrollView.contentSize.height);
    [_imageScrollView addSubview:imageView];
}

- (void)onUpItemTouch {
    NSLog(@"beginY   %f", _model.beginY);
    [self.modifyDelegate onUpDragItemTap:_model.index];
}

- (void)onDownItemTouch {
    NSLog(@"endY   %f", _model.endY);
    [self.modifyDelegate onDownDragItemTap:_model.index];
}

@end
