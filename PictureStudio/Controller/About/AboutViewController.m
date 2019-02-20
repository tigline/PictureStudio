//
//  AboutViewController.m
//  PictureStudio
//
//  Created by mickey on 2018/5/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AboutViewController.h"
#import "WeiboTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <StoreKit/StoreKit.h>
#import "UIView+HXExtension.h"
#import "deleteSourceTableCell.h"
#import "ReplyTableCell.h"
#import "InfoTableCell.h"


typedef enum  {
    setting,
    active,
    info
} cellType;

typedef NSDictionary <NSString *, id> CPXCell;

@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate,
SKStoreProductViewControllerDelegate
>
@property (nonatomic, strong) NSMutableDictionary *teamInfoDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) NSArray <NSDictionary *> *sectionOneItems;
@property (strong, nonatomic) NSArray <NSDictionary *> *sectionTwoItems;
@property (assign, nonatomic) cellType type;
@property (weak, nonatomic) IBOutlet UIImageView *settingImage;

@end

#define AboutCellHeight 56 * ScreenHeightRatio
static NSString *identifier = @"AboutTableViewCell";
@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColor.backgroundColor;
    self.tableView.backgroundColor = UIColor.backgroundColor;
    [self initItems];
    
    
    
   
    
}

- (void)initItems {
    self.sectionOneItems = @[@{
                                 @"title":@"冷静评分",
                                 @"type":@"top"
                                 },
                             @{
                                 @"title":@"激情打赏",
                                 @"type":@"mid"
                                 },
                             @{
                                 @"title":@"联系我们",
                                 @"type":@"bottom"
                                 }];
    self.sectionTwoItems = @[@{
                                 @"title":@"产品",
                                 @"name":@"@王啵粒"
                                 },
                             @{
                                 @"title":@"设计",
                                 @"name":@"@品布尔"
                                 },
                             @{
                                 @"title":@"开发",
                                 @"name":@"@youTobe兵長，@付杰"
                                 }];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat heightRatio = _tableView.size.width/343;
    _tableHeaderView.size = CGSizeMake(_tableView.size.width, 200*heightRatio);

}
- (IBAction)quickBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)likeBtnClicked:(id)sender {
    NSString *evaluateString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id1387454155"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
//    NSString *appId = @"1387454155";
//
//    SKStoreProductViewController *storeVC = [[SKStoreProductViewController alloc] init];
//    storeVC.delegate = self;
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
//    __weak typeof(self) weakSelf = self;
//    [self.view showLoadingHUDText:@"跳转中"];
//    [storeVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"错误信息：%@",error.userInfo);
//        }
//        else
//        {
//            [weakSelf.view handleLoading];
//            // 弹出模态视图
//            [weakSelf presentViewController:storeVC animated:YES completion:nil];
//        }
//    }];
}
- (IBAction)contactBtnClicked:(id)sender {
    //[self showTips];
    if([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate=self;
        picker.navigationBar.tintColor= [UIColor blackColor];
        [picker setToRecipients:[NSArray arrayWithObject:@"wlb19@foxmail.com"]];
        NSArray *ccRecipient = [NSArray arrayWithObject:@"projectgame@163.com"];
        [picker setCcRecipients:ccRecipient];
        [picker setSubject:@"意见反馈"];
        
        [picker setMessageBody:@"Hello"isHTML:NO];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    
    
    switch(result) {
            
        case MFMailComposeResultSent:
            
            NSLog(@"发送成功") ;
            [self showTips:@"Sended"];
            break;
        case MFMailComposeResultCancelled:
            
            NSLog(@"取消") ;
            //[self showTips:@"Sended"];
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"保存") ;
            
            break;
            
        case MFMailComposeResultFailed:
            [self showTips:@"Failed"];
            NSLog(@"发送失败");
            
            break;
            
        default:
            
            break;
            
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AboutCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

//    WeiboTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
//    if (cell == nil) {
//        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"WeiboTableViewCell" owner:self options:nil]  lastObject];
//    }
//    NSDictionary *weiboInfo = [_teamInfoDictionary objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
//    cell.titleName.text = [weiboInfo objectForKey:@"title"];
//    cell.weiboName.text = [weiboInfo objectForKey:@"name"];
//    cell.weiboLink = [weiboInfo objectForKey:@"weibo"];
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:238/255.0 green:241/255.0 blue:247/255.0 alpha:1.0];
    //cell.weiboIcon.image = [UIImage imageNamed:@"share_weibo"];
    
    //AboutViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutViewTableViewCell"];
    
    if (indexPath.section == 0) {
        deleteSourceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deleteSourceTableCell"];
        cell.title.text = NSLocalizedString(@"保存场截图时删除原图", nil);
        cell.toggle.on = YES;
        return cell;
    } else if (indexPath.section == 1) {
        ReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyTableCell"];
        //cell.title.text = self.sectionOneItems[indexPath.item];
        NSDictionary *cellData = self.sectionOneItems[indexPath.item];
        cell.title.text = [cellData objectForKey:@"title"];
        [cell configCell:cellData];
        return cell;
    } else {
        InfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableCell"];
        NSDictionary *cellData = self.sectionTwoItems[indexPath.item];
        cell.title.text = [cellData objectForKey:@"title"];
        cell.name.text = [cellData objectForKey:@"name"];
        return cell;
    }
    

}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor clearColor];
    
    // Text Color
    //UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    //[header.textLabel setTextColor:[UIColor clearColor]];
    //header.backgroundColor = UIColor.clearColor;
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16*ScreenHeightRatio;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else {
        return 3;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WeiboTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSURL *URL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", cell.weiboLink] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
//
//
//        [[UIApplication sharedApplication] openURL:URL];
//        //return;
//
//    } else {
//        //用浏览器访问微博
//        //[[UIApplication sharedApplication] openURL:URL];
//        [self showShareError];
//    }
    

}
- (void)showShareError
{
    NSString *strTitle = LocalString(@"no_install_weibo");
    
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}

- (void)showTips:(NSString *)message
{
    //NSString *strTitle = LocalString(@"scroll_error");
    
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:nil
                                                                                    message:message
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}



@end
