//
//  Toolbar.h
//  白云边
//
//  Created by wang changlinAir on 12-11-19.
//  Copyright (c) 2012年 wang changlinAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toolbar : UIView

@property (strong, nonatomic) IBOutlet UILabel *classLab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) UILabel *detailLab;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *detailLabb;
@property (assign, nonatomic) int number;

@property (strong, nonatomic) IBOutlet UILabel *kucunLab;
@property (strong, nonatomic) IBOutlet UILabel *countLab;
@property (strong, nonatomic) IBOutlet UILabel *pointLab;
@property (strong, nonatomic) IBOutlet UILabel *point;

@property (nonatomic, strong) NSDictionary * p_object;

- (id)initWithFrame:(CGRect)frame andDictionary:(NSDictionary *)diction andSearchType:(int)search_type;
@end
