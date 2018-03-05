//
//  JointPicture.m
//  PictureStudio
//
//  Created by Aaron Hou on 24/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "JointPicture.h"

#include "opencv2/nonfree/nonfree.hpp"
#include "opencv2/legacy/legacy.hpp"
#include <vector>
#include <iostream>

using namespace cv;
using namespace std;

@implementation JointPicture


//计算原始图像点位在经过矩阵变换后在目标图像上对应位置
Point2f getTransformPoint(const Point2f originalPoint,const Mat &transformMaxtri);

+(void)jointPictures:(NSArray *)images complete:(JointCompletely)state
{
    //_jointCompletelyBlock = state;
    
    //    NSString *path01 = [[images objectAtIndex:0] objectForKey:@"PHImageFileURLKey"];
    //    NSString *path02 = [[images objectAtIndex:1] objectForKey:@"PHImageFileURLKey"];
    //    UIImage *image = [UIImage imageWithContentsOfFile:path01];
    //    Mat image01=imread([path01 UTF8String]);
    //    Mat image02=imread([path02 UTF8String]);
    Mat imageTransform1;
    Mat image01;
    Mat image002;
    Mat resultMat;
    for (int i = 0; i < images.count-1; i++) {
        
        if (resultMat.data == NULL) {
            NSLog(@"imageTransform1.data == NULL");
            image01 = [self cvMatFromUIImage:[images objectAtIndex:i]];
        } else {
            image01 = resultMat;
            
        }
        if (i + 1 < images.count) {
            image002 = [self cvMatFromUIImage:[images objectAtIndex:i+1]];
        }
        
        
        
        //    image01 = [self cvMatFromUIImage:[images objectAtIndex:0]];
        //    image002 = [self cvMatFromUIImage:[images objectAtIndex:1]];
        
        
        Mat image02=image002(cv::Rect(cv::Point(0,100),cv::Point(image002.cols,image002.rows)));
        //灰度图转换
        Mat image1,image2;
        cvtColor(image01,image1,CV_RGB2GRAY);
        cvtColor(image02,image2,CV_RGB2GRAY);
        
        
        //提取特征点
        SiftFeatureDetector siftDetector(800);  // 海塞矩阵阈值
        vector<KeyPoint> keyPoint1,keyPoint2;
        siftDetector.detect(image1,keyPoint1);
        siftDetector.detect(image2,keyPoint2);
        
        //特征点描述，为下边的特征点匹配做准备
        SiftDescriptorExtractor siftDescriptor;
        Mat imageDesc1,imageDesc2;
        siftDescriptor.compute(image1,keyPoint1,imageDesc1);
        siftDescriptor.compute(image2,keyPoint2,imageDesc2);
        
        //获得匹配特征点，并提取最优配对
        FlannBasedMatcher matcher;
        vector<DMatch> matchePoints;
        matcher.match(imageDesc1,imageDesc2,matchePoints,Mat());
        sort(matchePoints.begin(),matchePoints.end()); //特征点排序
        //获取排在前N个的最优匹配特征点
        vector<Point2f> imagePoints1,imagePoints2;
        for(int i=0;i<10;i++)
        {
            imagePoints1.push_back(keyPoint1[matchePoints[i].queryIdx].pt);
            imagePoints2.push_back(keyPoint2[matchePoints[i].trainIdx].pt);
        }
        
        //获取图像1到图像2的投影映射矩阵，尺寸为3*3
        Mat homo=findHomography(imagePoints1,imagePoints2,CV_RANSAC);
        Mat adjustMat=(Mat_<double>(3,3)<<1.0,0,0,0,1.0,image01.rows,0,0,1.0);
        Mat adjustHomo=adjustMat*homo;
        
        //获取最强配对点在原始图像和矩阵变换后图像上的对应位置，用于图像拼接点的定位
        Point2f originalLinkPoint,targetLinkPoint,basedImagePoint;
        
        originalLinkPoint=keyPoint1[matchePoints[0].queryIdx].pt;
        
        targetLinkPoint=getTransformPoint(originalLinkPoint,adjustHomo);
        
        basedImagePoint=keyPoint2[matchePoints[0].trainIdx].pt;
        
        //图像配准
        
        warpPerspective(image01,imageTransform1,adjustMat*homo,cv::Size(image01.cols,image01.rows+image02.rows));
        //在最强匹配点的位置处衔接，最强匹配点上侧是图1，下侧是图2，这样直接替换图像衔接不好，光线有突变
        Mat ROIMat=image02(cv::Rect(cv::Point(0,basedImagePoint.y),cv::Point(image02.cols,image02.rows)));
        UIImage *imageTransform01 = [self imageWithCVMat:imageTransform1];
        ROIMat.copyTo(Mat(imageTransform1,cv::Rect(0,targetLinkPoint.y,image02.cols,image02.rows-basedImagePoint.y+1)));
        UIImage *imageTransform02 = [self imageWithCVMat:ROIMat];
        resultMat = imageTransform1(cv::Rect(cv::Point(0,image01.rows-originalLinkPoint.y+basedImagePoint.y),cv::Point(imageTransform1.cols,imageTransform1.rows)));
    }
    UIImage *imageTransform03 = [self imageWithCVMat:resultMat];
    //return [self imageWithCVMat:imageTransform1];
    state(imageTransform03);
    
}

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}



+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorSpace;
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                              //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    UIImage *cvImage = [[UIImage alloc]initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return cvImage;
}



//计算原始图像点位在经过矩阵变换后在目标图像上对应位置
Point2f getTransformPoint(const Point2f originalPoint,const Mat &transformMaxtri)
{
    Mat originelP,targetP;
    originelP=(Mat_<double>(3,1)<<originalPoint.x,originalPoint.y,1.0);
    targetP=transformMaxtri*originelP;
    float x=targetP.at<double>(0,0)/targetP.at<double>(2,0);
    float y=targetP.at<double>(1,0)/targetP.at<double>(2,0);
    return Point2f(x,y);
}

@end

