//
//  EditImageBottomView.m
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/8/29.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "EditImageBottomView.h"
#define ImageViewSize 26 * ScreenWidthRatio
#define EditFunctionViewHeight 47 * ScreenHeightRatio

#define selectColor [UIColor colorWithRed:68/255 green:159/255 blue:255/255 alpha:0.5]
#define garyColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]
#define garytextColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define selectTextColor [UIColor colorWithRed:68/255 green:159/255 blue:255/255 alpha:1]

@implementation EditImageBottomView
{
    UIView *firstGayeView;
    UIView *secondGayeView;
    UIView *thirdGayeView;
    
    UIImageView *firstImageView;
    UIImageView *secondImageView;
    UIImageView *thirdImageView;
    
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    
    UIView *controlView;//可变化操作面板
    NSMutableArray *imageArray;
    
    NSInteger color;
    
    UIImageView *backImageView;
    UIImageView *goImageView;
    UIImageView *colorImageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//       self.backgroundColor = [UIColor yellowColor];
       [self CreatView];
    }
    return self;
}

-(void)CreatView
{
    controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, EditFunctionViewHeight)];
    [self addSubview:controlView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, EditFunctionViewHeight, self.frame.size.width, 2)];
    grayView.backgroundColor = garyColor;
    [self addSubview:grayView];
    
    UIView *selectEditFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, EditFunctionViewHeight+2, self.frame.size.width, EditFunctionViewHeight)];
    selectEditFunctionView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20*ScreenWidthRatio, 10*ScreenHeightRatio, ImageViewSize, ImageViewSize)];
    [cancelButton setImage:[UIImage imageNamed:@"edit_cancel"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"edit_cancel_p"] forState:UIControlStateSelected];
    [cancelButton addTarget:self action:@selector(CancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [selectEditFunctionView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 20*ScreenWidthRatio - ImageViewSize, 10*ScreenHeightRatio, ImageViewSize, ImageViewSize)];
    [confirmButton setImage:[UIImage imageNamed:@"edit_next"] forState:UIControlStateNormal];
    [confirmButton setImage:[UIImage imageNamed:@"edit_next_p"] forState:UIControlStateSelected];
    [confirmButton addTarget:self action:@selector(ConfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [selectEditFunctionView addSubview:confirmButton];
    
    //处理中间的视图
    
    NSMutableArray *arrayView = [self getFunctionViewArray];
    
    if ([arrayView count] != 0)
    {
        UIView *mView = [arrayView objectAtIndex:0];
        
        CGFloat middleAreaWith = 30*ScreenWidthRatio;
        CGFloat mViewWidth = mView.frame.size.width;
        
        CGFloat firstViewLeft = (self.frame.size.width - 40*ScreenWidthRatio -2*ImageViewSize -[arrayView count]*mViewWidth -([arrayView count] - 1)*middleAreaWith)/2 + cancelButton.frame.size.width + cancelButton.frame.origin.x;
        UIView *selectView;
        for (int i = 0; i < [arrayView count]; i++)
        {
            mView = [arrayView objectAtIndex:i];
            if (i == 0)
            {
                mView.frame = CGRectMake(firstViewLeft, 0 , mView.frame.size.width, mView.frame.size.height);
            }
            else
            {
                mView.frame = CGRectMake(firstViewLeft + (mView.frame.size.width + middleAreaWith)*i, 0 , mView.frame.size.width, mView.frame.size.height);
            }
            
            //在这里创建 分割线处的选择提示
            
            selectView = [[UIView alloc] initWithFrame:CGRectMake(mView.frame.origin.x + (mView.frame.size.width - 20*ScreenWidthRatio)/2 , 0, 20*ScreenWidthRatio, 2)];
            selectView.backgroundColor = selectColor;
            [grayView addSubview:selectView];
            
            if (i == 0){
                firstGayeView = selectView;
            }
            else if (i == 1){
                secondGayeView = selectView;
            }
            else if (i == 2){
                thirdGayeView = selectView;
            }
            [selectEditFunctionView addSubview:mView];
        }
    }
    
    [self addSubview:selectEditFunctionView];
    
    [self setViewColorWithTag:10];
}


-(NSMutableArray*)getFunctionViewArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
    [array addObject:[self CreateFunctionViewWithTitle:@"裁剪" withImageView:[UIImage imageNamed:@"edit_cut"] WithTag:0]];
    [array addObject:[self CreateFunctionViewWithTitle:@"高亮" withImageView:[UIImage imageNamed:@"edit_highlight"] WithTag:1]];
    [array addObject:[self CreateFunctionViewWithTitle:@"涂鸦" withImageView:[UIImage imageNamed:@"edit_draw"] WithTag:2]];
    return array;
}


-(UIView*)CreateFunctionViewWithTitle:(NSString*)title withImageView:(UIImage*)image WithTag:(NSInteger)tag
{
    
    UIView *mView = [[UIView alloc] init];
    mView.tag = tag;

    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [mView addGestureRecognizer:tapGesturRecognizer];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize);
    imageView.image = image;
    [mView addSubview:imageView];
    
    UILabel *mLabel = [[UILabel alloc] init];
    mLabel.text = title;
    mLabel.font = [UIFont systemFontOfSize:11];
    
    
    CGFloat mLabelWidth = [mLabel.text boundingRectWithSize:mLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:mLabel.font} context:nil].size.width;
    CGFloat mLabelHeight = [mLabel.text boundingRectWithSize:mLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:mLabel.font} context:nil].size.height;
    mLabel.textColor = garytextColor;
    
    mLabel.frame = CGRectMake(ImageViewSize + 7*ScreenWidthRatio, (EditFunctionViewHeight - mLabelHeight)/2, mLabelWidth,mLabelHeight);
    mView.frame = CGRectMake(0, 0, ImageViewSize + 7*ScreenWidthRatio + mLabelWidth, EditFunctionViewHeight);
    [mView addSubview:mLabel];
    
    if (tag == 0)
    {
        firstImageView = imageView;
        firstLabel = mLabel;
    }
    else if (tag == 1)
    {
        secondImageView = imageView;
        secondLabel = mLabel;
    }
    else if (tag == 2)
    {
        thirdImageView = imageView;
        thirdLabel = mLabel;
    }
    return mView;
}

