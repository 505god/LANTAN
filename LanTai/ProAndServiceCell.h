//
//  ProAndServiceCell.h
//  LanTai
//
//  Created by comdosoft on 13-12-3.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView+Addition.h"
#import "CustomImageView.h"
@interface ProAndServiceCell : UITableViewCell
@property (nonatomic, strong) IBOutlet CustomImageView *pImg;
@property (nonatomic, strong) IBOutlet UILabel *lab1;
@property (nonatomic, strong) IBOutlet UILabel *lab2;
@property (nonatomic, strong) IBOutlet UILabel *lab3;
@property (nonatomic, strong) IBOutlet UIButton *orderBtn;
@property (nonatomic, strong) NSURL *url;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withProduct:(NSDictionary *)object indexPath:(NSIndexPath *)idx type:(int)type;

@end

