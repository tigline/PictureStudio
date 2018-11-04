//
//  MoveItemCell.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/10/30.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "MoveItemCell.h"
#import "MoveInfoModel.h"
#import "PhotoCutModel.h"
#import "UIView+HXExtension.h"



@interface MoveItemCell()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *moveItemScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *showToUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *showToDownImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopContaints;
@property (assign, nonatomic) BOOL canScroll;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) CGFloat canMoveHeight;
//@property (strong, nonatomic) UIScrollView *moveItemScrollView;
@end

@implementation MoveItemCell


- (void)configCell:(MoveInfoModel *)model {
    
    
    _moveItemScrollView.delegate = self;
    if (_moveModel.isMoveDown) {
        _moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, _moveItemScrollView.originY - model.canMoveHeight, self.hx_w, self.hx_h + model.canMoveHeight);
    } else {
        _moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, _moveItemScrollView.originY, self.hx_w, self.hx_h + model.canMoveHeight);
    }
    
    _canScroll = false;
    _moveModel = model;
    if (model.isMoveUp) {
        _showToUpImageView.hidden = NO;
        _showToDownImageView.hidden = YES;
    } else if(model.isMoveDown) {
        _showToUpImageView.hidden = YES;
        _showToDownImageView.hidden = NO;
    }
    [self createShowView:model.photoArray];

}

- (void)createShowView:(NSArray *)photoArray {
    CGFloat offset = 0;
    UIView *containView = [[UIView alloc] init];
    containView.clipsToBounds = YES;
    [_moveItemScrollView addSubview:containView];
    CGRect cgpos;
    NSInteger count = photoArray.count;
    for (int i = 0; i < count; i++) {
        PhotoCutModel *mode = [photoArray objectAtIndex:i];
        UIImage *image = mode.originPhoto;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat itemHeight;
        CGFloat ratio = self.hx_w/imageView.hx_w;
        if (_moveModel.isMoveDown) {
            if (i == count - 1) {
                itemHeight = (imageView.hx_h - mode.beginY);
                offset = (imageView.hx_h - mode.endY)*ratio;
                _canMoveHeight = (imageView.hx_h - mode.beginY)*ratio;
            } else {
                itemHeight = (mode.endY - mode.beginY);
            }
        } else {
            if (i == 0) {
                itemHeight = (mode.endY);
                offset = mode.beginY*ratio;
                _canMoveHeight = (imageView.hx_h - mode.beginY)*ratio;
            } else {
                itemHeight = (mode.endY - mode.beginY);
            }
        }
        
        
        CGFloat contentViewOffset;
        if(i == 0) {
            contentViewOffset = 0;
        } else {
            contentViewOffset = containView.hx_h;
        }
        
        
        cgpos.origin.x = 0;
        cgpos.origin.y = contentViewOffset;
        cgpos.size.width = self.hx_w;
        cgpos.size.height = itemHeight*ratio;

        UIScrollView *itemView = [[UIScrollView alloc]initWithFrame:cgpos];
        
        [containView addSubview:itemView];
        itemView.contentSize = CGSizeMake(self.hx_w, imageView.hx_h*ratio);
        if (_moveModel.isMoveDown) {
            if (i == count - 1) {
                itemView.contentOffset = CGPointMake(0, mode.beginY*ratio);
            } else {
                itemView.contentOffset = CGPointMake(0, mode.beginY*ratio);
            }
        } else {
            if (i == 0) {
                //itemView.contentOffset = CGPointMake(0, mode.beginY*ratio);
            } else {
                itemView.contentOffset = CGPointMake(0, mode.beginY*ratio);
            }
        }
        
        itemView.scrollEnabled = NO;
        
        CGFloat lastOffset;
        if (i == photoArray.count - 1 || i == 0) {
            lastOffset = cgpos.size.height;
        } else {
            lastOffset = cgpos.size.height;
        }
        
        containView.size = CGSizeMake(cgpos.size.width, containView.hx_h + lastOffset);
        imageView.size = CGSizeMake(self.hx_w, itemView.contentSize.height);
        [itemView addSubview:imageView];
    }
    
    //containView.frame = CGRectMake(0, 0, self.hx_w, containView.hx_h);
    [_moveItemScrollView setContentSize:CGSizeMake(self.hx_w, containView.hx_h)];
    if (_moveModel.isMoveDown) {
        [_moveItemScrollView setContentOffset:CGPointMake(0, _moveItemScrollView.contentSize.height - (self.hx_h + offset))];
        //_canScroll = true;
    } else {
        [_moveItemScrollView setContentOffset:CGPointMake(0, offset)];
       // _canScroll = true;
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    _showToUpImageView.hidden = YES;
    _showToDownImageView.hidden = YES;
    _lastContentOffset = scrollView.contentOffset.y;
    _moveModel.moveDistance = _lastContentOffset;
    [self.moveDelegate beginMoveCellAt:_moveModel moveDistance:_lastContentOffset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_canScroll) {
        CGFloat contentHeight = scrollView.contentSize.height - self.hx_h;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat lastOffset = scrollView.contentOffset.y - _lastContentOffset;
        CGFloat moveOffset = scrollView.contentSize.height - scrollView.hx_h - contentOffsetY;
        
        if (_moveModel.isMoveDown) {
            if (moveOffset < _canMoveHeight - 22) {
                if (contentOffsetY > contentHeight) {
                    self.moveItemScrollView.frame = self.frame;
                }else if (contentOffsetY < 0 && scrollView.hx_h > 22) {
                    self.moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, _moveItemScrollView.originY - contentOffsetY, _moveItemScrollView.hx_w, _moveItemScrollView.hx_h + contentOffsetY);
                } else if (contentOffsetY > 0 && (scrollView.hx_h < self.hx_h)) {
                    self.moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, _moveItemScrollView.originY - lastOffset, _moveItemScrollView.hx_w, _moveItemScrollView.hx_h + lastOffset);
                    [_moveItemScrollView setContentOffset:CGPointMake(0, 0)];
                } else if (scrollView.hx_h <= 22){
                    self.moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, self.hx_h - 22, _moveItemScrollView.hx_w, 22);
                }
            } else if (moveOffset >= _canMoveHeight - 22){
//                self.moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, self.hx_h - 22, _moveItemScrollView.hx_w, _canMoveHeight - );
//                CGPoint offset = scrollView.contentOffset;
//                [scrollView setContentOffset:offset animated:NO];
//                scrollView.scrollEnabled = NO;
            }
            
        } else {
            if((contentOffsetY - contentHeight) > self.hx_h - 22) {
                self.moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, _moveItemScrollView.originY, _moveItemScrollView.hx_w, 22);
            }else if (contentOffsetY > contentHeight && (contentOffsetY - contentHeight) < self.hx_h - 22) {
                self.moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, _moveItemScrollView.originY, _moveItemScrollView.hx_w, self.hx_h - contentOffsetY + contentHeight);

            } else if(contentOffsetY < 0) {
                self.moveItemScrollView.frame = CGRectMake(_moveItemScrollView.originX, _moveItemScrollView.originY, _moveItemScrollView.hx_w, self.hx_h);
            }
        }

    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_moveModel.isMoveUp) {
        _showToUpImageView.hidden = NO;
        _canScroll = true;
    } else {
        _showToDownImageView.hidden = NO;
        _canScroll = true;
        //scrollView.scrollEnabled = YES;
    }
    
    [self.moveDelegate beginMoveCellAt:_moveModel moveDistance:_lastContentOffset];
}



@end
