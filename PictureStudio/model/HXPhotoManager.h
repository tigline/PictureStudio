//
//  HX_PhotoManager.h
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "HXAlbumModel.h"
#import "HXPhotoModel.h"
#import "HXPhotoTools.h"
#import "HXPhotoConfiguration.h"
/**
 *  照片选择的管理类, 使用照片选择时必须先懒加载此类,然后赋值给对应的对象
 */
typedef enum : NSUInteger {
    HXPhotoManagerSelectedTypePhoto = 0,        // 只显示图片
    HXPhotoManagerSelectedTypeVideo = 1,        // 只显示视频
    HXPhotoManagerSelectedTypePhotoAndVideo     // 图片和视频一起显示
} HXPhotoManagerSelectedType;

@interface HXPhotoManager : NSObject

@property (assign, nonatomic) HXPhotoManagerSelectedType type;

/**
 @param type 选择类型
 @return self
 */
- (instancetype)initWithType:(HXPhotoManagerSelectedType)type;

/**
 配置信息
 */
@property (strong, nonatomic) HXPhotoConfiguration *configuration;

/**
 *  本地图片数组 <UIImage *> 装的是UIImage对象 - 已设置为选中状态
 */
@property (copy, nonatomic) NSArray *localImageList;

/**
 添加本地图片数组  内部会将  deleteTemporaryPhoto 设置为NO

 @param images <UIImage *> 装的是UIImage对象
 @param selected 是否选中  选中的话HXPhotoView自动添加显示 没选中可以在相册里手动选中
 */
- (void)addLocalImage:(NSArray *)images selected:(BOOL)selected;

/**
 将本地图片添加到相册中  内部会将  configuration.deleteTemporaryPhoto 设置为NO

 @param images <UIImage *> 装的是UIImage对象
 */
- (void)addLocalImageToAlbumWithImages:(NSArray *)images;

/**
 添加网络图片数组

 @param imageUrls 图片地址  NSString*
 @param selected 是否选中
 */
- (void)addNetworkingImageToAlbum:(NSArray<NSString *> *)imageUrls selected:(BOOL)selected;

/**
 相册列表
 */
@property (strong, nonatomic,readonly) NSMutableArray *albums;

/**
 网络图片地址数组
 */
@property (strong, nonatomic) NSArray<NSString *> *networkPhotoUrls;

@property (assign, nonatomic) BOOL isScrollSuccess;
@property (assign, nonatomic) BOOL isCombineVertical;

- (void)getAllPhotoAndCurrentAlbums:(void(^)(HXAlbumModel *currentAlbumModel))currentModel albums:(void(^)(NSArray *albums))albums AlbumName:(NSString *)AlbumName;
/**
 获取系统所有相册
 
 @param albums 相册集合
 */
- (void)getAllPhotoAlbums:(void(^)(HXAlbumModel *firstAlbumModel))firstModel albums:(void(^)(NSArray *albums))albums isFirst:(BOOL)isFirst;

/**
 根据某个相册模型获取照片列表

 @param albumModel 相册模型
 @param complete 照片列表和首个选中的模型
 */
- (void)getPhotoListWithAlbumModel:(HXAlbumModel *)albumModel complete:(void (^)(NSArray *allList , NSArray *previewList,NSArray *photoList ,NSArray *videoList ,NSArray *dateList , HXPhotoModel *firstSelectModel))complete;

- (int32_t)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

/**
 判断最大值
 */
- (NSString *)maximumOfJudgment:(HXPhotoModel *)model;

/**  关于选择完成之前的一些方法  **/
/**
 完成之前选择的总数量
 */
- (NSInteger)selectedCount;
/**
 完成之前选择的照片数量
 */
- (NSInteger)selectedPhotoCount;
/**
 完成之前选择的所有数组
 */
- (NSArray *)selectedArray;
/**
 完成之前选择的照片数组
 */
- (NSArray *)selectedPhotoArray;

- (BOOL)isAllScreenShotPhoto;
/**
 完成之前是否原图
 */
- (BOOL)original;
/**
 完成之前设置是否原图
 */
- (void)setOriginal:(BOOL)original;
/**
 完成之前的照片数组是否达到最大数
 @return yes or no
 */
