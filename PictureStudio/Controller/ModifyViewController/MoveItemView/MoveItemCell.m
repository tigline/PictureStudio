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

@end

@implementation MoveItemCell


- (void)configCell:(MoveInfoModel *)model {
    _moveItemScrollView.delegate = self;
    
    [self createShowView:model.photoArray];

}

- (void)createShowView:(NSArray *)photoArray {
    UIView *containView = [[UIView alloc] init];
    containView.clipsToBounds = YES;
    [_moveItemScrollView addSubview:containView];
    CGRect cgpos;
    NSInteger count = photoArray.count;
    for (int i = 0; i < count; i++) {
        PhotoCutModel *mode = [photoArray objectAtIndex:i];
        UIImage *image = mode.originPhoto;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat itemHeight = (mode.endY - mode.beginY);
        
        CGFloat contentViewOffset;
        if(i == 0) {
            contentViewOffset = 0;
        } else {
            contentViewOffset = containView.hx_h;
        }
        
        CGFloat ratio = self.hx_w/imageView.hx_w;
        cgpos.origin.x = 0;
        cgpos.origin.y = contentViewOffset;
        cgpos.size.width = self.hx_w;
        cgpos.size.height = itemHeight*ratio;

        UIScrollView *itemView = [[UIScrollView alloc]initWithFrame:cgpos];
        
        [containView addSubview:itemView];
        itemView.contentSize = CGSizeMake(self.hx_w, imageView.hx_h*ratio);
        itemView.contentOffset = CGPointMake(0, mode.beginY*ratio);
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
    containView.frame = CGRectMake(0, 0, self.hx_w, containView.hx_h);
    [_moveItemScrollView setContentSize:CGSizeMake(self.hx_w, containView.hx_h)];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


@end
