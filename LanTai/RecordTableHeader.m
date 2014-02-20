//
//  RecordTableHeader.m
//  LanTai
//
//  Created by comdosoft on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "RecordTableHeader.h"

@implementation RecordTableHeader
@synthesize lbl_1,lbl_2,lbl_3,lbl_4;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:0.7];
        
            CGRect frame = CGRectMake(1, 1, 120, 42);
            lbl_1 = [[UILabel alloc] initWithFrame:frame];
            lbl_1.textAlignment = NSTextAlignmentCenter;
            lbl_1.text = @"名称";
            [self addSubview:lbl_1];
        
            frame.origin.x += 121;
            frame.size.width = 200;
            lbl_2 = [[UILabel alloc] initWithFrame:frame];
            lbl_2.textAlignment = NSTextAlignmentCenter;
            lbl_2.text = @"已使用项目";
            [self addSubview:lbl_2];
        
            frame.origin.x += 201;
            frame.size.width = 200;
            lbl_3 = [[UILabel alloc] initWithFrame:frame];
            lbl_3.textAlignment = NSTextAlignmentCenter;
            lbl_3.text = @"剩余项目";
            [self addSubview:lbl_3];
        
            frame.origin.x += 201;
            frame.size.width = 111;
            lbl_4 = [[UILabel alloc] initWithFrame:frame];
            lbl_4.textAlignment = NSTextAlignmentCenter;
            lbl_4.text = @"使用期限";
            [self addSubview:lbl_4];
        }
    return self;
}
@end
