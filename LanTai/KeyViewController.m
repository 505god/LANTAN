//
//  KeyViewController.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-11-21.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//
#import "AppDelegate.h"

@interface KeyViewController ()

@end

@implementation KeyViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    DLog(@"tag = %d",btn.tag);
    NSMutableString *txt = [NSMutableString string];
    if (self.txtField.text.length == 0) {
        [txt appendFormat:@"%d",btn.tag];
    }else {
        [txt appendFormat:@"%@",self.txtField.text];
        [txt appendFormat:@"%d",btn.tag];
    }
    
    self.txtField.text = txt;
}

-(IBAction)surePressed:(id)sender {
    if (self.txtField.text.length == 0) {
        [Utils errorAlert:@"请输入密码"];
    }else if (self.txtField.text.length !=6) {
        [Utils errorAlert:@"密码长度为6位"];
    }else {
            self.passWord = self.txtField.text;
            self.isSuccess = TRUE;
            if (self.delegate && [self.delegate respondsToSelector:@selector(closepopView:)]) {
                [self.delegate closepopView:self];
        }
    }
}

-(IBAction)resetPressed:(id)sender {
    self.txtField.text = nil;
}

-(IBAction)canclePressed:(id)sender {
    NSMutableString *txt = [NSMutableString stringWithFormat:@"%@",self.txtField.text];
    if (txt.length>0) {
        NSString * txt2 = [txt substringToIndex:txt.length-1];
        self.txtField.text = txt2;
    }
}


@end
