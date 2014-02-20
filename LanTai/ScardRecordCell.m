//
//  ScardRecordCell.m
//  LanTai
//
//  Created by comdosoft on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ScardRecordCell.h"
#import "RecordTableHeader.h"

@implementation ScardRecordCell
@synthesize nameLab,dateLab,products,index,scardDic,btn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier item:(NSMutableDictionary *)item indexPath:(NSIndexPath *)idx
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 844, 20);
        RecordTableHeader *tabHeader = [[RecordTableHeader alloc] initWithFrame:frame];
        frame = tabHeader.lbl_1.frame;
        frame.size.width = 120;
        self.products = [NSMutableArray arrayWithArray:[item objectForKey:@"records"]];
        int height = 0;
        
        if (self.products.count == 0) {
            frame.size.height = 44;
        }else {
            int x=0;
            for (int i=0; i<self.products.count; i++) {
                NSDictionary *dic = [self.products objectAtIndex:i];
                x += [[dic objectForKey:@"height"]intValue];
            }
            frame.size.height = x;
            height = x;
        }
        self.scardDic = [item mutableCopy];
        self.index = idx;
        //名称
        nameLab = [[UILabel alloc]initWithFrame:frame];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont boldSystemFontOfSize:15];
        nameLab.text =[item objectForKey:@"name"];
        [self addSubview:nameLab];
        //消费时间
        frame.origin.x += 121;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        frame.size.height = 43;
        frame.size.width = 140;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                NSDictionary *dic = [self.products objectAtIndex:i];
                if (self.products.count == 1) {
                    frame.size.height = [[dic objectForKey:@"height"]intValue];
                }else {
                    frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                    if(i>0 ){
                        frame.origin.y += [[[self.products objectAtIndex:i-1]objectForKey:@"height"]intValue];
                        if (i == self.products.count-1) {
                            frame.size.height = [[dic objectForKey:@"height"]intValue];
                        }else {
                            frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                        }
                        
                        
                    }
                }
                UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                lblName.text = [NSString stringWithFormat:@"%@",[[self.products objectAtIndex:i] objectForKey:@"time"]];
                [self addSubview:lblName];
            }
        }
        //项目
        frame.origin.x += 141;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        frame.size.height = 43;
        frame.size.width = 200;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                NSMutableString *text = [NSMutableString string];
                NSDictionary *dic = [self.products objectAtIndex:i];
                if (![[dic objectForKey:@"content"] isKindOfClass:[NSNull class]] && [dic objectForKey:@"content"]!=nil) {
                    NSString *str = [dic objectForKey:@"content"];
                    NSArray *arr = [str componentsSeparatedByString:@","];
                    if (arr.count==1) {
                        [text appendFormat:@"%@",[arr objectAtIndex:0]];
                    }else if (arr.count>1){
                        for (int k=0; k<arr.count; k++) {
                            NSString *ss = [arr objectAtIndex:k];
                            if (k==0) {
                                [text appendFormat:@"%@",ss];
                            }else {
                                [text appendFormat:@"\n%@",ss];
                            }
                            
                        }
                    }
                }
                if (self.products.count == 1) {
                    frame.size.height = [[dic objectForKey:@"height"]intValue];
                }else {
                    frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                    if(i>0 ){
                        frame.origin.y += [[[self.products objectAtIndex:i-1]objectForKey:@"height"]intValue];
                        if (i == self.products.count-1) {
                            frame.size.height = [[dic objectForKey:@"height"]intValue];
                        }else {
                            frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                        }
                    }
                }
                UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
                lblName.textAlignment = NSTextAlignmentCenter;
                [lblName setNumberOfLines:0];
                lblName.lineBreakMode = NSLineBreakByCharWrapping;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                lblName.text = [NSString stringWithFormat:@"%@",text];
                [self addSubview:lblName];
                
            }
        }
        //消费
        frame.origin.x += 201;
        frame.size.width = 120;
        frame.size.height = 43;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                NSDictionary *dic = [self.products objectAtIndex:i];
                if (self.products.count == 1) {
                    frame.size.height = [[dic objectForKey:@"height"]intValue];
                }else {
                    frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                    if(i>0 ){
                        frame.origin.y += [[[self.products objectAtIndex:i-1]objectForKey:@"height"]intValue];
                        if (i == self.products.count-1) {
                            frame.size.height = [[dic objectForKey:@"height"]intValue];
                        }else {
                            frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                        }
                    }
                }
                UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                if (![[[self.products objectAtIndex:i] objectForKey:@"u_price"] isKindOfClass:[NSNull class]]) {
                    lblName.text = [NSString stringWithFormat:@"%@",[[self.products objectAtIndex:i] objectForKey:@"u_price"]];
                }else
                    lblName.text = @"";
                
                [self addSubview:lblName];
            }
        }
        
        //余额
        frame.origin.x += 121;
        frame.size.width = 120;
        frame.size.height = 43;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                NSDictionary *dic = [self.products objectAtIndex:i];
                if (self.products.count == 1) {
                    frame.size.height =[[dic objectForKey:@"height"]intValue];
                }else {
                    frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                    if(i>0 ){
                        frame.origin.y += [[[self.products objectAtIndex:i-1]objectForKey:@"height"]intValue];
                        if (i == self.products.count-1) {
                            frame.size.height = [[dic objectForKey:@"height"]intValue];
                        }else {
                            frame.size.height = [[dic objectForKey:@"height"]intValue]-1;
                        }
                    }
                }
                UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                if (![[[self.products objectAtIndex:i] objectForKey:@"l_price"]isKindOfClass:[NSNull class]]) {
                    lblName.text = [NSString stringWithFormat:@"%@",[[self.products objectAtIndex:i] objectForKey:@"l_price"]];
                }else
                    lblName.text = @"";
                
                [self addSubview:lblName];
            }
        }
        
        //空格
        frame.origin.x += 121;
        frame.size.width = 137;
        frame.size.height = height;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        UILabel *lab = [[UILabel alloc]initWithFrame:frame];
        [self addSubview:lab];
        CGRect ff = CGRectMake(708, (frame.size.height-30)/2, 134, 30);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = ff;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_active"] forState:UIControlStateHighlighted];
        btn.tag = self.index.row;
        [btn setTitle:@"修改支付密码" forState:UIControlStateNormal];
        [btn setTitle:@"修改支付密码" forState:UIControlStateHighlighted];
        [self addSubview:btn];
        
        //空白条
        frame = CGRectMake(0, frame.size.height+2, 844, 18);
        tabHeader.frame = frame;
        [self addSubview:tabHeader];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