- (BOOL)beforeSelectPhotoCountIsMaximum;

/**
 完成之前从已选数组中删除某个模型
 */
- (void)beforeSelectedListdeletePhotoModel:(HXPhotoModel *)model;
/**
 完成之前添加某个模型到已选数组中
 */
- (void)beforeSelectedListAddPhotoModel:(HXPhotoModel *)model;
/**
 完成之前添加编辑之后的模型到已选数组中
 */
- (void)beforeSelectedListAddEditPhotoModel:(HXPhotoModel *)model;
/**
 完成之前将拍摄之后的模型添加到已选数组中
 */
- (void)beforeListAddCameraTakePicturesModel:(HXPhotoModel *)model;

/*--  关于选择完成之后的一些方法  --*/
/**
 完成之后选择的总数是否达到最大
 */
- (BOOL)afterSelectCountIsMaximum;
/**
 完成之后选择的照片数是否达到最大
 */
- (BOOL)afterSelectPhotoCountIsMaximum;
/**
 完成之后选择的总数
 */
- (NSInteger)afterSelectedCount;
/**
 完成之后选择的所有数组
 */
- (NSArray *)afterSelectedArray;
/**
 完成之后选择的照片数组
 */
- (NSArray *)afterSelectedPhotoArray;
/**
 设置完成之后选择的照片数组
 */
- (void)setAfterSelectedPhotoArray:(NSArray *)array;
/**
 完成之后是否原图
 */
- (BOOL)afterOriginal;
/**
 交换完成之后的两个模型在已选数组里的位置
 */
- (void)afterSelectedArraySwapPlacesWithFromModel:(HXPhotoModel *)fromModel fromIndex:(NSInteger)fromIndex toModel:(HXPhotoModel *)toModel toIndex:(NSInteger)toIndex;
/**
 替换完成之后的模型
 */
- (void)afterSelectedArrayReplaceModelAtModel:(HXPhotoModel *)atModel withModel:(HXPhotoModel *)model;
/**
 完成之后添加编辑之后的模型到数组中
 */
- (void)afterSelectedListAddEditPhotoModel:(HXPhotoModel *)model;
/**
 完成之后将拍摄之后的模型添加到已选数组中
 */
- (void)afterListAddCameraTakePicturesModel:(HXPhotoModel *)model;
/**
 完成之后从已选数组中删除指定模型
 */
- (void)afterSelectedListdeletePhotoModel:(HXPhotoModel *)model;
/**
 完成之后添加某个模型到已选数组中
 */
- (void)afterSelectedListAddPhotoModel:(HXPhotoModel *)model;

- (BOOL)shouldShowTipView;
- (void)deleteItemAtFirst;

- (void)selectedListTransformAfter;
- (void)selectedListTransformBefore;
- (void)setScrollImage:(UIImage *)resultImage;

- (CGFloat)getSelectPhotosMinWidth;

- (CGFloat)getSelectPhotosMinHeight;

- (void)combinePhotosWithDirection:(BOOL)isVertical resultImage:(void(^)(UIImage *combineImage))resultImage;

- (UIImage *)getScrollImage;

- (void)setScreenWidthSize:(CGFloat)size;

- (CGFloat)getScreenWithSize;
/**
 取消选择
 */
- (void)cancelBeforeSelectedList;

/**
 清空所有已选数组
 */
- (void)clearSelectedList;



/**  cell上添加photoView时所需要用到的方法  */
- (void)changeAfterCameraArray:(NSArray *)array;
- (void)changeAfterCameraPhotoArray:(NSArray *)array;
- (void)changeAfterSelectedCameraArray:(NSArray *)array;
- (void)changeAfterSelectedCameraPhotoArray:(NSArray *)array;
- (void)changeAfterSelectedArray:(NSArray *)array;
- (void)changeAfterSelectedPhotoArray:(NSArray *)array;
- (void)changeICloudUploadArray:(NSArray *)array;
- (NSArray *)afterCameraArray;
- (NSArray *)afterCameraPhotoArray;
- (NSArray *)afterSelectedCameraArray;
- (NSArray *)afterSelectedCameraPhotoArray;
- (NSArray *)afterICloudUploadArray;
@end
