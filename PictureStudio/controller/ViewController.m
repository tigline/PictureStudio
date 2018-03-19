//
//  ViewController.m
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "ViewController.h"
#import "TZImagePickerController.h"
#import "LongPictureViewController.h"
#import "JointPicture.h"
#import <Photos/Photos.h>
#import "FilePathUtils.h"

@interface ViewController ()<TZImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor orangeColor]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}



- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    NSLog(@"tz_imagePickerControllerDidCancel");
    
}

- (IBAction)goPhoto:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
//{
//    //[self performSegueWithIdentifier:@"goLongPicture" sender:photos];
//    __block UIImage *longPicture = [JointPicture jointPictures:(NSArray *)assets complete:^(BOOL isSuccess) {
//        if (isSuccess) {
//            [self performSegueWithIdentifier:@"goLongPicture" sender:longPicture];
//        }
//    }];
//
//
//}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
        //[self performSegueWithIdentifier:@"goLongPicture" sender:photos];
//    __block NSMutableArray *photoArray = [[NSMutableArray alloc] init];
//    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
//    PHAsset *phAsset;
//    for (int i = 0; i < assets.count; i++) {
//        phAsset = [assets objectAtIndex:i];
//        PHImageRequestOptions * options=[[PHImageRequestOptions alloc]init];
//        options.synchronous=YES;
//        [imageManager requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize
//                               contentMode:PHImageContentModeDefault
//                                   options:options
//                             resultHandler:^(UIImage *result, NSDictionary *info)
//         {
//             NSString *imageName = [[self getMessageID] stringByAppendingString:@".jpg"];
//             NSString * localFilePath = [[FilePathUtils pathOfLibraryDirectory] stringByAppendingPathComponent:imageName];
//             [photoArray addObject:localFilePath];
//             [UIImageJPEGRepresentation(result, 1.0) writeToFile:localFilePath atomically:YES];
//         }];
//    }
    [JointPicture jointPictures:(NSArray *)photos complete:^(UIImage* longPicture) {
        if (longPicture != nil) {
            [self performSegueWithIdentifier:@"goLongPicture" sender:longPicture];
        }
    }];
}

-(NSString *)getMessageID
{
    NSTimeInterval  messageId=[[NSDate date] timeIntervalSince1970]*100;
    NSString *strmessageId=[NSString stringWithFormat:@"%lld",(long long)messageId];
    return strmessageId;
}

-(NSString*)returnCurrentTime
{
    //    NSDate *sendDate=[NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *currentDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: currentDate];
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
    NSString* date = [formatter stringFromDate:localeDate];
    return date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"goLongPicture"]) {
        //UIImage *image = (UIImage *)sender
        ((LongPictureViewController *)(segue.destinationViewController)).resultImage = (UIImage *)sender;
    }
}


@end
