//
//  MoveCollectionViewFlowLayout.m
//  PictureStudio
//
//  Created by mickey on 2018/11/7.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "MoveCollectionViewFlowLayout.h"
#import "ModifyCollectionViewCell.h"
#import "PhotoCutModel.h"

typedef struct {
    CGPoint offset;
    UICollectionViewCell *sourceCell;
    UIView *representationImageView;
    NSIndexPath *currentIndexPath;
}Bundle;

@interface MoveCollectionViewFlowLayout()<UIGestureRecognizerDelegate>
{
    BOOL animation;
    BOOL draggable;
    BOOL isDragUpItem;
    CGRect collectionViewFrameInCanvas;
    Bundle bundle;
    UIView *canvas;
    UILongPressGestureRecognizer *longGesture;
    NSInteger index;
    CGPoint lastPoint;
}

@end




@implementation MoveCollectionViewFlowLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)prepareLayout {
    [super prepareLayout];
    [self setup];
}

- (void)setup {
    animation = NO;
    draggable = YES;
    bundle.offset = CGPointZero;
    longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    longGesture.delegate = self;
    [self.collectionView addGestureRecognizer:longGesture];
    if (canvas == nil) {
        canvas = [self.collectionView superview];
    }
    [self calculateBorders];
}

- (void)calculateBorders {
    if (self.collectionView != nil) {
        collectionViewFrameInCanvas = self.collectionView.frame;
        if (canvas != [self.collectionView superview]) {
            collectionViewFrameInCanvas = [canvas convertRect:collectionViewFrameInCanvas fromView:self.collectionView];//canvas convert (collectionViewFrameInCanvas, from: collectionView)
        }
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (draggable == NO) {
//        return NO;
//    }
//    if (canvas == nil) {
//        return NO;
//    }
    UICollectionView *collectionView = self.collectionView;
    if (collectionView == nil) {
        return NO;
    }
    CGPoint pointPressedInCanvas = [gestureRecognizer locationInView:self.collectionView];
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        //NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        CGPoint cellInView = [cell.layer convertPoint:pointPressedInCanvas fromLayer:self.collectionView.layer];
        if ([cell.layer containsPoint:cellInView]) {
            ModifyCollectionViewCell *moveCell = (ModifyCollectionViewCell*)cell;
            PhotoCutModel *model = moveCell.model;
            index = model.index;
            CGPoint pointInUpView = [moveCell.moveUpItem.layer convertPoint:cellInView fromLayer:cell.layer];
            if ([moveCell.moveUpItem.layer containsPoint:pointInUpView]) {
                [moveCell.moveUpItem addGestureRecognizer:longGesture];
                //draggable = YES;
                isDragUpItem = YES;
                bundle.sourceCell = cell;
                return YES;
            }
            CGPoint pointInDownView = [moveCell.moveDownItem.layer convertPoint:cellInView fromLayer:cell.layer];
            if ([moveCell.moveDownItem.layer containsPoint:pointInDownView]) {
                [moveCell.moveDownItem addGestureRecognizer:longGesture];
                //draggable = YES;
                bundle.sourceCell = cell;
                isDragUpItem = NO;
                return YES;
            }
        }
        
    }
    return NO;
}


- (void)handleGesture:(UIGestureRecognizer *)gesture {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
//    if (draggable) {
//        self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentOffset.y - 10);
//    }
    CGPoint point = [gesture locationInView:self.collectionView];
    ModifyCollectionViewCell *moveCell = (ModifyCollectionViewCell*)bundle.sourceCell;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            lastPoint = point;
            draggable = NO;
            layout.minimumLineSpacing = 0;

            break;
        case UIGestureRecognizerStateChanged:
            draggable = NO;
            CGFloat touchOffset = point.y - lastPoint.y;
            
            if (isDragUpItem) {
                
                moveCell.imageView.center = CGPointMake(moveCell.imageView.center.x, moveCell.imageView.center.y + touchOffset);
            } else {
                moveCell.imageView.center = CGPointMake(moveCell.imageView.center.x, moveCell.imageView.center.y + touchOffset);
            }
            break;
        case UIGestureRecognizerStateCancelled:

            break;
        case UIGestureRecognizerStateEnded:
//            self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentOffset.y + 20);
            layout.minimumLineSpacing = 10;
            //[self.collectionView reloadData];
            draggable = YES;
            break;
        default:
            break;
    }
}



@end
