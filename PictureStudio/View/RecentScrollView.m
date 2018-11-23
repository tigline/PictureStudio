//
//  RecentScrollView.m
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/8/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "RecentScrollView.h"
//#import "UIFont+HXExtension.h"
@implementation RecentScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.image = [UIImage imageNamed:@"recent_scroll"];
        [self addSubview:imageView];
        
        mUILabel = [[UILabel alloc] init];
        mUILabel.text = @"最近长截图";
        mUILabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        mUILabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        [self addSubview:mUILabel];
        
        
        CGSize mUILabelSize = [mUILabel.text boundingRectWithSize:mUILabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:mUILabel.font} context:nil].size;
        mUILabel.frame = CGRectMake((self.frame.size.width - mUILabelSize.width)/2, 3.5*2, mUILabelSize.width, mUILabelSize.height);
        [self addSubview:mUILabel];
        
        UIView *boardView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 41.5*2)/2-1, mUILabel.frame.size.height+mUILabel.frame.origin.y+3*2-1, 41.5*2+2, 41.5*2+2)];
        boardView.layer.borderWidth = 1;
        
        boardView.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] CGColor];
        [self addSubview:boardView];
        
        thumbPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 41.5*2)/2, mUILabel.frame.size.height+mUILabel.frame.origin.y+3*2, 41.5*2, 41.5*2)];
        
        [self addSubview:thumbPhotoImageView];
        
        
        //开始定时管理
        [NSTimer scheduledTimerWithTimeInterval:35.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:self
                                        repeats:YES];
    }
    return self;
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIView *mRecentScrollView = (UIView*)[theTimer userInfo];
    [UIView animateWithDuration:1.0f animations:^{
        mRecentScrollView.alpha = 0.0f;
    }];
}


-(void)setImage:(UIImage *)image
{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, (image.size.height - image.size.width)/2,image.size.width , image.size.width));
    //将CGImageRef转换成UIImage
    thumbPhotoImageView.image = [UIImage imageWithCGImage:newImageRef];
    thumbPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    thumbPhotoImageView.clipsToBounds = YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    imageView.image = [UIImage imageNamed:@"recent_scroll_p"];
    mUILabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.6];

    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 0.0f;
    }];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    imageView.image = [UIImage imageNamed:@"recent_scroll"];
    mUILabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    imageView.image = [UIImage imageNamed:@"recent_scroll"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
