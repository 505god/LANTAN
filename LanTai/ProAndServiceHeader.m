//
//  ProAndServiceHeader.m
//  LanTai
//
//  Created by comdosoft on 13-12-3.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ProAndServiceHeader.h"

@implementation ProAndServiceHeader

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
        
        self.lab1 = [[UILabel alloc]init];
        self.lab1.frame = CGRectMake(10,6,351,32);
        [self addSubview:self.lab1];
        
        self.lab2 = [[UILabel alloc]init];
        self.lab2.frame = CGRectMake(375,6,53,32);
        [self addSubview:self.lab2];
        
        self.lab3 = [[UILabel alloc]init];
        self.lab3.frame = CGRectMake(460,6,69,32);
        [self addSubview:self.lab3];
        
        self.lab4 = [[UILabel alloc]init];
        self.lab4.frame = CGRectMake(260, 7, 200, 30);
        [self addSubview:self.lab4];
        
        self.lab5 = [[UILabel alloc]init];
        self.lab5.frame = CGRectMake(400, 0, 180, 44);
        [self addSubview:self.lab5];
        
        self.lab1.backgroundColor = [UIColor clearColor];
        self.lab2.backgroundColor = [UIColor clearColor];
        self.lab3.backgroundColor = [UIColor clearColor];
        self.lab4.backgroundColor = [UIColor clearColor];
        self.lab5.backgroundColor = [UIColor clearColor];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 210, 30)];
        [self addSubview:self.nameLab];
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectMake(210, 7, 110, 30)];
        [self addSubview:self.priceLab];
        self.countLab = [[UILabel alloc]initWithFrame:CGRectMake(318, 7, 60, 30)];
        [self addSubview:self.countLab];
        self.totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(483, 7, 97, 30)];
        [self addSubview:self.totalPrice];
        
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.priceLab.backgroundColor = [UIColor clearColor];
        self.countLab.backgroundColor = [UIColor clearColor];
        self.totalPrice.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end
