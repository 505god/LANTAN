//
//  ServiceCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-12.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UILabel *lblName,*lblCount,*lblPrice,*lbltotal;
@property (nonatomic,strong) NSMutableDictionary *product;
@property (nonatomic,strong) NSIndexPath *index;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)prod indexPath:(NSIndexPath *)idx type:(NSInteger)type;


@end
