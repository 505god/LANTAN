//
//  CarCellView.m
//  LanTai
//
//  Created by david on 13-10-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CarCellView.h"
#define CAR_PADDING 10
#define CAR_HEIGHT 44
@interface CarCellView()
@property (nonatomic,strong) UIImageView  *carImageView;
@property (nonatomic,strong) UILabel *carNumberLabel;

@end
@implementation CarCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.carImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.carImageView];
        
        self.carNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.carNumberLabel];
        self.carNumberLabel.backgroundColor = [UIColor clearColor];
        [self.carNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [self.carNumberLabel setFont:[UIFont systemFontOfSize:20]];
        [self.carNumberLabel setTextColor:[UIColor blackColor]];
        
        self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.coverView];
        self.coverView.backgroundColor = [UIColor blackColor];
        self.coverView.alpha = 0.5;
        [self.coverView setHidden:YES];
    }
    return self;
}


-(CarCellView*)copyCarCellView{
    CarCellView *copyView = [[CarCellView alloc] init];
    copyView.carNumber = self.carNumber;
    copyView.state = self.state;
    copyView.frame = [self convertRect:self.frame toView:self.superview];
    return copyView;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.carImageView.frame = CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30);
    self.carNumberLabel.frame = CGRectMake(0, 0, self.frame.size.width, 24);
    
    self.coverView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(void)setState:(CarState)state{
    _state = state;
    switch (state) {
        case CARWAITTING:
        {
            [self.carImageView setImage:[UIImage imageNamed:@"redCar.png"]];
            self.carNumberLabel.text = self.carNumber;
        break;
        }
        case CARBEGINNING:
        {
            [self.carImageView setImage:[UIImage imageNamed:@"greenCar.png"]];
            self.carNumberLabel.text = self.carNumber;
            break;
        }
        case CARPAYING:
        case CARFINISHED:
        {
            [self.carImageView setImage:[UIImage imageNamed:@"redCar.png"]];
            self.carNumberLabel.text = self.carNumber;
            break;
        }
        case CARNOTHING:
        {
            [self.carImageView setImage:nil];
            self.carNumberLabel.text = nil;
            [self.coverView setHidden:YES];
            break;
        }
            
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    if (self.state == CARBEGINNING || self.state == CARPAYING) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenCoverView) object:nil];
        [self performSelector:@selector(appearCoverView) withObject:nil afterDelay:0.05];
        [self performSelector:@selector(hiddenCoverView) withObject:nil afterDelay:0.2];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(appearCoverView) object:nil];
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(carCellViewDidSelected:)]) {
        [self.delegate carCellViewDidSelected:self];
    }
    [self.coverView setHidden:YES];
}

-(void)hiddenCoverView{
    [self.coverView setHidden:YES];
}

-(void)appearCoverView{
    [self.coverView setHidden:NO];
}
@end
