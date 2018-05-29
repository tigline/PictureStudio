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

+(void)CombinePictures:(NSArray *)images complete:(CombineCompletely)state success:(ScrollSuccess)success
{
    BOOL isSuccess = YES;
    Mat imageUpOrigin;                      //上部原始图片
    Mat imageDownOrigin;                    //下部原始图片
    Mat imageUpCut;                         //截取上部图片需要匹配的区域
    Mat imageDownCut;                       //截取下部图片需要匹配的区域
    Mat previewMat;                         //前一次匹配的结果
    Mat resultMat;                          //最终匹配的结果
    float curUseHeight = 0;
 
    CGFloat cutLeftX = 0.22f;
    CGFloat cutRightX = 0.75f;
    
    clock_t start_surf = clock();
    //依次拼接图片 （需要完善每张图片模型的信息）
    for (int i = 0; i < images.count-1; i++) {
        
        if (resultMat.data == NULL) {
            NSLog(@"resultMat.data == NULL");
            imageUpOrigin = [self cvMatFromUIImage:[images objectAtIndex:i]];
            //路径读取图片暂不使用
            //NSString *path = [images objectAtIndex:i];
            //imageUpCut = imread([path UTF8String]);
            
            imageUpCut = imageUpOrigin(cv::Rect(cv::Point(imageUpOrigin.cols*cutLeftX,kNavigationBarHeight*2),cv::Point(imageUpOrigin.cols*cutRightX,imageUpOrigin.rows)));
            curUseHeight = imageUpCut.rows;
        } else {
            previewMat = resultMat;
            imageUpCut = resultMat(cv::Rect(cv::Point(resultMat.cols*cutLeftX,resultMat.rows-curUseHeight),cv::Point(resultMat.cols*cutRightX,resultMat.rows)));
        }
        
        if (i + 1 < images.count) {

            imageDownOrigin = [self cvMatFromUIImage:[images objectAtIndex:i+1]];
            //路径读取图片暂不使用
            //NSString *path = [images objectAtIndex:i+1];
            //imageDownOrigin = imread([path UTF8String]);
        }
        
        imageDownCut = imageDownOrigin(cv::Rect(cv::Point(imageDownOrigin.cols*cutLeftX,0),cv::Point(imageDownOrigin.cols*cutRightX,imageDownOrigin.rows)));
        
        //灰度图转换
        Mat imageUpGray,imageDownGray;
        cvtColor(imageUpCut,imageUpGray,CV_RGB2GRAY);
        cvtColor(imageDownCut,imageDownGray,CV_RGB2GRAY);
        
        
        vector<DMatch> good_matchesX;
        vector<DMatch> good_matches;
        vector<KeyPoint> keyPoint_Up,keyPoint_Down;
 
        //int *keyPoint_Up_p = 0;
        //keyPoint_Up_p = keyPoint_Up;

        //默认识别
        good_matchesX = dectectMatchPoints(&keyPoint_Up, &keyPoint_Down, imageUpGray, imageDownGray, NO, 12000, YES);
        
//        Mat img_matches;
//        drawMatches(imageUpGray, keyPoint_Up, imageDownGray, keyPoint_Down,
//                    good_matchesX, img_matches, Scalar::all(-1), Scalar::all(-1),
//                    vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
//        UIImage *imageGoodMatchPoints = [self imageWithCVMat:img_matches];
        
        
        
        //无X轴匹配点则判定为无重合 直接拼接  该处逻辑需要完善：先用快速法 再用精确法 或者调整海塞矩阵阈值 也可改变匹配区域。
        if(good_matchesX.size() <= 5) {

            
            good_matchesX = dectectMatchPoints(&keyPoint_Up, &keyPoint_Down, imageUpGray, imageDownGray, NO, 9000, NO);
            
//            drawMatches(imageUpGray, keyPoint_Up, imageDownGray, keyPoint_Down,
//                        good_matchesX, img_matches, Scalar::all(-1), Scalar::all(-1),
//                        vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
//            UIImage *imageGoodMatchPoints = [self imageWithCVMat:img_matches];
            if (good_matchesX.size() == 0) {
                
                good_matchesX = dectectMatchPoints(&keyPoint_Up, &keyPoint_Down, imageUpGray, imageDownGray, YES, 150, NO);
                
                if (good_matchesX.size() == 0) {
                    if (resultMat.data == NULL) {
                        resultMat = comMatC(imageUpOrigin, imageDownOrigin, resultMat);
                    } else {
                        resultMat = comMatC(resultMat, imageDownOrigin, resultMat);
                    }
                    
                    curUseHeight = imageDownCut.rows;
                    isSuccess = NO;
                    continue;
                }
                
            }
            
            
        }
        
        //针对 截图不准确造成X轴移位的再做处理
        if (good_matchesX.size() == 0) {
            resultMat = comMatC(imageUpOrigin, imageDownOrigin, resultMat);
            curUseHeight = imageDownCut.rows;
            isSuccess = NO;
            continue;
        }
        //寻找最大距离点 对于老司机的截图 有些问题。
        Point2f curPointU = keyPoint_Up[good_matchesX[0].queryIdx].pt;
        Point2f curPointD = keyPoint_Down[good_matchesX[0].trainIdx].pt;
        float maxDistance = curPointU.y - curPointD.y;

        int maxYIndex = 0;
        for (int i = 1; i < good_matchesX.size(); i++) {
            Point2f curPointU = keyPoint_Up[good_matchesX[i].queryIdx].pt;
            Point2f curPointD = keyPoint_Down[good_matchesX[i].trainIdx].pt;
            float curDistance = curPointU.y - curPointD.y;
            if (maxDistance < curDistance) {
                maxDistance = curDistance;
                maxYIndex = i;
            }

        }

        
        //获取图像1到图像2的投影映射矩阵，尺寸为3*3
//        Mat homo=findHomography(imagePoints1,imagePoints2,CV_RANSAC);
//        Mat adjustMat=(Mat_<double>(3,3)<<1.0,0,0,  0,1.0,imageUpCut.rows,  0,0,1.0);
//        Mat adjustHomo=adjustMat*homo;
        
        //获取最强配对点在原始图像和矩阵变换后图像上的对应位置，用于图像拼接点的定位 ,targetLinkPoint
        Point2f originalLinkPoint,basedImagePoint;

        originalLinkPoint=keyPoint_Up[good_matchesX[maxYIndex].queryIdx].pt;
        NSLog(@"originalLinkPoint x.y = %f / %f",originalLinkPoint.x, originalLinkPoint.y);

        basedImagePoint=keyPoint_Down[good_matchesX[maxYIndex].trainIdx].pt;
        NSLog(@"basedImagePoint x.y = %f / %f",basedImagePoint.x, basedImagePoint.y);
        
        //targetLinkPoint=getTransformPoint(originalLinkPoint,adjustHomo);
        //NSLog(@"targetLinkPointx.y = %f / %f",targetLinkPoint.x, targetLinkPoint.y);
        
        //前面已筛选 为所有匹配点X相等 所以此处已不需要。
        /*
        int index = 0;
        while (basedImagePoint.x != originalLinkPoint.x) {
            if (index < good_matchesX.size()) {
                index ++;
                originalLinkPoint=keyPoint_Up[good_matches[index].queryIdx].pt;
            }
            else
            {
                originalLinkPoint=keyPoint_Up[good_matches[0].queryIdx].pt;
                break;
            }
        }
        */
        //不匹配则直接衔接  需要记录是哪两张图片 此功能待完善
        CGFloat upPeMatchHeight = imageUpOrigin.rows - curUseHeight;
        if(basedImagePoint.y > originalLinkPoint.y + upPeMatchHeight) {
            
            
            if (resultMat.data == NULL) {
                resultMat = comMatC(imageUpOrigin, imageDownOrigin, resultMat);
            } else {
                resultMat = comMatC(resultMat, imageDownOrigin, resultMat);
            }
            curUseHeight = imageDownCut.rows;
            isSuccess = NO;
            continue;
            //先寻找匹配点内 符合条件的
//            vector<DMatch> final_matches;
//            for (int i = 1; i < good_matchesX.size(); i++) {
//                Point2f upPoint = keyPoint_Up[good_matchesX[i].queryIdx].pt;
//                Point2f downPoint = keyPoint_Down[good_matchesX[i].trainIdx].pt;
//                if (downPoint.y <= upPoint.y + 128) {
//                    final_matches.push_back(good_matchesX[i]);
//                }
//            }
//            //确实没有 拼接
//            if (final_matches.size() == 0) {
//                if (resultMat.data == NULL) {
//                    resultMat = comMatC(imageUpOrigin, imageDownOrigin, resultMat);
//                } else {
//                    resultMat = comMatC(resultMat, imageDownOrigin, resultMat);
//                }
//                curUseHeight = imageDownCut.rows;
//                continue;
//            }
//
//            Point2f curPoint0 = keyPoint_Down[final_matches[0].trainIdx].pt;
//            float minY = curPoint0.y;
//
//            int minYIndex = 0;
//            for (int i = 1; i < final_matches.size(); i++) {
//                Point2f curPoint = keyPoint_Down[final_matches[i].trainIdx].pt;
//                if (minY > curPoint.y) {
//                    minY = curPoint.y;
//                    minYIndex = i;
//                }
//
//            }
//            //找出距离最大的点
//            originalLinkPoint=keyPoint_Up[final_matches[minYIndex].queryIdx].pt;
//            NSLog(@"originalLinkPoint x.y = %f / %f",originalLinkPoint.x, originalLinkPoint.y);
//
//            basedImagePoint=keyPoint_Down[final_matches[minYIndex].trainIdx].pt;
//            NSLog(@"basedImagePoint x.y = %f / %f",basedImagePoint.x, basedImagePoint.y);

        }
        
        curUseHeight = imageDownCut.rows - basedImagePoint.y;
        
        Mat imageUpResult;
        if (i < 1) {
            imageUpResult = imageUpOrigin(cv::Rect(cv::Point(0,0), cv::Point(imageUpOrigin.cols, originalLinkPoint.y + kNavigationBarHeight*2)));
        } else {
            imageUpResult = previewMat(cv::Rect(cv::Point(0,0), cv::Point(imageUpOrigin.cols, resultMat.rows - imageUpCut.rows + originalLinkPoint.y)));
        }
        //UIImage *cutImage1 = [self imageWithCVMat:imageUpResult];
        
        Mat imageDownResult=imageDownOrigin(cv::Rect(cv::Point(0,basedImagePoint.y),cv::Point(imageDownOrigin.cols,imageDownOrigin.rows)));
        //UIImage *imageTransform01 = [self imageWithCVMat:imageDownResult];
        
        //Mat resultMat;
        resultMat = comMatC(imageUpResult, imageDownResult, resultMat);
        if (resultMat.rows < imageDownOrigin.rows) {
            resultMat = comMatC(imageUpOrigin, imageDownOrigin, resultMat);
            curUseHeight = imageDownCut.rows;
            continue;
        }
        
        //UIImage *imageTransform011 = [self imageWithCVMat:resultMat];

    }
    UIImage *combineImage = [self imageWithCVMat:resultMat];
    clock_t end_surf = clock();
    double totaltime_surf;
    totaltime_surf = (double)(end_surf - start_surf)/CLOCKS_PER_SEC;
    cout<<"拼接运行时间："<<totaltime_surf<<"秒！"<<endl;
    
    success(isSuccess);
    state(combineImage);
    
}

