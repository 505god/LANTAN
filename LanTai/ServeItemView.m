//
//  ServeItemView.m
//  LanTai
//
//  Created by david on 13-10-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ServeItemView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ServeItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ServeItemView" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ServeItemView class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.serveBt addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(serveItemView:didSelectedItemAtIndexPath:)]) {
        [self.delegate serveItemView:self didSelectedItemAtIndexPath:self.path];
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        [self.serveBt setBackgroundImage:[UIImage imageNamed:@"serveRedbg.png"] forState:UIControlStateNormal];
    }else{
        [self.serveBt setBackgroundImage:nil forState:UIControlStateNormal];
    }
}
@end
