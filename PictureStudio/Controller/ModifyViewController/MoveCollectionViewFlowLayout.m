//
//  MoveCollectionViewFlowLayout.m
//  PictureStudio
//
//  Created by mickey on 2018/11/7.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "MoveCollectionViewFlowLayout.h"


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
//
//    for (UICollectionViewCell *cell in collectionView.visibleCells) {
//        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
//
//    }
    return true;
}

@end
