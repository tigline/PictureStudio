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
//    NSMutableArray *photoArray;
//    for (int i = 0; i < assets.count; i++) {
//        PHAsset *asset = [assets objectAtIndex:i];
//        [photoArray addObject:assets]
//    }
        [JointPicture jointPictures:(NSArray *)photos complete:^(UIImage* longPicture) {
            if (longPicture != nil) {
                [self performSegueWithIdentifier:@"goLongPicture" sender:longPicture];
            }
        }];
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
