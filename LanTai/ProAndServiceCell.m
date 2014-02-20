//
//  ProAndServiceCell.m
//  LanTai
//
//  Created by comdosoft on 13-12-3.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ProAndServiceCell.h"
#import "UIImageView+WebCache.h"
@implementation ProAndServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withProduct:(NSDictionary *)object indexPath:(NSIndexPath *)idx type:(int)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ProAndServiceCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ProAndServiceCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUrl:(NSURL *)url {
    if ([[self.pImg.p_dic objectForKey:@"s_type"]integerValue]==1) {
        self.lab1.frame = CGRectMake(5, 6, 302, 31);
        self.pImg.hidden = YES;
    }else {
        self.lab1.frame = CGRectMake(63, 6, 302, 31);
        self.pImg.hidden = NO;
        [self.pImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defualt.jpg"]];
    }
}
@end
