//
//  KeyViewController.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-11-21.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol KeyViewControllerDelegate;
@interface KeyViewController : BaseViewController<UITextFieldDelegate>

@property (assign, nonatomic) id<KeyViewControllerDelegate>delegate;

@property (strong, nonatomic) NSString *csrid;
@property (strong, nonatomic) NSString *customer_id;
@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *passWord;
@property (nonatomic, strong) IBOutlet UIView *subview;
@property (strong, nonatomic) IBOutlet UITextField *txtField;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) IBOutlet UIButton *btn6;
@property (strong, nonatomic) IBOutlet UIButton *btn7;
@property (strong, nonatomic) IBOutlet UIButton *btn8;
@property (strong, nonatomic) IBOutlet UIButton *btn9;
@property (strong, nonatomic) IBOutlet UIButton *btn0;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,assign) BOOL isSuccess;
@end

@protocol KeyViewControllerDelegate <NSObject>
@optional
- (void)closepopView:(KeyViewController *)keyView;
@end
