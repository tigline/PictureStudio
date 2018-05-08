//
//  AboutViewController.m
//  PictureStudio
//
//  Created by mickey on 2018/5/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutViewTableViewCell.h"
#import "AHAssetGroupCell.h"

@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource>

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

@end

#define AboutCellHeight 56

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UINib *teamInfoNib = [UINib nibWithNibName:@"AboutViewTableViewCell" bundle:nil];
//    [_teamInfoTableView registerNib:teamInfoNib forCellReuseIdentifier:@"AboutViewTableViewCell"];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"teamWeiboInfo" ofType:@"plist"];
    _teamInfoDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _teamInfoTableView.showsHorizontalScrollIndicator = NO;
    _teamInfoTableView.showsVerticalScrollIndicator = NO;
    _teamInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _teamInfoTableView.scrollEnabled = NO;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _bgImageView.layer.cornerRadius = 5;
    _bgImageView.layer.masksToBounds = YES;
    
    _contantView.layer.cornerRadius = 5;
    _contantView.layer.masksToBounds = YES;
    
    _infoContantView.layer.cornerRadius = 5;
    _infoContantView.layer.masksToBounds = YES;
    
    _likeBtn.layer.cornerRadius = 5;
    _likeBtn.layer.masksToBounds = YES;
    
    _contactBtn.layer.cornerRadius = 5;
    _contactBtn.layer.masksToBounds = YES;
}
- (IBAction)quickBtnClicked:(id)sender {
    
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
    
    static NSString *identifier = @"AboutViewTableViewCell";//这个identifier跟xib设置的一样
    AboutViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"AboutViewTableViewCell" owner:self options:nil]  lastObject];
        NSDictionary *weiboInfo = [_teamInfoDictionary objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        cell.titleName.text = [weiboInfo objectForKey:@"title"];
        cell.weiboName.text = [weiboInfo objectForKey:@"name"];
        cell.weiboLink = [weiboInfo objectForKey:@"weibo"];
        cell.weiboIcon.image = [UIImage imageNamed:@"share_weibo"];
    }
    //AboutViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutViewTableViewCell"];
    
    

    

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AboutViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        NSURL *URL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", cell.weiboLink] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        [[UIApplication sharedApplication] openURL:URL];
        return;
        
    }
    

}





@end
