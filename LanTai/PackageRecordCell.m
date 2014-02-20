//
//  PackageRecordCell.m
//  LanTai
//
//  Created by comdosoft on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "PackageRecordCell.h"
#import "TabHeaderSpace.h"

#define OPEN 100
#define CLOSE 1000

@implementation PackageRecordCell
@synthesize nameLab,dateLab,products,index,packageDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier item:(NSMutableDictionary *)item indexPath:(NSIndexPath *)idx{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 636, 20);
        TabHeaderSpace *tabHeader = [[TabHeaderSpace alloc] initWithFrame:frame];
        frame = tabHeader.lbl_1.frame;
        frame.size.width = 120;
        self.products = [NSMutableArray arrayWithArray:[item objectForKey:@"products"]];
        if (self.products.count == 0) {
            frame.size.height = 44;
        }else {
            frame.size.height = self.products.count * 44;
        }
        self.packageDic = [item mutableCopy];
        self.index = idx;
        //名称
        nameLab = [[UILabel alloc]initWithFrame:frame];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont boldSystemFontOfSize:15];
        nameLab.backgroundColor = [UIColor whiteColor];
        [self addSubview:nameLab];
        //已使用项目
        frame.origin.x += 121;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        frame.size.height = 43;
        frame.size.width = 200;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            lblName.backgroundColor = [UIColor whiteColor];
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                if (self.products.count == 1) {
                    frame.size.height = 44;
                }else {
                    if(i>0 ){
                        frame.origin.y += 44;
                        if (i == self.products.count-1) {
                            frame.size.height = 44;
                        }else {
                            frame.size.height = 43;
                        }
                    }
                }
                NSDictionary *dicc =[self.products objectAtIndex:i];
                UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                if (![[dicc objectForKey:@"useNum"]isKindOfClass:[NSNull class]] && [dicc objectForKey:@"useNum"]!=nil) {
                    lblName.text = [NSString stringWithFormat:@"%@:%@次",[dicc objectForKey:@"name"],[dicc objectForKey:@"useNum"]];
                }else {
                    lblName.text = [NSString stringWithFormat:@"%@:0次",[dicc objectForKey:@"name"]];
                }
                
                lblName.backgroundColor = [UIColor whiteColor];
                [self addSubview:lblName];
            }
        }
        //剩余项目
        frame.origin.x += 201;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        frame.size.height = 43;
        frame.size.width = 200;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            lblName.backgroundColor = [UIColor whiteColor];
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                int leftNum = [[[self.products objectAtIndex:i]objectForKey:@"leftNum"]intValue];
                if (self.products.count == 1) {
                    frame.size.height = 44;
                }else {
                    if(i>0 ){
                        frame.origin.y += 44;
                        if (i == self.products.count-1) {
                            frame.size.height = 44;
                        }else {
                            frame.size.height = 43;
                        }
                    }
                }
                UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width-40, frame.size.height)];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                lblName.text = [NSString stringWithFormat:@"%@:%@次",[[self.products objectAtIndex:i] objectForKey:@"name"],[[self.products objectAtIndex:i]objectForKey:@"leftNum"]];
                lblName.backgroundColor = [UIColor whiteColor];
                [self addSubview:lblName];
                
//                int is_expired = [[self.packageDic objectForKey:@"is_expired"]intValue];
//                if (is_expired == 1) {//套餐卡过期
//                    UILabel *whiteLab =[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x+160, frame.origin.y, 40, frame.size.height)];
//                    whiteLab.backgroundColor = [UIColor whiteColor];
//                    [self addSubview:whiteLab];
//                }else {//套餐卡没有过期
                    if (leftNum == 0) {
                        UILabel *whiteLab =[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x+160, frame.origin.y, 40, frame.size.height)];
                        whiteLab.backgroundColor = [UIColor whiteColor];
                        [self addSubview:whiteLab];
                    }else {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(frame.origin.x+160, frame.origin.y, 40, frame.size.height);
                        btn.backgroundColor = [UIColor whiteColor];
                        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = CLOSE +i;
                        [self addSubview:btn];
                    }