-(void)setViewColorWithTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            firstGayeView.hidden = NO;
            secondGayeView.hidden = YES;
            thirdGayeView.hidden = YES;
            
            firstImageView.image = [UIImage imageNamed:@"edit_cut_p"];
            secondImageView.image = [UIImage imageNamed:@"edit_highlight"];
            thirdImageView.image = [UIImage imageNamed:@"edit_draw"];
            
            firstLabel.textColor = selectTextColor;
            secondLabel.textColor = garytextColor;
            thirdLabel.textColor = garytextColor;
            break;
        case 1:
            firstGayeView.hidden = YES;
            secondGayeView.hidden = NO;
            thirdGayeView.hidden = YES;
            
            firstImageView.image = [UIImage imageNamed:@"edit_cut"];
            secondImageView.image = [UIImage imageNamed:@"edit_highlight_p"];
            thirdImageView.image = [UIImage imageNamed:@"edit_draw"];
            
            firstLabel.textColor = garytextColor;
            secondLabel.textColor = selectTextColor;
            thirdLabel.textColor = garytextColor;
            break;
        case 2:
            firstGayeView.hidden = YES;
            secondGayeView.hidden = YES;
            thirdGayeView.hidden = NO;
            
            firstImageView.image = [UIImage imageNamed:@"edit_cut"];
            secondImageView.image = [UIImage imageNamed:@"edit_highlight"];
            thirdImageView.image = [UIImage imageNamed:@"edit_draw_p"];
            
            firstLabel.textColor = garytextColor;
            secondLabel.textColor = garytextColor;
            thirdLabel.textColor = selectTextColor;
            break;
        default:
            firstGayeView.hidden = YES;
            secondGayeView.hidden = YES;
            thirdGayeView.hidden = YES;
            
            firstImageView.image = [UIImage imageNamed:@"edit_cut"];
            secondImageView.image = [UIImage imageNamed:@"edit_highlight"];
            thirdImageView.image = [UIImage imageNamed:@"edit_draw"];
            
            firstLabel.textColor = garytextColor;
            secondLabel.textColor = garytextColor;
            thirdLabel.textColor = garytextColor;
            break;
    }
}


-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    [self setViewColorWithTag:tag];
    if (tag == 0)
    {
        [self showByCutButtonClick];
        [self CutButtonClick];
    }
    else if (tag == 1)
    {
        [self showByHighLightButtonClick];
        [self HighLightButtonClick];
    }
    else if (tag == 2)
    {
        [self showByDoodelButtonClick];
        [self DoodelButtonClick];
    }
}

