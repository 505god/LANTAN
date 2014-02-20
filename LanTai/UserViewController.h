//
//  UserViewController.h
//  LanTai
//
//  Created by comdosoft on 13-12-16.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseViewController.h"
#import "LanTanDB.h"
#import "UserModel.h"

@protocol UserViewDelegate;
@interface UserViewController : UIViewController

@property (nonatomic,assign) id<UserViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIView *subview;
@property (nonatomic, strong) IBOutlet UIImageView *userImg;
@property (nonatomic, strong) IBOutlet UILabel *partmentLab,*postLab,*nameLab;
@end

@protocol UserViewDelegate <NSObject>
@optional
- (void)removeFromSuperView:(UserViewController *)userViewController;
@end