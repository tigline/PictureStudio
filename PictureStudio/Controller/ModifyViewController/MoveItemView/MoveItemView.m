//
//  MoveItemView.m
//  PictureStudio
//
//  Created by mickey on 2018/9/18.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "MoveItemView.h"
#import "PhotoCutModel.h"

@implementation MoveItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
//        _upDragView = [[UIImageView alloc]init];
//        [self.upDragView setImage:[UIImage imageNamed:@"move_drag_top"]];
//        [self.upDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_top_p"]];
//        _upDragView.center = CGPointMake(self.center.x, self.upDragView.frame.size.height/2);
//        [self addSubview:_upDragView];
//        _downDragView = [[UIImageView alloc]init];
//        [self.downDragView setImage:[UIImage imageNamed:@"move_drag_bottom"]];
//        [self.downDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_bottom_p"]];
//        _downDragView.center = self.center;//CGPointMake(self.center.x,self.frame.size.height - self.downDragView.frame.size.height/2);
//        [self addSubview:_downDragView];
    }
    return self;
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

- (void)setNewModel:(PhotoCutModel *)model {
    _cutModel = model;
    _upDragView = [[UIImageView alloc]init];
    [self.upDragView setImage:[UIImage imageNamed:@"move_drag_top"]];
    [self.upDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_top_p"]];
    _upDragView.center = CGPointMake(self.center.x, self.upDragView.frame.size.height/2);
    [self addSubview:_upDragView];
    _downDragView = [[UIImageView alloc]init];
    [self.downDragView setImage:[UIImage imageNamed:@"move_drag_bottom"]];
    [self.downDragView setHighlightedImage:[UIImage imageNamed:@"move_drag_bottom_p"]];
    _downDragView.center = self.center;//CGPointMake(self.center.x,self.frame.size.height - self.downDragView.frame.size.height/2);
    _downDragView.frame = CGRectMake(self.center.x, self.frame.size.height, _downDragView.frame.size.width, _downDragView.frame.size.height);
    [self addSubview:_downDragView];
}

- (void)setDragButtomHidden:(BOOL)hidden {
    
}

- (void)setMoveState:(moveState)state {
    
}

@end
