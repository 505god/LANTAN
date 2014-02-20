//
//  LoginViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanTaiMenuMainController.h"
#import "BaseViewController.h"
#import "LogInterface.h"
@interface LoginViewController : BaseViewController<UITextFieldDelegate,LogInterfaceDelegate>{
    IBOutlet UIButton *btnLogin;
}
@property (nonatomic,strong) LogInterface *logInterface;
@property (nonatomic, strong) IBOutlet UITextField *txtName;
@property (nonatomic, strong) IBOutlet UITextField *txtPwd;
@property (nonatomic, strong) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIView *errorView;

- (IBAction)clickLogin:(id)sender;

@end