//                }
            }
        }
        //使用期限
        frame.origin.x += 201;
        frame.size.width = 111;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        if (self.products.count == 0) {
            frame.size.height = 44;
        }else {
            frame.size.height = self.products.count * 44;
        }
        dateLab = [[UILabel alloc] initWithFrame:frame];
        dateLab.font = [UIFont boldSystemFontOfSize:15];
        dateLab.numberOfLines = 0;
        dateLab.textAlignment = NSTextAlignmentCenter;
        dateLab.backgroundColor = [UIColor whiteColor];
        [self addSubview:dateLab];
        
        //空白条
        frame = CGRectMake(0, frame.size.height+2, 636, 18);
        tabHeader.frame = frame;
        [self addSubview:tabHeader];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (NSString *)checkFormWithId:(int)package_id andId:(int)product_id andIdx:(int)row{
    NSMutableString *prod_string = [NSMutableString string];
    [prod_string appendFormat:@"%d_%d_%d",package_id,product_id,self.index.row];
    return prod_string;
}
- (void)clickSwitch:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag = %d",btn.tag);
    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
    NSMutableDictionary *dic = nil;
    int package_id = [[self.packageDic objectForKey:@"cpard_relation_id"]intValue];
    
    if (tagStr.length == 3){
        dic = [[self.products objectAtIndex:btn.tag-OPEN]mutableCopy];
        [dic setValue:@"1" forKey:@"selected"];
        [self.products replaceObjectAtIndex:btn.tag - OPEN withObject:dic];
        [self.packageDic setObject:self.products forKey:@"products"];
        [[DataService sharedService].packageList replaceObjectAtIndex:self.index.row withObject:self.packageDic];
        
        [[DataService sharedService].package_product removeAllObjects];
        
        int tag = btn.tag;
        btn.tag = tag - OPEN + CLOSE;
        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        
    }else {
        dic = [[self.products objectAtIndex:btn.tag-CLOSE]mutableCopy];
        int product_id = [[dic objectForKey:@"id"]intValue];
        BOOL warning = NO;
        //库存
        if (![[dic objectForKey:@"mat_num"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"mat_num"]!= nil) {
            int kucun = [[dic objectForKey:@"mat_num"]intValue];
            if (kucun < 1) {//库存不足
                warning = YES;
                NSString * message = [NSString stringWithFormat:@"%@ 库存不足",[dic objectForKey:@"name"]];
                [Utils errorAlert:message];
            }
        }
        if (warning==NO) {
            if ([DataService sharedService].package_product.count >0 ) {//已经选择产品
                NSString *str = [[DataService sharedService].package_product objectAtIndex:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPackage" object:str];
            }
            [dic setValue:@"0" forKey:@"selected"];
            [self.products replaceObjectAtIndex:btn.tag - CLOSE withObject:dic];
            [self.packageDic setObject:self.products forKey:@"products"];
            [[DataService sharedService].packageList replaceObjectAtIndex:self.index.row withObject:self.packageDic];
            
            
            [DataService sharedService].package_product = [[NSMutableArray alloc]init];
            NSString *string = [self checkFormWithId:package_id andId:product_id andIdx:self.index.row];
            [[DataService sharedService].package_product addObject:string];
            
            int tag = btn.tag;
            btn.tag = tag - CLOSE + OPEN;
            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPackage" object:nil];
}
/*
- (void)clickSwitch:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
    NSMutableDictionary *dic = nil;
    int package_id = [[self.packageDic objectForKey:@"cpard_relation_id"]intValue];
    
    if (tagStr.length == 3) {
        dic = [[self.products objectAtIndex:sender.tag-OPEN]mutableCopy];
        [dic setValue:@"1" forKey:@"selected"];
        [self.products replaceObjectAtIndex:sender.tag - OPEN withObject:dic];
        
        int product_id = [[dic objectForKey:@"id"]intValue];
        int i = 0;
        while (i<[DataService sharedService].package_product.count) {
            NSString *str = [[DataService sharedService].package_product objectAtIndex:i];
            NSArray *arr = [str componentsSeparatedByString:@"_"];
            
            int pack_id = [[arr objectAtIndex:0]intValue];
            if (pack_id == package_id) {//package_id相同
                int pro_id = [[arr objectAtIndex:1]intValue];
                if (pro_id == product_id) {//product_id相同
                    [[DataService sharedService].package_product removeObjectAtIndex:i];
                    break;
                }
            }
            i++;
        }
        
        int tag = btn.tag;
        btn.tag = tag - OPEN + CLOSE;
        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
    }else {
        dic = [[self.products objectAtIndex:sender.tag-CLOSE]mutableCopy];
        int product_id = [[dic objectForKey:@"id"]intValue];
        
        if (![[dic objectForKey:@"mat_num"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"mat_num"]!= nil) {
            int kucun = [[dic objectForKey:@"mat_num"]intValue];
            BOOL warning = NO;
            if (kucun < 1) {//库存不足
                warning = YES;
                NSString * message = [NSString stringWithFormat:@"%@ 库存不足",[dic objectForKey:@"name"]];
                [Utils errorAlert:message];

            }else if ([DataService sharedService].package_product.count >0 ) {//判断库存
                int selecteedCount = 0;
                for (int i=0; i<[DataService sharedService].package_product.count; i++) {
                    NSString *str = [[DataService sharedService].package_product objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    int pro_id = [[arr objectAtIndex:1]intValue];//产品id
                    if (pro_id == product_id) {//id
                        selecteedCount = selecteedCount + 1;
                    }
                }
                selecteedCount = selecteedCount +1;
                if (kucun < selecteedCount) {
                    warning = YES;
                    NSString * message = [NSString stringWithFormat:@"%@ 库存不足",[dic objectForKey:@"name"]];
                    [Utils errorAlert:message];
                }
            }
            
            if (warning == NO) {//没有库存警告
                [dic setValue:@"0" forKey:@"selected"];
                
                [self.products replaceObjectAtIndex:sender.tag - CLOSE withObject:dic];
                
                NSString *string = [self checkFormWithId:package_id andId:product_id];
                [[DataService sharedService].package_product addObject:string];
                
                int tag = btn.tag;
                btn.tag = tag - CLOSE + OPEN;
                [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
            }
        }else {
            [dic setValue:@"0" forKey:@"selected"];
            
            [self.products replaceObjectAtIndex:sender.tag - CLOSE withObject:dic];
            
            NSString *string = [self checkFormWithId:package_id andId:product_id];
            [[DataService sharedService].package_product addObject:string];
            
            int tag = btn.tag;
            btn.tag = tag - CLOSE + OPEN;
            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
        }
    }
}
*/
@end
