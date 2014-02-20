//
//  OrderViewController.h
//  LanTai
//
//  Created by comdosoft on 13-12-3.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakeOrderInterface.h"

@protocol OrderViewDelegate;
@interface OrderViewController : UIViewController <MakeOrderInterfaceDelegate>
@property (nonatomic, strong) MakeOrderInterface *makeOrderInterface;
@property (nonatomic, assign) id<OrderViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *nameLab,*priceLab,*countLab,*totalLab,*lbl_price;
@property (nonatomic, strong) IBOutlet UILabel *heLab,*numLab;
@property (nonatomic, strong) IBOutlet UIButton *sureBtn,*addBtn,*subtractBtn;
@property (nonatomic, strong) IBOutlet UIView *subview;
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSDictionary * p_object;
@property (nonatomic, strong) NSString *carNum;

@property (nonatomic, strong) NSDictionary *product_dic;
@end

@protocol OrderViewDelegate <NSObject>
@optional
- (void)dismissPopView:(OrderViewController *)payStyleViewController;
@end