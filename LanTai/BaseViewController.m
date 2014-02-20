//
//  BaseViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"


@interface BaseViewController ()

@end

@implementation BaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)shownaviTitle:(NSNotification *)object {
    NSDictionary *dic = object.object;
    NSLog(@"str = %@", [dic objectForKey:@"store_name"]);
    //标题
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(370,2,284,40)];
    [lbNavTitle setTextAlignment:NSTextAlignmentLeft];
    lbNavTitle.backgroundColor = [UIColor clearColor];
    [lbNavTitle setTextColor:[UIColor grayColor]];
    [lbNavTitle setFont:[UIFont systemFontOfSize:20]];
    lbNavTitle.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"store_name"]];
    [self.navigationController.navigationBar addSubview:lbNavTitle];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(hideKeyBoard:)];
    tapGr.cancelsTouchesInView = NO;
    self.tapGesture = tapGr;
    tapGr = nil;
    
}

-(void)hideKeyBoard:(UITapGestureRecognizer *)recognizer {
    DLog(@"隐藏键盘");
}

-(void)setIp:(id)sender {

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)rightTapped:(id)sender{
}

- (void)leftTapped:(id)sender{
    
}

- (void)addLeftnaviItemWithImage:(NSString *)imageName1 andImage:(NSString *)imageName2{
    NSMutableArray *mycustomButtons = [NSMutableArray array];
    
    if (imageName1 != nil && ![imageName1 isEqualToString:@""]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", imageName1]] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled = YES;
        [btn addTarget:self action:@selector(leftTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [mycustomButtons addObject: item];
        btn = nil;
        item = nil;
    }
    
    
    if (imageName2 != nil && ![imageName2 isEqualToString:@""]) {
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn2 setImage:[UIImage imageNamed:imageName2] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", imageName2]] forState:UIControlStateHighlighted];
        btn2.userInteractionEnabled = YES;
        [btn2 addTarget:self action:@selector(syncData:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
        [mycustomButtons addObject: item2];
        btn2 = nil;
        item2 = nil;
    }

    self.navigationItem.leftBarButtonItems=mycustomButtons;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)syncData:(id)sender {
    
}
-(void)refreshData:(id)sender {
    
}
- (void)addRightnaviItemsWithImage:(NSString *)imageName andImage:(NSString *)image1; {
    NSMutableArray *mycustomButtons = [NSMutableArray array];
    
    if (imageName != nil && ![imageName isEqualToString:@""]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", imageName]] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled = YES;
        [btn addTarget:self action:@selector(rightTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [mycustomButtons addObject: item];
        btn = nil;
        item = nil;
    }
    
    
    if (image1 != nil && ![image1 isEqualToString:@""]) {
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn2 setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", image1]] forState:UIControlStateHighlighted];
        btn2.userInteractionEnabled = YES;
        [btn2 addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
        [mycustomButtons addObject: item2];
        btn2 = nil;
        item2 = nil;
    }
    
    self.navigationItem.rightBarButtonItems=mycustomButtons;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
}
@end
