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


@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *contantView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UIView *infoContantView;
@property (weak, nonatomic) IBOutlet UITableView *teamInfoTableView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (nonatomic, strong) NSMutableDictionary *teamInfoDictionary;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InfoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionViewHeight;


@end

#define AboutCellHeight 56 * ScreenHeightRatio
static NSString *identifier = @"AboutTableViewCell";
@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UINib *teamInfoNib = [UINib nibWithNibName:@"WeiboTableViewCell" bundle:nil];
    [self.teamInfoTableView registerNib:teamInfoNib forCellReuseIdentifier:identifier];

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"teamWeiboInfo" ofType:@"plist"];
    _teamInfoDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _teamInfoTableView.showsHorizontalScrollIndicator = NO;
    _teamInfoTableView.showsVerticalScrollIndicator = NO;
    _teamInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _teamInfoTableView.scrollEnabled = NO;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *versionText = [NSString stringWithFormat:@"V%@ (%@)",app_Version, app_build];
    _versionLabel.text = versionText;
    //_appNameLabel.font = [UIFont systemFontOfSize:];
    [self.likeBtn setTitle:LocalString(@"like_us") forState:UIControlStateNormal];
    [self.contactBtn setTitle:LocalString(@"contact") forState:UIControlStateNormal];
    
    
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (kDevice_Is_iPhoneX || kDevice_Is_iPhone55 || kDevice_Is_iPhone47) {
    } else {
        _versionViewHeight.constant = self.view.frame.size.height * 0.299;
        _InfoViewHeight.constant = self.view.frame.size.height * 0.589;
    }
    _bgImageView.layer.cornerRadius = 10;
    _bgImageView.layer.masksToBounds = YES;
    
    
    _contantView.layer.cornerRadius = 10;
    //_contantView.layer.masksToBounds = YES;
    _contantView.layer.shadowColor = [UIColor colorWithRed:208/255.0 green:217/255.0 blue:237/255.0 alpha:1.0].CGColor;
    _contantView.layer.shadowOpacity = 0.8f;
    _contantView.layer.shadowOffset = CGSizeMake(0, 0);
    
    _infoContantView.layer.cornerRadius = 10;
    _infoContantView.layer.masksToBounds = YES;
//    _infoContantView.layer.shadowColor = [UIColor colorWithRed:208/255.0 green:217/255.0 blue:237/255.0 alpha:1.0].CGColor;
//    _infoContantView.layer.shadowOpacity = 0.8f;
//    _infoContantView.layer.shadowOffset = CGSizeMake(0, 0);
    
    _likeBtn.layer.cornerRadius = 10;
    //_likeBtn.layer.masksToBounds = YES;
    _likeBtn.layer.shadowColor = [UIColor colorWithRed:60/255.0 green:95/255.0 blue:166/255.0 alpha:0.05].CGColor;
    _likeBtn.layer.shadowOpacity = 0.8f;
    _likeBtn.layer.shadowOffset = CGSizeMake(0, 2);
    
    _contactBtn.layer.cornerRadius = 10;
    _contactBtn.layer.shadowColor = [UIColor colorWithRed:60/255.0 green:95/255.0 blue:166/255.0 alpha:0.05].CGColor;
    _contactBtn.layer.shadowOpacity = 0.8f;
    _contactBtn.layer.shadowOffset = CGSizeMake(0, 2);
    

}
- (IBAction)quickBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)likeBtnClicked:(id)sender {
    [self showTips:@"Only when it release in App store"];
}
- (IBAction)contactBtnClicked:(id)sender {
    //[self showTips];
    if([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate=self;
        picker.navigationBar.tintColor= [UIColor blackColor];
        [picker setToRecipients:[NSArray arrayWithObject:@"projectgame@163.com"]];
    
        [picker setSubject:@"aini"];
        
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
            NSLog(@"发送失败") ;
            
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
    

    WeiboTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"WeiboTableViewCell" owner:self options:nil]  lastObject];
    }
    NSDictionary *weiboInfo = [_teamInfoDictionary objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    cell.titleName.text = [weiboInfo objectForKey:@"title"];
    cell.weiboName.text = [weiboInfo objectForKey:@"name"];
    cell.weiboLink = [weiboInfo objectForKey:@"weibo"];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:60/255.0 green:95/255.0 blue:166/255.0 alpha:1.0];
    //cell.weiboIcon.image = [UIImage imageNamed:@"share_weibo"];
    
    //AboutViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutViewTableViewCell"];
    
    

    

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeiboTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSURL *URL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", cell.weiboLink] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        
        
        [[UIApplication sharedApplication] openURL:URL];
        //return;
        
    } else {
        //用浏览器访问微博
        //[[UIApplication sharedApplication] openURL:URL];
        [self showShareError];
    }
    

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
