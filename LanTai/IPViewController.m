//
//  IPViewController.m
//  LanTai
//
//  Created by comdosoft on 13-12-18.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "IPViewController.h"
#import "LoginViewController.h"
@interface IPViewController ()

@end

@implementation IPViewController

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
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sip = [defaults objectForKey:@"IP"];
    if (sip != nil) {
        self.txt.text = sip;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnPressed:(id)sender {
    [self.txt resignFirstResponder];
    if (self.txt.text.length == 0) {
        [Utils errorAlert:@"请输入域名"];
    }else {
        [DataService sharedService].kHost = [NSString stringWithFormat:@"http://%@/api",self.txt.text];
        [DataService sharedService].kDomain = [NSString stringWithFormat:@"http://%@",self.txt.text];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.txt.text forKey:@"IP"];
        [defaults synchronize];
        
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

@end
