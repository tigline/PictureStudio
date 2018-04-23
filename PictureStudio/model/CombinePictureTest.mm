//
//  JointPicture.m
//  PictureStudio
//
//  Created by Aaron Hou on 24/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "CombinePictureTest.h"
#include "opencv2/opencv.hpp"
#include "opencv2/nonfree/nonfree.hpp"
#include "opencv2/legacy/legacy.hpp"
#include <vector>
#include <iostream>

using namespace cv;
using namespace std;

@implementation CombinePictureTest

//计算原始图像点位在经过矩阵变换后在目标图像上对应位置
Point2f getTransformPoint(const Point2f originalPoint,const Mat &transformMaxtri);

+(void)CombinePictures:(NSArray *)images complete:(CombineCompletely)state
{
    
    Mat imageTransform1;
    Mat tempImage;
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
            tempImage = resultMat;
            image01 = resultMat(cv::Rect(cv::Point(0,resultMat.rows-1344),cv::Point(image002.cols,resultMat.rows)));
            
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
        

        
        //提取特征点
        //OrbFeatureDetector siftDetector(100);
        //SiftFeatureDetector siftDetector(5000);  // 海塞矩阵阈值  #最耗时操作一
        //SurfFeatureDetector siftDetector(1000);
        //Ptr<FeatureDetector> siftDetector = FeatureDetector::create("SURF");
        FastFeatureDetector siftDetector(180);
        vector<KeyPoint> keyPoint1,keyPoint2;
        siftDetector.detect(image1,keyPoint1);
        siftDetector.detect(image2,keyPoint2);
        
        double totaltime_initPicture;
        clock_t sift_picture = clock();
        totaltime_initPicture = (double)(sift_picture - start_surf)/CLOCKS_PER_SEC;
        cout<<"提取特征点："<<totaltime_initPicture<<"秒！"<<endl;
        
        Mat img_keypoints_1; Mat img_keypoints_2;
        drawKeypoints( image1, keyPoint1, img_keypoints_1, Scalar::all(-1), DrawMatchesFlags::DEFAULT );
        drawKeypoints( image2, keyPoint2, img_keypoints_2, Scalar::all(-1), DrawMatchesFlags::DEFAULT );
        
        
        
        //特征点描述，为下边的特征点匹配做准备  #最耗时操作二
        //SiftDescriptorExtractor siftDescriptor;
        //Ptr<DescriptorExtractor> siftDescriptor = DescriptorExtractor::create("FAST");
        //cv::Ptr<cv::ORB> siftDescriptor = cv::ORB::create("ORB");
        //SurfDescriptorExtractor siftDescriptor;
        OrbDescriptorExtractor siftDescriptor;
        Mat imageDesc1,imageDesc2;
        siftDescriptor.compute(image1,keyPoint1,imageDesc1);
        siftDescriptor.compute(image2,keyPoint2,imageDesc2);
        
        clock_t siftd_picture = clock();
        totaltime_initPicture = (double)(siftd_picture - start_surf)/CLOCKS_PER_SEC;
        cout<<"特征点描述，为下边的特征点匹配做准备："<<totaltime_initPicture<<"秒！"<<endl;
        
        //获得匹配特征点，并提取最优配对
        //FlannBasedMatcher matchers;
        BFMatcher matchers;
        vector<DMatch> matchePoints;
        std::vector< DMatch > good_matches;
        //matchers.match(imageDesc1,imageDesc2,matchePoints);
        matchers.match(imageDesc1,imageDesc2,matchePoints,Mat());
        
        Mat img_matches;
        drawMatches( image1, keyPoint1, image2, keyPoint2,
                    matchePoints, img_matches, Scalar::all(-1), Scalar::all(-1),
                    vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
        
        UIImage *imageMatchPoints = [self imageWithCVMat:img_matches];
        
        sort(matchePoints.begin(),matchePoints.end()); //特征点排序
        //获取排在前N个的最优匹配特征点
        vector<Point2f> imagePoints1,imagePoints2;
        for(int i=0;i<100;i++)
        {
            Point2f tempPoint1 = keyPoint1[matchePoints[i].queryIdx].pt;
            Point2f tempPoint2 = keyPoint2[matchePoints[i].trainIdx].pt;
            if (tempPoint1.x == tempPoint2.x) {
                good_matches.push_back(matchePoints[i]);
            }
//            imagePoints1.push_back(keyPoint1[matchePoints[i].queryIdx].pt);
//            imagePoints2.push_back(keyPoint2[matchePoints[i].trainIdx].pt);
            
        }

        Point2f curPoint0 = keyPoint2[good_matches[0].trainIdx].pt;
        float minY = curPoint0.y;
        
        int minYIndex = 0;
        for (int i = 1; i < good_matches.size(); i++) {
            Point2f curPoint = keyPoint2[good_matches[i].trainIdx].pt;
            if (minY > curPoint.y) {
                minY = curPoint.y;
                minYIndex = i;
            }
            
        }
        
        
        /*
        //-- Quick calculation of max and min distances between keypoints
        double max_dist = 0; double min_dist = 100;
        for( int i = 0; i < imageDesc1.cols; i++ )
        {
            double dist = matchePoints[i].distance;
            if( dist < min_dist ) min_dist = dist;
            if( dist > max_dist ) max_dist = dist;
        }
        printf("-- Max dist : %f \n", max_dist );
        printf("-- Min dist : %f \n", min_dist );
        
        
        
        
        for( int i = 0; i < imageDesc1.cols; i++ )
        {
            if( matchePoints[i].distance <= max(2*min_dist, 0.02) )
            {
                good_matches.push_back( matchePoints[i]);
                
            }
        }
         */
        clock_t siftd_match = clock();
        totaltime_initPicture = (double)(siftd_match - start_surf)/CLOCKS_PER_SEC;
        cout<<"获得匹配特征点，并提取最优配对："<<totaltime_initPicture<<"秒！"<<endl;


        drawMatches( image1, keyPoint1, image2, keyPoint2,
                    good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
                    vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );

        
        UIImage *imageGoodMatchPoints = [self imageWithCVMat:img_matches];
        
        
        
        //获取图像1到图像2的投影映射矩阵，尺寸为3*3
//        Mat homo=findHomography(imagePoints1,imagePoints2,CV_RANSAC);
//
//        Mat adjustMat=(Mat_<double>(3,3)<<1.0,0,0,  0,1.0,image01.rows,  0,0,1.0);
//
//        Mat adjustHomo=adjustMat*homo;
        
        
        //获取最强配对点在原始图像和矩阵变换后图像上的对应位置，用于图像拼接点的定位
        Point2f originalLinkPoint,targetLinkPoint,basedImagePoint;
        
        
        
        originalLinkPoint=keyPoint1[good_matches[0].queryIdx].pt;
        NSLog(@"originalLinkPoint x.y = %f / %f",originalLinkPoint.x, originalLinkPoint.y);
        
        
//        targetLinkPoint=getTransformPoint(originalLinkPoint,adjustHomo);
//        NSLog(@"targetLinkPointx.y = %f / %f",targetLinkPoint.x, targetLinkPoint.y);
        
        basedImagePoint=keyPoint2[good_matches[minYIndex].trainIdx].pt;
        NSLog(@"basedImagePoint x.y = %f / %f",basedImagePoint.x, basedImagePoint.y);
        
        
        int index = 0;
        while (basedImagePoint.x != originalLinkPoint.x) {
            if (index < good_matches.size()) {
                index ++;
                originalLinkPoint=keyPoint1[good_matches[index].queryIdx].pt;
            }
            else
            {
                originalLinkPoint=keyPoint1[good_matches[0].queryIdx].pt;
                break;
            }
        }
        NSLog(@"final originalLinkPoint x.y = %f / %f",originalLinkPoint.x, originalLinkPoint.y);

        
        Mat cutImage01;
        if (i < 1) {
            cutImage01 = image01(cv::Rect(cv::Point(0,0), cv::Point(image01.cols, originalLinkPoint.y)));
        } else {
            cutImage01 = tempImage(cv::Rect(cv::Point(0,0), cv::Point(image01.cols, originalLinkPoint.y + resultMat.rows - 1344)));
        }
        
        //Mat cutImage01 = image01(cv::Rect(cv::Point(0,0), cv::Point(image01.cols, originalLinkPoint.y)));
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
