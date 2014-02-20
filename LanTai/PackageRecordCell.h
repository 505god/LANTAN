//
//  PackageRecordCell.h
//  LanTai
//
//  Created by comdosoft on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageRecordCell : UITableViewCell
@property (nonatomic,strong) NSMutableDictionary *packageDic;
@property (nonatomic,strong) UILabel *nameLab,*dateLab;
@property (nonatomic,strong) NSMutableArray *products;
@property (nonatomic,strong) NSIndexPath *index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier item:(NSMutableDictionary *)item indexPath:(NSIndexPath *)idx;
@end
