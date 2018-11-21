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
    UILongPressGestureRecognizer *upItemTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onUpItemTouch:)];
    [_moveUpItem addGestureRecognizer:upItemTouch];
    UILongPressGestureRecognizer *downItemTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onDownItemTouch:)];
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

- (void)onUpItemTouch:(UIGestureRecognizer*)gesture {
    NSLog(@"beginY   %f", _model.beginY);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.modifyDelegate onUpDragItemTap:_model.index];
            break;
        case UIGestureRecognizerStateChanged:
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateEnded:
            [self.modifyDelegate onDownDragItemTap:_model.index];
            break;
        default:
            break;
    }
    
}

- (void)onDownItemTouch:(UIGestureRecognizer*)gesture {
    NSLog(@"endY   %f", _model.endY);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.modifyDelegate onUpDragItemTap:_model.index];
            break;
        case UIGestureRecognizerStateChanged:
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateEnded:
            [self.modifyDelegate onDownDragItemTap:_model.index];
            break;
        default:
            break;
    }
    
}

@end