-(void)showByCutButtonClick
{
    [[controlView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(100*ScreenWidthRatio, 10*ScreenHeightRatio, ImageViewSize, ImageViewSize)];
    [resetButton setImage:[UIImage imageNamed:@"cancel_blue"] forState:UIControlStateNormal];
    [resetButton setImage:[UIImage imageNamed:@"cancel_blue_p"] forState:UIControlStateSelected];
    [resetButton addTarget:self action:@selector(ResetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:resetButton];
    
    UIButton *cutViewButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100*ScreenWidthRatio - ImageViewSize, 10*ScreenHeightRatio, ImageViewSize, ImageViewSize)];
    [cutViewButton setImage:[UIImage imageNamed:@"certain"] forState:UIControlStateNormal];
    [cutViewButton setImage:[UIImage imageNamed:@"certain_p"] forState:UIControlStateSelected];
    [cutViewButton addTarget:self action:@selector(CutViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cutViewButton];
}

-(void)showByHighLightButtonClick
{
    [[controlView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [imageArray removeAllObjects];
    int num = 4;
    imageArray = [[NSMutableArray alloc] initWithCapacity:num];
    color = 0;
    UIImageView *imageView;
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
    for (int i = 0; i < num; i++)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*ScreenWidthRatio + (ImageViewSize + 9*ScreenWidthRatio)*i, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize)];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tapGesturRecognizer];
        [imageArray addObject:imageView];
        [controlView addSubview:imageView];
    }
    //设置所有图片
    [self setHighLightViewImage:10];
    
    
    //设置分割线
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(143.5*2*ScreenWidthRatio, (EditFunctionViewHeight - 18*ScreenHeightRatio)/2, 2*ScreenWidthRatio, 18*ScreenHeightRatio)];
    mView.layer.borderWidth = 0.4;
    mView.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f] CGColor];
    [controlView addSubview:mView];
    
    //设置后退
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(mView.frame.origin.x + mView.frame.size.width + 9*ScreenWidthRatio, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize)];
    backImageView.image = [UIImage imageNamed:@"draw_undo"];
    backImageView.tag = 7;
    backImageView.userInteractionEnabled = YES;
    [backImageView addGestureRecognizer:tapGesturRecognizer];
    [controlView addSubview:backImageView];
    
    //设置前进
    goImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backImageView.frame.origin.x + backImageView.frame.size.width + 9*ScreenWidthRatio, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize)];
    goImageView.image = [UIImage imageNamed:@"draw_redo"];
    goImageView.tag = 8;
    goImageView.userInteractionEnabled = YES;
    [goImageView addGestureRecognizer:tapGesturRecognizer];
    [controlView addSubview:goImageView];
    
    
}

-(void)showByDoodelButtonClick
{
    [[controlView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [imageArray removeAllObjects];
    int num = 7;
    imageArray = [[NSMutableArray alloc] initWithCapacity:num];
    color = 0;
    UIImageView *imageView;
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
    for (int i = 0; i < num; i++)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*ScreenWidthRatio + (ImageViewSize + 9*ScreenWidthRatio)*i, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize)];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tapGesturRecognizer];
        [imageArray addObject:imageView];
        [controlView addSubview:imageView];
    }
    //设置所有图片
    [self setDoodelViewImage:10];
    
    
    //设置分割线
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(15*ScreenWidthRatio + (ImageViewSize + 9*ScreenWidthRatio)*num, (EditFunctionViewHeight - 18*ScreenHeightRatio)/2, 2*ScreenWidthRatio, 18*ScreenHeightRatio)];
    mView.layer.borderWidth = 0.4;
    mView.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f] CGColor];
    [controlView addSubview:mView];
    
    //设置后退
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(mView.frame.origin.x + mView.frame.size.width + 9*ScreenWidthRatio, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize)];
    backImageView.image = [UIImage imageNamed:@"draw_undo"];
    backImageView.tag = 7;
    backImageView.userInteractionEnabled = YES;
    [backImageView addGestureRecognizer:tapGesturRecognizer];
    [controlView addSubview:backImageView];
    
    //设置前进
    goImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backImageView.frame.origin.x + backImageView.frame.size.width + 9*ScreenWidthRatio, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize)];
    goImageView.image = [UIImage imageNamed:@"draw_redo"];
    goImageView.tag = 8;
    goImageView.userInteractionEnabled = YES;
    [goImageView addGestureRecognizer:tapGesturRecognizer];
    [controlView addSubview:goImageView];
    
    //设置颜色选择
    colorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(goImageView.frame.origin.x + goImageView.frame.size.width + 9*ScreenWidthRatio, (EditFunctionViewHeight - ImageViewSize)/2, ImageViewSize, ImageViewSize)];
    colorImageView.image = [UIImage imageNamed:@"draw_color_blue"];
    colorImageView.userInteractionEnabled = YES;
    goImageView.tag = 9;
    [colorImageView addGestureRecognizer:tapGesturRecognizer];
    [controlView addSubview:colorImageView];
}

