//
//  JointPicture.m
//  PictureStudio
//
//  Created by Aaron Hou on 24/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "CombinePicture.h"
#include "opencv2/opencv.hpp"
#include "opencv2/nonfree/nonfree.hpp"
#include "opencv2/legacy/legacy.hpp"
#include <vector>
#include <iostream>

using namespace cv;
using namespace std;

@implementation CombinePicture

//计算原始图像点位在经过矩阵变换后在目标图像上对应位置
Point2f getTransformPoint(const Point2f originalPoint,const Mat &transformMaxtri);

+(void)CombinePictures:(NSArray *)images complete:(CombineCompletely)state
{

    Mat imageTransform1;
    Mat image01;
    Mat image002;
    Mat resultMat;
    clock_t start_surf = clock();
    for (int i = 0; i < images.count-1; i++) {
        
        if (resultMat.data == NULL) {
            NSLog(@"imageTransform1.data == NULL");
            image01 = [self cvMatFromUIImage:[images objectAtIndex:i]];
            //路径读取图片暂不使用
//            NSString *path = [images objectAtIndex:i];
//            image01 = imread([path UTF8String]);
        } else {
            image01 = resultMat;
            
        }
        if (i + 1 < images.count) {
            image002 = [self cvMatFromUIImage:[images objectAtIndex:i+1]];
            //路径读取图片暂不使用
//            NSString *path = [images objectAtIndex:i+1];
//            image002 = imread([path UTF8String]);
        }
        
        
        Mat image02=image002(cv::Rect(cv::Point(0,128),cv::Point(image002.cols,image002.rows)));
        //灰度图转换
        Mat image1,image2;
        cvtColor(image01,image1,CV_RGB2GRAY);
        cvtColor(image02,image2,CV_RGB2GRAY);
        
        
//        ORB orb;
//        vector<KeyPoint> keyPoints_1, keyPoints_2;
//        Mat descriptors_1, descriptors_2;
//
//        orb(image1, Mat(), keyPoints_1, descriptors_1);
//        orb(image2, Mat(), keyPoints_2, descriptors_2);
//
//        BruteForceMatcher<HammingLUT> matcher;
//        vector<DMatch> matches;
//        matcher.match(descriptors_1, descriptors_2, matches);
//
//        double max_dist = 0; double min_dist = 100;
//        //-- Quick calculation of max and min distances between keypoints
//        for( int i = 0; i < descriptors_1.cols; i++ )
//        {
//            double dist = matches[i].distance;
//            if( dist < min_dist ) min_dist = dist;
//            if( dist > max_dist ) max_dist = dist;
//        }
//        printf("-- Max dist : %f \n", max_dist );
//        printf("-- Min dist : %f \n", min_dist );
//        //-- Draw only "good" matches (i.e. whose distance is less than 0.6*max_dist )
//        //-- PS.- radiusMatch can also be used here.
//        std::vector< DMatch > good_matches;
//        for( int i = 0; i < descriptors_1.cols; i++ )
//        {
//            if( matches[i].distance < 0.6*max_dist )
//            {
//                good_matches.push_back( matches[i]);
//            }
//        }
        
        //cout<<"ORB："<<totaltime_initPicture<<"秒！"<<endl;
        
        //提取特征点

        
        //SiftFeatureDetector siftDetector(100);  // 海塞矩阵阈值  #最耗时操作一
        FastFeatureDetector siftDetector(170);

        vector<KeyPoint> keyPoint1,keyPoint2;
        siftDetector.detect(image1,keyPoint1);
        siftDetector.detect(image2,keyPoint2);
        
        double totaltime_initPicture;
        clock_t sift_picture = clock();
        totaltime_initPicture = (double)(sift_picture - start_surf)/CLOCKS_PER_SEC;
        cout<<"提取特征点："<<totaltime_initPicture<<"秒！"<<endl;
        
        //特征点描述，为下边的特征点匹配做准备  #最耗时操作二
        //SiftDescriptorExtractor siftDescriptor;

        OrbDescriptorExtractor siftDescriptor;

        Mat imageDesc1,imageDesc2;
        siftDescriptor.compute(image1,keyPoint1,imageDesc1);
        siftDescriptor.compute(image2,keyPoint2,imageDesc2);
        
        clock_t siftd_picture = clock();
        totaltime_initPicture = (double)(siftd_picture - start_surf)/CLOCKS_PER_SEC;
        cout<<"特征点描述，为下边的特征点匹配做准备："<<totaltime_initPicture<<"秒！"<<endl;
        
        //获得匹配特征点，并提取最优配对

        //FlannBasedMatcher matcher;
        BFMatcher matcher;

        vector<DMatch> matchePoints;
        matcher.match(imageDesc1,imageDesc2,matchePoints,Mat());
        sort(matchePoints.begin(),matchePoints.end()); //特征点排序
        

        //获取排在前N个的最优匹配特征点
        vector<Point2f> imagePoints1,imagePoints2;
        long pointCount = 0;
        if (matchePoints.size() > 100) {
            pointCount = 100;
        } else {
            pointCount = matchePoints.size();
        }
        
        for(int i=0;i<pointCount;i++)
        {
            imagePoints1.push_back(keyPoint1[matchePoints[i].queryIdx].pt);
            imagePoints2.push_back(keyPoint2[matchePoints[i].trainIdx].pt);
        }

        //获取图像1到图像2的投影映射矩阵，尺寸为3*3
        Mat homo=findHomography(imagePoints1,imagePoints2,CV_RANSAC);

        Mat adjustMat=(Mat_<double>(3,3)<<1.0,0,0,  0,1.0,image01.rows,  0,0,1.0);

        Mat adjustHomo=adjustMat*homo;

        
        //获取最强配对点在原始图像和矩阵变换后图像上的对应位置，用于图像拼接点的定位
        Point2f originalLinkPoint,targetLinkPoint,basedImagePoint;
        
    
        
        originalLinkPoint=keyPoint1[matchePoints[0].queryIdx].pt;
        
        NSLog(@"originalLinkPointx.y = %f / %f",originalLinkPoint.x, originalLinkPoint.y);
        
        targetLinkPoint=getTransformPoint(originalLinkPoint,adjustHomo);
        NSLog(@"targetLinkPointx.y = %f / %f",targetLinkPoint.x, targetLinkPoint.y);
        
        basedImagePoint=keyPoint2[matchePoints[0].trainIdx].pt;
        NSLog(@"basedImagePointx.y = %f / %f",basedImagePoint.x, basedImagePoint.y);
        int index = 0;
        while (basedImagePoint.x != originalLinkPoint.x) {
            if (index < 10) {
                index ++;
                originalLinkPoint=keyPoint1[matchePoints[index].queryIdx].pt;
            }
            else
            {
                originalLinkPoint=keyPoint1[matchePoints[0].queryIdx].pt;
                break;
            }
        }
        
        
        //Mat imageTransform;
        //图像配准

//        warpPerspective(image01,imageTransform1,adjustMat*homo,cv::Size(image02.cols,image01.rows+image02.rows));
//        if(basedImagePoint.y > originalLinkPoint.y) {
//            resultMat = comMatC(image01, image002, resultMat);
//            continue;
//        }
//        UIImage *imageTransform06 = [self imageWithCVMat:imageTransform1];
//        Mat image1Overlap, image2Overlap; //图1和图2的重叠部分
//       // image1Overlap = image01(cv::Rect(cv::Point(0, originalLinkPoint.y - basedImagePoint.y), cv::Point(image01.cols, originalLinkPoint.y)));
//        image1Overlap = imageTransform1(cv::Rect(cv::Point(0, targetLinkPoint.y - basedImagePoint.y), cv::Point(image02.cols, targetLinkPoint.y)));
//        UIImage *imageTransform04 = [self imageWithCVMat:image1Overlap];
//        image2Overlap = image02(cv::Rect(0, 0, image1Overlap.cols, image1Overlap.rows));
//
//        Mat image1ROICopy = image1Overlap.clone();  //复制一份图1的重叠部分
//        UIImage *imageTransform05 = [self imageWithCVMat:image2Overlap];

//        for (int j = 0; j<image1Overlap.cols; j++)
//        {
//            for (int i = 0; i<image1Overlap.rows; i++)
//            {
//                double height;
//                height = (double)j / image1Overlap.rows;  //随距离改变而改变的叠加系数
//                image1Overlap.at<Vec3b>(i, j)[0] = (1 - height)*image1ROICopy.at<Vec3b>(i, j)[0] + height*image2Overlap.at<Vec3b>(i, j)[0];
//                image1Overlap.at<Vec3b>(i, j)[1] = (1 - height)*image1ROICopy.at<Vec3b>(i, j)[1] + height*image2Overlap.at<Vec3b>(i, j)[1];
//                image1Overlap.at<Vec3b>(i, j)[2] = (1 - height)*image1ROICopy.at<Vec3b>(i, j)[2] + height*image2Overlap.at<Vec3b>(i, j)[2];
//            }
//        }
        //在最强匹配点的位置处衔接，最强匹配点上侧是图1，下侧是图2，这样直接替换图像衔接不好，光线有突变
        //不重合的部分
        //UIImage *imageTransform03 = [self imageWithCVMat:image1Overlap];
        //Mat cutImage01 = image01(cv::Rect(cv::Point(0,0), cv::Point(image01.cols, image01.rows - basedImagePoint.y - 79)));
        Mat cutImage01 = image01(cv::Rect(cv::Point(0,0), cv::Point(image01.cols, originalLinkPoint.y)));
        UIImage *cutImage1 = [self imageWithCVMat:cutImage01];
        Mat ROIMat=image02(cv::Rect(cv::Point(0,basedImagePoint.y),cv::Point(image02.cols,image02.rows)));
        UIImage *imageTransform01 = [self imageWithCVMat:ROIMat];
        
        //Mat resultMat;
        resultMat = comMatC(cutImage01, ROIMat, resultMat);
//        UIImage *imageTransform011 = [self imageWithCVMat:resultMat];
//
//
//        //不重合的部分直接衔接上去
//        ROIMat.copyTo(Mat(cutImage01,cv::Rect(0,targetLinkPoint.y,image02.cols,ROIMat.rows)));
//        UIImage *imageTransform02 = [self imageWithCVMat:ROIMat];
//        resultMat = imageTransform1(cv::Rect(cv::Point(0,image01.rows-originalLinkPoint.y+basedImagePoint.y),cv::Point(imageTransform1.cols,imageTransform1.rows)));
    }
    UIImage *imageTransform03 = [self imageWithCVMat:resultMat];
    
    clock_t end_surf = clock();
    double totaltime_surf;
    totaltime_surf = (double)(end_surf - start_surf)/CLOCKS_PER_SEC;
    cout<<"常规程序的运行时间："<<totaltime_surf<<"秒！"<<endl;
    //return [self imageWithCVMat:imageTransform1];
    state(imageTransform03);
    
}

Mat comMatC(Mat Matrix1,Mat Matrix2,Mat &MatrixCom)
{
    CV_Assert(Matrix1.cols==Matrix2.cols);//列数不相等，出现错误中断
    MatrixCom.create(Matrix1.rows+Matrix2.rows,Matrix1.cols,Matrix1.type());
    Mat temp=MatrixCom.rowRange(0,Matrix1.rows);
    Matrix1.copyTo(temp);
    Mat temp1=MatrixCom.rowRange(Matrix1.rows,Matrix1.rows+Matrix2.rows);
    Matrix2.copyTo(temp1);
    return MatrixCom;
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

