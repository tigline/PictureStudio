//
//  CombineIndicatorView.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/4/16.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "CombineIndicatorView.h"


@implementation CombineIndicatorView
@synthesize visible;

-(id)initWithFrame:(CGRect)frame superView:(UIView*)superView{
    
    rectOrigin=frame;
    
    rectSuper=[superView bounds];
    
    //保持正方形比例
    
    rectHud=CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, frame.size.width);
    
    self = [super initWithFrame:rectHud];
    
    if (self) {
        
        self.backgroundColor =[UIColor clearColor];
        
        self.opaque = NO;
        
        viewHud=[[UIView alloc]initWithFrame:rectHud];
        
        [self addSubview:viewHud];
        
        indicator=[[UIActivityIndicatorView alloc]
                   
                   initWithActivityIndicatorStyle:
                   
                   UIActivityIndicatorViewStyleWhiteLarge];
        
        double gridUnit=round(rectHud.size.width/12);
        
        float ind_width=6*gridUnit;
        
        indicator.frame=CGRectMake(
                                   
                                   3*gridUnit,
                                   
                                   2*gridUnit,
                                   
                                   ind_width,
                                   
                                   ind_width);
        
        [viewHud addSubview:indicator];
        
        CGRect rectLabel=CGRectMake(1*gridUnit,
                                    
                                    9*gridUnit,
                                    
                                    10*gridUnit, 2*gridUnit);
        
        label=[[UILabel alloc]initWithFrame:rectLabel];
        
        label.backgroundColor=[UIColor clearColor];
        
        label.font=[UIFont fontWithName:@"Arial" size:14];
        
        label.textAlignment=UITextAlignmentCenter;
        
        label.textColor=[UIColor whiteColor];
        
        label.text=@"请等待...";
        
        label.adjustsFontSizeToFitWidth=YES;
        
        [viewHud addSubview:label];
        
        visible=NO;
        
        [self setHidden:YES];
        
        [superView addSubview:self];
        
    }
    
    return self;
    
}

#pragma mark -

#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    
    if(visible){
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect boxRect = rectHud;
        
        // 绘制圆角矩形
        
        float radius = 10.0f;
        
        // 路径开始
        
        CGContextBeginPath(context);
        
        // 填充色：灰度0.0，透明度:0.1
        
        CGContextSetGrayFillColor(context,0.0f, 0.25);
        
        // 画笔移动到左上角的圆弧处
        
        CGContextMoveToPoint(context,CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
        
        // 开始绘制右上角圆弧：圆心x坐标，圆心y坐标，起始角，终止角，方向为顺时针
        
        CGContextAddArc(context,CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
        
        // 开始绘制右下角圆弧
        
        CGContextAddArc(context,CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
        
        // 开始绘制左下角圆弧
        
        CGContextAddArc(context,CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
        
        // 开始绘制左上角圆弧
        
        CGContextAddArc(context,CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
        
        //  CGContextClosePath(context);// 关闭路径
        
        CGContextFillPath(context);// 填充路径,该函数自动关闭路径
        
    }
    
}

#pragma mark -

-(void)dealloc{
    
    [maskView release];
    
    [indicator release];
    
    [label release];
    
    [super dealloc];
    
}

#pragma mark Action

-(void)show:(BOOL)block{
    
    if (block && blocked==NO) {
        
        CGPoint offset=self.frame.origin;
        
        // 改变视图大小为父视图大小
        
        self.frame=rectSuper;
        
        viewHud.frame=CGRectOffset(viewHud.frame, offset.x, offset.y);
        
        if (maskView==nil) {
            
            maskView=[[UIView alloc]initWithFrame:rectSuper];
            
        }else{
            
            maskView.frame=rectSuper;
            
        }
        
        maskView.backgroundColor=[UIColor lightGrayColor];
        
        [self addSubview:maskView];
        
        [self bringSubviewToFront:maskView];
        
        blocked=YES;
        
    }
    
    [indicator startAnimating];
    
    [self setHidden:NO];
    
    [self setNeedsLayout];
    
    visible=YES;
    
}

-(void)hide{
    
    visible=NO;
    
    [indicator stopAnimating];
    
    [self setHidden:YES];
    
}

-(void)setMessage:(NSString*)newMsg{
    
    label.text=newMsg;
    
}

-(void)alignToCenter{
    
    CGPoint centerSuper={rectSuper.size.width/2,rectSuper.size.height/2};
    
    CGPoint centerSelf={self.frame.origin.x+self.frame.size.width/2,
        
        self.frame.origin.y+self.frame.size.height/2};
    
    CGPoint offset={centerSuper.x-centerSelf.x,centerSuper.y-centerSelf.y};
    
    CGRect newRect=CGRectOffset(self.frame, offset.x, offset.y);
    
    [self setFrame:newRect];
    
    rectHud=newRect;
    
    // NSLog(@"newRect:%f,%f",newRect.origin.x,newRect.origin.y);
    
}

@end





/*



@interface RootVC :UIViewController {
    
    MyProgressView* indicator;
    
}

-(IBAction)btnClicked;

@end

#import "RootVC.h"



@implementation RootVC

-(IBAction)btnClicked{
    
    NSLog(@"%s",__FUNCTION__);
    
    if (indicator.visible==NO) {
        
        [indicator show:NO];
        
    }else {
        
        [indicator hide];
        
    }
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNilbundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    indicator=[[MyProgressView alloc]initWithFrame:
               
               CGRectMake(0, 0, 120, 120) superView:self.view];
    
    //[indicatoralignToCenter];
    
}



- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    // Release any retained subviews ofthe main view.
    
    // e.g. self.myOutlet = nil;
    
}



- (void)dealloc {
    
    [indicator release];
    
    [super dealloc];
    
}
*/




