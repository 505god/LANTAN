//
//  ComplaintViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainInterface.h"
#import "BaseViewController.h"

@interface ComplaintViewController : BaseViewController <UITextViewDelegate,ComplainInterfaceDelegate>

@property (nonatomic, strong) ComplainInterface *complainInterface;
@property (nonatomic,strong) IBOutlet UILabel *lblCarNum,*lblCode,*lblProduct;

@property (nonatomic,strong) IBOutlet UIView *sub_view;
@property (nonatomic,strong) NSMutableDictionary *info;
@property (nonatomic,strong) IBOutlet UITextView *reasonView,*requestView;
@property (nonatomic,strong) IBOutlet UIButton *sureBtn,*cancleBtn;

- (IBAction)clickSubmit:(id)sender;

@end
