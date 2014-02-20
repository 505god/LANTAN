//
//  RecordTableFooter.m
//  LanTai
//
//  Created by comdosoft on 13-12-30.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "RecordTableFooter.h"

@implementation RecordTableFooter

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:0.7];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(423, 4, 73, 35);
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"fastOrder"] forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame = CGRectMake(543, 4, 73, 35);
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"fastOrder"] forState:UIControlStateNormal];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(sureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.sureBtn];
    }
    return self;
}

-(void)cancelBtnPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(packageCancelPressed)]) {
        [self.delegate packageCancelPressed];
    }
}

-(void)sureBtnPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(packageSurePressed)]) {
        [self.delegate packageSurePressed];
    }
}
@end
