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

- (void)configCell:(PhotoCutModel *)model {
    
//    CGRect cgpos;
    UIImage *image = model.originPhoto;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    CGFloat itemHeight = (model.endY - model.beginY);
    CGFloat ratio = self.hx_w/imageView.hx_w;
    
//    cgpos.origin.x = 0;
//    cgpos.origin.y = 0;
//    cgpos.size.width = self.hx_w;
//    cgpos.size.height = itemHeight*ratio;
    _imageScrollView.frame = self.frame;
 
    _imageScrollView.contentSize = CGSizeMake(self.hx_w, imageView.hx_h*ratio);
    _imageScrollView.contentOffset = CGPointMake(0, model.beginY*ratio);
    _imageScrollView.scrollEnabled = NO;

    imageView.size = CGSizeMake(self.hx_w, _imageScrollView.contentSize.height);
    [_imageScrollView addSubview:imageView];
}

@end
