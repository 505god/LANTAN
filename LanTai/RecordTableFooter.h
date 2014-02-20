//
//  RecordTableFooter.h
//  LanTai
//
//  Created by comdosoft on 13-12-30.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordTableFooterDelegate <NSObject>

-(void)packageCancelPressed;
-(void)packageSurePressed;

@end

@interface RecordTableFooter : UITableViewHeaderFooterView

@property (nonatomic, assign) id<RecordTableFooterDelegate>delegate;
@property (nonatomic, strong) UIButton *cancelBtn,*sureBtn;
@end
