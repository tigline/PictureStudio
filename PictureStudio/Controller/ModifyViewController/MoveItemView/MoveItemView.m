//
//  MoveItemView.m
//  PictureStudio
//
//  Created by mickey on 2018/9/18.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "MoveItemView.h"
#import "PhotoCutModel.h"
#import "UIView+HXExtension.h"

@implementation MoveItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.clipsToBounds = YES;
    

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

//- (instancetype)initWithFrame:(CGRect)frame model:(PhotoCutModel *)model {
//    if (self) {
//        self = [super init];
//        [self.upDragView setImage:[UIImage imageNamed:@"move_drag_top"]];
//        [self.upDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_top_p"]];
//        self.upDragView.center = CGPointMake(self.center.x, self.upDragView.frame.size.height/2);
//
//        [self.downDragView setImage:[UIImage imageNamed:@"move_drag_bottom"]];
//        [self.downDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_bottom_p"]];
//        self.upDragView.center = CGPointMake(self.center.x,self.frame.size.height - self.upDragView.frame.size.height/2);
//        self.cutModel = model;
//    }
//    return self;
//}
//参考 picview 固定位置 调整 拖动位置其实是不变的。
- (void)setNewModel:(PhotoCutModel *)model {
    _cutModel = model;
    UIImage *image = model.originPhoto;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    //CGFloat itemHeight = (model.endY - model.beginY);
    imageView.size = CGSizeMake(self.frame.size.width, self.contentSize.height);
    [self addSubview:imageView];
    
    _upDragView = [[UIImageView alloc]init];
    [self.upDragView setImage:[UIImage imageNamed:@"move_drag_top"]];
    [self.upDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_top_p"]];
    self.upDragView.userInteractionEnabled = YES;
    
    self.upDragView.frame = CGRectMake((self.hx_w - _upDragView.image.size.width)/2, model.scaleRatio*model.beginY, _upDragView.image.size.width, _upDragView.image.size.height);
    [self addSubview:_upDragView];
    
    _downDragView = [[UIImageView alloc]init];
    self.downDragView.userInteractionEnabled = YES;
    [self.downDragView setImage:[UIImage imageNamed:@"move_drag_bottom"]];
    [self.downDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_bottom_p"]];
    //_downDragView.center = self.center;//CGPointMake(self.center.x,self.frame.size.height - self.downDragView.frame.size.height/2);
    _downDragView.frame = CGRectMake((self.hx_w - _downDragView.image.size.width)/2, self.frame.size.height - _downDragView.image.size.height + model.scaleRatio*model.beginY, _downDragView.image.size.width, _downDragView.image.size.height);
    [self addSubview:_downDragView];
    
}

- (void)setDragButtomHidden:(BOOL)hidden {
    
}

- (void)setMoveState:(moveState)state {
    
}

@end
