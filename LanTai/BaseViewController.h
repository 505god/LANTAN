//
//  BaseViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

- (void)addLeftnaviItemWithImage:(NSString *)imageName1 andImage:(NSString *)imageName2;

- (void)addRightnaviItemsWithImage:(NSString *)imageName andImage:(NSString *)image1;

@end
