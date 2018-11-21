//
//  MoveCollectionViewFlowLayout.m
//  PictureStudio
//
//  Created by mickey on 2018/11/7.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "MoveCollectionViewFlowLayout.h"
#import "ModifyCollectionViewCell.h"


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
    CGRect collectionViewFrameInCanvas;
    Bundle bundle;
    UIView *canvas;
    UILongPressGestureRecognizer *longGesture;
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


- (void)setup {
    animation = NO;
    draggable = YES;
    bundle.offset = CGPointZero;
    longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.collectionView addGestureRecognizer:longGesture];
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
    if (draggable == NO) {
        return NO;
    }
    if (canvas == nil) {
        return NO;
    }
    UICollectionView *collectionView = self.collectionView;
    if (collectionView == nil) {
        return NO;
    }
    CGPoint pointPressedInCanvas = [gestureRecognizer locationInView:canvas];
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        //NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        CGPoint pointInCell = [cell.layer convertPoint:pointPressedInCanvas fromLayer:self.collectionView.layer];
        if ([cell.layer containsPoint:pointInCell]) {
            ModifyCollectionViewCell *moveCell = (ModifyCollectionViewCell*)cell;
            CGPoint pointInUpView = [moveCell.moveUpItem.layer convertPoint:pointInCell fromLayer:cell.layer];
            if ([moveCell.moveUpItem.layer containsPoint:pointInUpView]) {
                [moveCell.moveUpItem addGestureRecognizer:longGesture];
                return YES;
            }
            CGPoint pointInDownView = [moveCell.moveDownItem.layer convertPoint:pointInCell fromLayer:cell.layer];
            if ([moveCell.moveDownItem.layer containsPoint:pointInDownView]) {
                [moveCell.moveDownItem addGestureRecognizer:longGesture];
                return YES;
            }
        }
        
    }
    return NO;
}


- (void)handleGesture:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
        default:
            break;
    }
}



@end
