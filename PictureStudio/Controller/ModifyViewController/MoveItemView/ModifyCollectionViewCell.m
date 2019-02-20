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
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMagin;

@end

@implementation ModifyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.eidtMove = false;
    _imageView = [[UIImageView alloc] init];
    [self.containView addSubview:_imageView];
    _moveDownItem = [[UIImageView alloc] init];
    _moveDownItem.contentMode = UIViewContentModeCenter;
    [self addSubview:_moveDownItem];
    _moveDownItem.image = [UIImage imageNamed:@"move_drag_bottom"];
    _moveUpItem = [[UIImageView alloc] init];
    _moveUpItem.contentMode = UIViewContentModeCenter;
    [self addSubview:_moveUpItem];
    _moveUpItem.image = [UIImage imageNamed:@"move_drag_top"];
    self.moveDownItem.size = CGSizeMake(65, 22);
    self.moveUpItem.size = CGSizeMake(65, 22);
    self.moveDownItem.userInteractionEnabled = YES;
    self.moveUpItem.userInteractionEnabled = YES;
}



- (void)configCell:(PhotoCutModel *)model isEditMove:(BOOL)editMove isEditBorder:(BOOL)editBorder width:(CGFloat)width color:(UIColor*)color {
    self.model = model;
//    UILongPressGestureRecognizer *upItemTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onUpItemTouch:)];
//    [_moveUpItem addGestureRecognizer:upItemTouch];
//    UILongPressGestureRecognizer *downItemTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onDownItemTouch:)];
//    [_moveDownItem addGestureRecognizer:downItemTouch];
    _leftMagin.constant = width;
    _rightMagin.constant = width;
    _topMagin.constant = width*0.5;
    _bottomMagin.constant = width*0.5;
    if (model.index == 0) {
        _topMagin.constant = width;
    }
    if (model.isEND) {
        _bottomMagin.constant = width;
    }
    if (color != nil) {
        self.backgroundColor = color;
    }
    UIImage *image = model.originPhoto;
    CGFloat imageWidth = image.size.width - 2*width;
    
    _imageView.image = image;
    CGFloat ratio = (self.hx_w - 2*width)/imageWidth;
    CGRect cgPos;
    cgPos.origin.x = 0;
    cgPos.origin.y = -model.beginY*ratio;
    cgPos.size.width = self.hx_w - 2*width;
    cgPos.size.height = image.size.height * ratio;
    _imageView.frame = cgPos;

    _moveUpItem.center = CGPointMake(self.center.x, 11);
    _moveDownItem.center = CGPointMake(self.center.x, self.hx_h - 11);
    _moveUpItem.hidden = !editMove||editBorder;
    _moveDownItem.hidden = !editMove||editBorder;

    
}



//- (void)onUpItemTouch:(UIGestureRecognizer*)gesture {
//    NSLog(@"beginY   %f", _model.beginY);
//    CGPoint touchPoint = [gesture locationInView:self];
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//            [self.modifyDelegate onUpDragItemTap:_model.index];
//            break;
//        case UIGestureRecognizerStateChanged:
//            NSLog(@"touchPoint %f %f", touchPoint.x, touchPoint.y);
//            break;
//        case UIGestureRecognizerStateCancelled:
//
//            break;
//        case UIGestureRecognizerStateEnded:
//            //[self.modifyDelegate onDownDragItemTap:_model.index];
//            break;
//        default:
//            break;
//    }
//
//}
//
//- (void)onDownItemTouch:(UIGestureRecognizer*)gesture {
//    NSLog(@"endY   %f", _model.endY);
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//            [self.modifyDelegate onUpDragItemTap:_model.index];
//            break;
//        case UIGestureRecognizerStateChanged:
//
//            break;
//        case UIGestureRecognizerStateCancelled:
//
//            break;
//        case UIGestureRecognizerStateEnded:
//            //[self.modifyDelegate onDownDragItemTap:_model.index];
//            break;
//        default:
//            break;
//    }
//
//}

@end
