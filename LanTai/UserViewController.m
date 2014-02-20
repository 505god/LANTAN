//
//  UserViewController.m
//  LanTai
//
//  Created by comdosoft on 13-12-16.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "UserViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.subview.layer setCornerRadius:8];
    [self.subview.layer setMasksToBounds:YES];
    
    UserModel *user = [DataService sharedService].userModel;
    self.nameLab.text = user.name;
    if (user.userPartment != nil) {
        self.partmentLab.text = [NSString stringWithFormat:@"部门:%@",user.userPartment];
    }
    if (user.userPost != nil) {
        self.postLab.text = [NSString stringWithFormat:@"职务:%@",user.userPost];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kDomain,user.userImg]];
    [self.userImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defualt.jpg"]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeFromSuperView:)]) {
        [DataService sharedService].isLoging = YES;
        [DataService sharedService].user_id = nil;
        [DataService sharedService].store_id = nil;
        [self.delegate removeFromSuperView:self];
    }
}
@end
