//
//  SVCardCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-12.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCardCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblPrice,*nameLab;
@property (nonatomic, strong) NSMutableDictionary *prod;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, assign) int type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)product indexPath:(NSIndexPath *)idx type:(int)type;

@end