-(void)imageViewAction:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    switch (tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            [self setDoodelViewImage:tag];
            break;
        case 7:
            break;
        case 8:
            break;
        case 9:
            break;
        default:
            break;
    }
}

-(void)setDoodelViewImage:(NSInteger)tag
{
    color = 2;
    UIImageView *imageView;
    for (int i = 0; i < [imageArray count]; i++)
    {
        imageView = [imageArray objectAtIndex:i];
        NSInteger imageViewTag = imageView.tag;
        NSString *imageName;
        switch (imageViewTag) {
            case 0:
                imageName = @"draw_square";
                break;
            case 1:
                imageName = @"draw_circle";
                break;
            case 2:
                imageName = @"draw_line";
                break;
            case 3:
                imageName = @"draw_narrow";
                break;
            case 4:
                imageName = @"draw_mosaic";
                break;
            case 5:
                imageName = @"draw_text";
                break;
            case 6:
                imageName = @"draw_tag";
                break;
            
            default:
                break;
        }
        
        if (tag == imageViewTag)
        {
            switch (color) {
                case 1:
                    imageName = [imageName stringByAppendingString:@"_bule"];
                    break;
                case 2:
                    imageName = [imageName stringByAppendingString:@"_red"];
                    break;
                case 3:
                    imageName = [imageName stringByAppendingString:@"_yellow"];
                    break;
                default:
                    break;
            }
        }

        imageView.image = [UIImage imageNamed:imageName];
    }
    
}


-(void)setHighLightViewImage:(NSInteger)tag
{
    UIImageView *imageView;
    for (int i = 0; i < [imageArray count]; i++)
    {
        imageView = [imageArray objectAtIndex:i];
        NSInteger imageViewTag = imageView.tag;
        NSString *imageName;
        switch (imageViewTag) {
            case 0:
                imageName = @"draw_rectangle";
                break;
            case 1:
                imageName = @"draw_trail";
                break;
            case 2:
                imageName = @"draw_square";
                break;
            case 3:
                imageName = @"draw_circle";
                break;
            default:
                break;
        }
        
        if (tag == imageViewTag)
        {
            imageName = [imageName stringByAppendingString:@"_p"];
        }
        imageView.image = [UIImage imageNamed:imageName];
    }
}








-(void)CutButtonClick
{
    if ([self.delegate respondsToSelector:@selector(CutButtonClick)]) {
        [self.delegate CutButtonClick];
    }
}
-(void)HighLightButtonClick
{
    if ([self.delegate respondsToSelector:@selector(HighLightButtonClick)]) {
        [self.delegate HighLightButtonClick];
    }
}
-(void)DoodelButtonClick
{
    if ([self.delegate respondsToSelector:@selector(DoodelButtonClick)]) {
        [self.delegate DoodelButtonClick];
    }
}

-(void)CancelButtonClick
{
    if ([self.delegate respondsToSelector:@selector(CancelButtonClick)]) {
        [self.delegate CancelButtonClick];
    }
}

-(void)ConfirmButtonClick
{
    if ([self.delegate respondsToSelector:@selector(ConfirmButtonClick)]) {
        [self.delegate ConfirmButtonClick];
    }
}


-(void)ResetButtonClick
{
    if ([self.delegate respondsToSelector:@selector(ResetButtonClick)]) {
        [self.delegate ResetButtonClick];
    }
}

-(void)CutViewButtonClick
{
    [[controlView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([self.delegate respondsToSelector:@selector(CutViewButtonClick)]) {
        [self.delegate CutViewButtonClick];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
