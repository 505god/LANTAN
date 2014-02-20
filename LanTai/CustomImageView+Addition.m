//
//  CustomImageView+Addition.m
//  LanTai
//
//  Created by comdosoft on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CustomImageView+Addition.h"
#import "Toolbar.h"
#import "RJLabel.h"
#import "UIImageView+WebCache.h"
#define kCoverViewTag           2234
#define kImageViewTag           2235
#define kAnimationDuration      0.3f
#define kImageViewWidth         600.0f
#define kBackViewColor          [UIColor colorWithWhite:0.667 alpha:0.5f]

@implementation CustomImageView (Addition)

- (void)hiddenView
{
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    [coverView removeFromSuperview];
}

- (void)hiddenViewAnimation
{
    UIImageView *imageView = (UIImageView *)[[self window] viewWithTag:kImageViewTag];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration]; //动画时长
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    
    [UIView commitAnimations];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:kAnimationDuration];
    
}

//自动按原UIImageView等比例调整目标rect
- (CGRect)autoFitFrame {
    CGRect targeRect = CGRectMake(112, 84, 800, 600);
    return targeRect;
}
-(void)setToolbarWithtoolbar:(Toolbar *)toolbar {
    toolbar.backgroundColor = [UIColor darkGrayColor];
    
    toolbar.classLab.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];
    toolbar.nameLab.text = [toolbar.p_object objectForKey:@"name"];
    toolbar.priceLab.text = [NSString stringWithFormat:@"%.2f元",[[toolbar.p_object objectForKey:@"price"] floatValue]];
    
    if (toolbar.number == 0 || toolbar.number == 1) {
        if (toolbar.number == 0) {
            toolbar.classLab.text = @"产品";
        }else {
            toolbar.classLab.text = @"服务";
        }
        
        //库存
        if ([toolbar.p_object objectForKey:@"num"] != nil) {
            if ([[toolbar.p_object objectForKey:@"num"] integerValue]<0) {
                toolbar.kucunLab.hidden = YES;
                toolbar.countLab.hidden = YES;
                //打分
                if ([toolbar.p_object objectForKey:@"point"] != nil) {
                    toolbar.pointLab.frame = CGRectMake(8, 122, 60, 21);
                    toolbar.point.frame = CGRectMake(8, 138, 110, 21);
                    
                    toolbar.pointLab.hidden = NO;
                    toolbar.point.hidden = NO;
                    toolbar.point.text = [NSString stringWithFormat:@"%@",[toolbar.p_object objectForKey:@"point"]];
                    
                    toolbar.detailLabb.frame = CGRectMake(8, 169, 60, 21);
                    toolbar.scrollView.frame = CGRectMake(8, 185, 110, 409);
                }else {
                    toolbar.pointLab.hidden = YES;
                    toolbar.point.hidden = YES;
                    
                    toolbar.detailLabb.frame = CGRectMake(8, 122, 60, 21);
                    toolbar.scrollView.frame = CGRectMake(8, 138, 110, 503);
                }
            }else {
                toolbar.kucunLab.hidden = NO;
                toolbar.countLab.hidden = NO;
                toolbar.countLab.text = [NSString stringWithFormat:@"%@",[toolbar.p_object objectForKey:@"num"]];
                
                toolbar.detailLabb.frame = CGRectMake(8, 216, 60, 21);
                toolbar.scrollView.frame = CGRectMake(8, 232, 110, 362);
                //打分
                if ([toolbar.p_object objectForKey:@"point"] != nil) {
                    toolbar.pointLab.frame = CGRectMake(8, 169, 60, 21);
                    toolbar.point.frame = CGRectMake(8, 185, 110, 21);
                    
                    toolbar.pointLab.hidden = NO;
                    toolbar.point.hidden = NO;
                    toolbar.point.text = [NSString stringWithFormat:@"%@",[toolbar.p_object objectForKey:@"point"]];
                }else {
                    toolbar.pointLab.hidden = YES;
                    toolbar.point.hidden = YES;
                    
                    toolbar.detailLabb.frame = CGRectMake(8, 169, 60, 21);
                    toolbar.scrollView.frame = CGRectMake(8, 185, 110, 409);
                }
            }
        }else {
            toolbar.kucunLab.hidden = YES;
            toolbar.countLab.hidden = YES;
            //打分
            if ([toolbar.p_object objectForKey:@"point"] != nil) {
                toolbar.pointLab.frame = CGRectMake(8, 122, 60, 21);
                toolbar.point.frame = CGRectMake(8, 138, 110, 21);
                
                toolbar.pointLab.hidden = NO;
                toolbar.point.hidden = NO;
                toolbar.point.text = [NSString stringWithFormat:@"%@",[toolbar.p_object objectForKey:@"point"]];
                
                toolbar.detailLabb.frame = CGRectMake(8, 169, 60, 21);
                toolbar.scrollView.frame = CGRectMake(8, 185, 110, 409);
            }else {
                toolbar.pointLab.hidden = YES;
                toolbar.point.hidden = YES;
                
                toolbar.detailLabb.frame = CGRectMake(8, 122, 60, 21);
                toolbar.scrollView.frame = CGRectMake(8, 138, 110, 503);
            }
        }
    }else {
        toolbar.classLab.text = @"卡类";
        
        toolbar.kucunLab.hidden = YES;
        toolbar.countLab.hidden = YES;
        toolbar.pointLab.frame = CGRectMake(8, 122, 60, 21);
        toolbar.point.frame = CGRectMake(8, 138, 110, 21);
        
        toolbar.detailLabb.frame = CGRectMake(8, 169, 60, 21);
        toolbar.scrollView.frame = CGRectMake(8, 185, 110, 409);
        //打分
        if ([toolbar.p_object objectForKey:@"point"] != nil) {
            toolbar.pointLab.hidden = NO;
            toolbar.point.hidden = NO;
            toolbar.point.text = [NSString stringWithFormat:@"%@",[toolbar.p_object objectForKey:@"point"]];
        }else {
            toolbar.pointLab.hidden = YES;
            toolbar.point.hidden = YES;
            
            toolbar.detailLabb.frame = CGRectMake(8, 122, 60, 21);
            toolbar.scrollView.frame = CGRectMake(8, 138, 110, 503);
        }
    }
    
    NSString *text = [NSString stringWithFormat:@"%@",[toolbar.p_object objectForKey:@"desc"]];
    if (text.length == 0) {
        text = [NSString stringWithFormat:@"%@",[toolbar.p_object objectForKey:@"name"]];
    }
    toolbar.detailLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [toolbar.detailLab setNumberOfLines:0];
    [toolbar.detailLab setBackgroundColor:[UIColor clearColor]];
    toolbar.detailLab.textColor = [UIColor whiteColor];
    toolbar.detailLab.tag = 10000;
    UIFont *font = [UIFont fontWithName:@"Trebuchet MS" size:15];
    [toolbar.detailLab setFont:font];
    
    CGSize size = [UILabel fitSize:110.0f
                              text:text
                              font:font
                     numberOfLines:0
                     lineBreakMode:NSLineBreakByWordWrapping];
    
    [toolbar.detailLab setFrame:CGRectMake(0, 0, 110, size.height)];
    toolbar.detailLab.text = text;
    
    [toolbar.scrollView addSubview:toolbar.detailLab];
    toolbar.scrollView.contentSize = CGSizeMake(110,toolbar.detailLab.frame.size.height+5);
    [toolbar.scrollView setScrollEnabled:YES];
}
- (void)imageTap:(UITapGestureRecognizer *)gesture {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showImge" object:nil];
    
    UIView *coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    coverView.backgroundColor = kBackViewColor;
    
    UITapGestureRecognizer *hiddenViewGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenViewAnimation)];
    [coverView addGestureRecognizer:hiddenViewGecognizer];
    
    //屏幕方向
    float scale = 0;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation==UIDeviceOrientationLandscapeRight) {
        DLog(@"right");
        scale = 1.5;
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft){
        DLog(@"left");
        scale = 0.5;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kDomain,[self.p_dic objectForKey:@"img_big"]]];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defualt.jpg"]];
    imageView.tag = kImageViewTag;
    imageView.userInteractionEnabled = YES;
    imageView.transform = CGAffineTransformMakeRotation(M_PI*scale);//图片翻转
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    [coverView addSubview:imageView];
    
    //toolbar
    Toolbar *toolbar = [[[NSBundle mainBundle]loadNibNamed:@"Toolbar" owner:self options:nil]objectAtIndex:0];
    toolbar.transform = CGAffineTransformMakeRotation(M_PI*scale);
    toolbar.frame = CGRectMake(84, 60, 600, 124);
    toolbar.number = self.selectClassify;
    toolbar.p_object = self.p_dic;
    [self setToolbarWithtoolbar:toolbar];
    
    [coverView addSubview:toolbar];
    
    coverView.tag = kCoverViewTag;
    [[self window] addSubview:coverView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    CGRect frame = [self autoFitFrame];
    imageView.frame = CGRectMake(frame.origin.y, frame.origin.x+72, frame.size.height, frame.size.width);
    [UIView commitAnimations];
    
}

- (void)addDetailShow:(NSDictionary *)diction andSearchType:(int)search_type {
    self.p_dic = diction;
    self.selectClassify = search_type;
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end