vector<DMatch> dectectMatchPoints(vector<KeyPoint> *keyPoint_Up, vector<KeyPoint> *keyPoint_Down, Mat imageUpGray, Mat imageDownGray, bool isFast, int detectValue, bool isGoodX) {
    
    clock_t start_surf = clock();
    double totaltime_initPicture;
    float cutHeight = imageDownGray.rows - imageUpGray.rows;
    
    Mat imageDesc_Up,imageDesc_Down;
    vector<DMatch> matchePoints;
    vector<DMatch> good_matches;
    
//    clock_t sift_picture = clock();
//    totaltime_initPicture = (double)(sift_picture - start_surf)/CLOCKS_PER_SEC;
//    cout<<"提取特征点："<<totaltime_initPicture<<"秒！"<<endl;
    
    if (isFast) {
        FastFeatureDetector detector(detectValue);
        detector.detect(imageUpGray,*keyPoint_Up);
        detector.detect(imageDownGray,*keyPoint_Down);
        
        OrbDescriptorExtractor descriptor;
        descriptor.compute(imageUpGray,*keyPoint_Up,imageDesc_Up);
        descriptor.compute(imageDownGray,*keyPoint_Down,imageDesc_Down);
        
        BFMatcher matchers; //强制匹配 用于快速法
        matchers.match(imageDesc_Up,imageDesc_Down,matchePoints,Mat());
        
    } else {
        //提取特征点 最耗时操作一
        SurfFeatureDetector detector(detectValue);
        detector.detect(imageUpGray,*keyPoint_Up);
        detector.detect(imageDownGray,*keyPoint_Down);
        
        //特征点描述，为下边的特征点匹配做准备  #最耗时操作二
        SurfDescriptorExtractor descriptor;
        descriptor.compute(imageUpGray,*keyPoint_Up,imageDesc_Up);
        descriptor.compute(imageDownGray,*keyPoint_Down,imageDesc_Down);
        
        //获得匹配特征点，并提取最优配对
        FlannBasedMatcher matchers;
        matchers.match(imageDesc_Up,imageDesc_Down,matchePoints,Mat());
    }


    
    clock_t siftd_picture = clock();
    totaltime_initPicture = (double)(siftd_picture - start_surf)/CLOCKS_PER_SEC;
    cout<<"特征点描述，为下边的特征点匹配做准备："<<totaltime_initPicture<<"秒！"<<endl;
    
//    double max_dist = 0; double min_dist = 100;
//    //-- Quick calculation of max and min distances between keypoints
//    for( int i = 0; i < imageDesc_Up.rows; i++ )
//    { double dist = matchePoints[i].distance;
//        if( dist < min_dist ) min_dist = dist;
//        if( dist > max_dist ) max_dist = dist;
//    }
//    printf("-- Max dist : %f \n", max_dist );
//    printf("-- Min dist : %f \n", min_dist );
//    //-- Draw only "good" matches (i.e. whose distance is less than 2*min_dist,
//    //-- or a small arbitary value ( 0.02 ) in the event that min_dist is very
//    //-- small)
//    //-- PS.- radiusMatch can also be used here.
//    for( int i = 0; i < imageDesc_Up.rows; i++ )
//    {
//        if( matchePoints[i].distance <= max(2*min_dist, 0.02) ) {
//            good_matches.push_back( matchePoints[i]);
//        }
//    }
    sort(matchePoints.begin(),matchePoints.end()); //特征点排序
    
    //获取排在前N个的最优匹配特征点
    //vector<Point2f> imagePoints1,imagePoints2;
    long usefullCount; //选取需要的匹配点
    if (matchePoints.size() < 100) {
        usefullCount = matchePoints.size();
    } else {
        usefullCount = 100;
    }
    std::vector< DMatch > good_matchesX;
    for(int i=0;i<usefullCount;i++)
    {
        Point2f tempPoint1 = (*keyPoint_Up)[matchePoints[i].queryIdx].pt;
        Point2f tempPoint2 = (*keyPoint_Down)[matchePoints[i].trainIdx].pt;
        if ((tempPoint1.x >= tempPoint2.x - 1 && tempPoint1.x <= tempPoint2.x + 1) &&
            ((tempPoint1.y <= tempPoint2.y -cutHeight -1) ||
                                               (tempPoint1.y >= tempPoint2.y -cutHeight+1))) {
            good_matchesX.push_back(matchePoints[i]);
        }
    }
    
//    Mat img_matches;
//    drawMatches(imageUpGray, *keyPoint_Up, imageDownGray, *keyPoint_Down,
//                matchePoints, img_matches, Scalar::all(-1), Scalar::all(-1),
//                vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
    
//    NSData *data = [NSData dataWithBytes:img_matches.data length:img_matches.elemSize() * img_matches.total()];
//    CGColorSpaceRef colorSpace;
//    if (img_matches.elemSize() == 1) {
//        colorSpace = CGColorSpaceCreateDeviceGray();
//    } else {
//        colorSpace = CGColorSpaceCreateDeviceRGB();
//    }
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
//    // Creating CGImage from cv::Mat
//    CGImageRef imageRef = CGImageCreate(img_matches.cols,                                 //width
//                                        img_matches.rows,                                 //height
//                                        8,                                          //bits per component
//                                        8 * img_matches.elemSize(),                       //bits per pixel
//                                        img_matches.step[0],                              //bytesPerRow
//                                        colorSpace,                                 //colorspace
//                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
//                                        provider,                                   //CGDataProviderRef
//                                        NULL,                                       //decode
//                                        false,                                      //should interpolate
//                                        kCGRenderingIntentDefault                   //intent
//                                        );
//
//    UIImage *cvImage = [[UIImage alloc]initWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    CGDataProviderRelease(provider);
//    CGColorSpaceRelease(colorSpace);
//
//    if (good_matchesX.size() == 0&&isGoodX) {
//        good_matchesX = dectectMatchPoints(keyPoint_Up, keyPoint_Down, imageUpGray, imageDownGray, isFast, 8000, NO);
//    }
//    if (good_matchesX.size() < 5) {
//        return matchePoints;
//    }
    
    //if (isGoodX) {
        return good_matchesX;
    //}
    
    //return matchePoints;
}

Mat comMatC(Mat Matrix1,Mat Matrix2,Mat &MatrixCom)  //需要处理列数不同的状况
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

