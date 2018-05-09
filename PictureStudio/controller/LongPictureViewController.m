//
//  LongPictureViewController.m
//  PictureStudio
//
//  Created by Aaron Hou on 11/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "LongPictureViewController.h"

@interface LongPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *longPictureView;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *downView;

@property (strong, nonatomic)  UIImageView *upImageView;
@property (strong, nonatomic)  UIImageView *downImageView;

@property (assign, nonatomic) CGFloat touchOffsetUp;
@property (assign, nonatomic) CGFloat touchOffsetDown;
@property (assign, nonatomic) CGFloat beginPointY;


@end

@implementation LongPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.multipleTouchEnabled = NO;
    _upImageView.multipleTouchEnabled = NO;
    _upView.multipleTouchEnabled = NO;
    _downImageView.multipleTouchEnabled = NO;
    _downView.multipleTouchEnabled = NO;
    
    _upImageView = [[UIImageView alloc] initWithImage:[_imageArray objectAtIndex:0]];
    CGFloat width = SCREEN_W;
    CGFloat height = (width/_upImageView.image.size.width)*_upImageView.image.size.height;
    CGFloat originY = _upView.frame.size.height - height;
    _upImageView.frame = CGRectMake(0, originY, width, height);
    [_upView addSubview:_upImageView];
    
    
    
    _downImageView = [[UIImageView alloc] initWithImage:[_imageArray objectAtIndex:1]];
    height = (width/_downImageView.image.size.width)*_downImageView.image.size.height;
    _downImageView.frame = CGRectMake(0, 0, width, height);
    [_downView addSubview:_downImageView];
    
    // Do any additional setup after loading the view.
    
    /*
    if (_resultImage != nil ) {
        CGRect cgpos;
        if (_resultImage.size.width > _longPictureView.frame.size.width) {
            cgpos.origin.x = 0;
            cgpos.origin.y = 0;
            cgpos.size.width = _longPictureView.frame.size.width;
            cgpos.size.height = _resultImage.size.height * (_longPictureView.frame.size.width/_resultImage.size.width);
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, cgpos.size.height)];
        }else {
            cgpos.origin.x =(_longPictureView.frame.size.width - _resultImage.size.width)/2;
            cgpos.origin.y = 0;
            cgpos.size.width = _resultImage.size.width;
            cgpos.size.height = _resultImage.size.height;
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, _resultImage.size.height)];
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cgpos];
        [imageView setImage:_resultImage];
        [_longPictureView addSubview:imageView];
        [_longPictureView setUserInteractionEnabled:YES];
        UITapGestureRecognizer* imgMsgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnImage:)];
        [_longPictureView addGestureRecognizer:imgMsgTap];
        
    }
    */
}

-(void)touchOnImage:(UITapGestureRecognizer*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    CGPoint touchPoint;
//    for (UITouch *touch in touches) {
//
//        int x = [touch locationInView: [touch view]].x;
//        int y = [touch locationInView: [touch view]].y;
//
//        touchPoint = CGPointMake(x, y);
//    }
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    _beginPointY = touchPoint.y;
    //_touchOffsetUp = touchPoint.y;
    
    touchPoint = [_upView.layer convertPoint:touchPoint fromLayer:self.view.layer];
    if ([_upView.layer containsPoint:touchPoint]) {
        //NSLog(@"---upView---");
    } else {
        touchPoint = [_downView.layer convertPoint:touchPoint fromLayer:self.view.layer];
        if ([_downView.layer containsPoint:touchPoint]) {
            //NSLog(@"---downView---");
        }
    }
    

    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    _touchOffsetUp = touchPoint.y - _beginPointY;
    _beginPointY = touchPoint.y;
    NSLog(@"offset = %f", _touchOffsetUp);
    
    
    touchPoint = [_upView.layer convertPoint:touchPoint fromLayer:self.view.layer];
    if ([_upView.layer containsPoint:touchPoint]) {
        //NSLog(@"---upView---");
        CGFloat curY = _upImageView.frame.origin.y + _touchOffsetUp;
        _upImageView.frame = CGRectMake(0, curY, SCREEN_W, _upImageView.frame.size.height);
        
    } else {
        touchPoint = [_downView.layer convertPoint:touchPoint fromLayer:self.view.layer];
        if ([_downView.layer containsPoint:touchPoint]) {
            //NSLog(@"---downView---");
        }
    }
    
    
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

