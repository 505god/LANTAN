//
//  PackageCardCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-12.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PackageCardCell.h"

#define OPEN 100
#define CLOSE 1000

@implementation PackageCardCell

//type :0正常下单   1:套餐卡下单
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  with:(NSMutableDictionary *)prod indexPath:(NSIndexPath *)idx type:(NSInteger)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.product = [prod mutableCopy];
        self.index = idx;
        self.cellType = type;
        self.selectedArr = [NSMutableArray arrayWithArray:[prod objectForKey:@"products"]];
        int len = self.selectedArr.count;
        CGRect frame = CGRectMake(320, 0, 240, 44);

        for (int i=0; i<len; i++) {
            NSDictionary *dic = [self.selectedArr objectAtIndex:i];
            
            frame.origin.y = 44 * i;
            UILabel *lblProd = [[UILabel alloc] initWithFrame:frame];
            lblProd.lineBreakMode = NSLineBreakByCharWrapping;
            lblProd.numberOfLines = 0;
            lblProd.backgroundColor = [UIColor clearColor];
            int left_num = [[[self.selectedArr objectAtIndex:i] objectForKey:@"pro_left_count"]integerValue];
            if (left_num == 0) {
                lblProd.text = [NSString stringWithFormat:@"%@",[[self.selectedArr objectAtIndex:i] objectForKey:@"proname"]];
            }else {
                lblProd.text = [NSString stringWithFormat:@"%@(%d)次",[[self.selectedArr objectAtIndex:i] objectForKey:@"proname"],left_num];
            }
            
            lblProd.textAlignment = NSTextAlignmentRight;
            if ([[dic objectForKey:@"selected"] intValue] == 0 ) {
                lblProd.tag = OPEN +i+OPEN;
            }else {
                lblProd.tag = CLOSE +i+CLOSE;
            }
            
            [self addSubview:lblProd];
            if([[prod objectForKey:@"is_new"]intValue]==0){
                frame.origin.x += 225;
                frame.size.width = 80;
                frame.origin.y += 0;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = frame;
                [btn setEnabled:NO];
                if (type==0) {//正常下单
                    [btn setEnabled:YES];
                }
                [btn addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
                int num = [[[self.selectedArr objectAtIndex:i] objectForKey:@"pro_left_count"]intValue];
                if (num != 0 || (num==0 && [[dic objectForKey:@"selected"] intValue] == 0)) {
                    [self addSubview:btn];
                    
                    if ([[dic objectForKey:@"selected"] intValue] == 0 ) {
                        btn.tag = OPEN +i;
                        [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                    }else if ([[dic objectForKey:@"selected"] intValue] == 1 ){
                        btn.tag = CLOSE +i;
                        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                    }
                }

                frame.origin.x = 320;
            }else{
                frame.origin.x = 320;
            }
            
            frame.size.width = 240;
            frame.origin.y -= 10;
        }

        frame = CGRectMake(10, 7, 210, 30);
        self.lblName = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:self.lblName];
        frame.origin.x = 210;
        frame.size.width = 110;
        self.lblPrice = [[UILabel alloc] initWithFrame:frame];
        self.lblPrice.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.lblPrice];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSString *)checkFormWithIndexRow:(int)row andId:(int)product_id andNumber:(int)num {
    NSMutableString *prod_count = [NSMutableString string];
    [prod_count appendFormat:@"%d_%d_%d,",row,product_id,num];
    return prod_count;
}
//选择开关
- (void)clickSwitch:(UIButton *)sender{
//    DLog(@"self.selectedArr = %@",self.selectedArr);
    [DataService sharedService].first = NO;
    UIButton *btn = (UIButton *)sender;
    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
    NSMutableDictionary *dic;
    CGFloat x = [self.lblPrice.text floatValue];
    CGFloat y = 0;

    self.selectedArr = [NSMutableArray arrayWithArray:[[[DataService sharedService].productList objectAtIndex:self.index.row] objectForKey:@"products"]];
    
    NSArray *array = [[DataService sharedService].number_id allKeys];
    if (tagStr.length == 3) {
        dic = [[self.selectedArr objectAtIndex:sender.tag - OPEN] mutableCopy];
        NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"proid"]];
        if ([array containsObject:product_id]) {//套餐卡包含此产品／服务
            //从row_id_countArray数组中找到此产品被消费次数
            int row = self.index.row;
            int num = [[dic objectForKey:@"pro_left_count"]intValue];
            y = [[dic objectForKey:@"pprice"] floatValue];
            
            int num_count = 0;
            if ([DataService sharedService].row_id_countArray.count >0) {
                int i = 0;
                while (i<[DataService sharedService].row_id_countArray.count) {
                    NSString *str = [[DataService sharedService].row_id_countArray objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    int index_row = [[arr objectAtIndex:0]intValue];
                    
                    if (row == index_row) {//index.row相同
                        int p_id = [[arr objectAtIndex:1]intValue];
                        if (p_id == [product_id intValue]) {
                            
                            //活动通知
                            NSDictionary *productDic = [NSDictionary dictionaryWithObjectsAndKeys:product_id,@"id",[dic objectForKey:@"proname"],@"name",[dic objectForKey:@"pprice"],@"price", nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"saleReload" object:productDic];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"svcardReload" object:productDic];
                            
                            
                            //id相同
                            num_count = [[arr objectAtIndex:2]intValue];
                            y = y * num_count;
                            x =x + y ;
                            //重置number_id数据
                            int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//用户选择 剩余次数
                            [[DataService sharedService].number_id removeObjectForKey:product_id];
                            [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                            
                            [dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"pro_left_count"];
                            
                            [dic setValue:@"1" forKey:@"selected"];
                            [self.selectedArr replaceObjectAtIndex:sender.tag - OPEN withObject:dic];
                            

                            int tag = btn.tag;
                            UILabel *lab_prod = (UILabel *)[self viewWithTag:btn.tag+OPEN];
                            lab_prod.text = [NSString stringWithFormat:@"%@(%@)次",[dic objectForKey:@"proname"],[dic objectForKey:@"pro_left_count"]];
                            lab_prod.tag = btn.tag- OPEN + CLOSE+ CLOSE;
                            
                            btn.tag = tag - OPEN + CLOSE;
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            
                            NSString *price = [NSString stringWithFormat:@"%.2f",x];
                            [self.product setObject:self.selectedArr forKey:@"products"];
                            
                            [self.product setObject:price forKey:@"show_price"];
                            
                            NSString *p = [NSString stringWithFormat:@"%.2f",y];
                            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",self.product,@"prod",self.index,@"idx",@"2",@"type", nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
                            //删除
                            [[DataService sharedService].row_id_countArray removeObjectAtIndex:i];
                            DLog(@"删除row_id_countArray = %@",[DataService sharedService].row_id_countArray);
                            break;
                        }
                        
                    }
                    i++;
                }
            }else {
                int tag = btn.tag;
                
                UILabel *lab_prod = (UILabel *)[self viewWithTag:btn.tag+OPEN];
                lab_prod.text = [NSString stringWithFormat:@"%@(%@)次",[dic objectForKey:@"proname"],[dic objectForKey:@"pro_left_count"]];
                lab_prod.tag = btn.tag- OPEN + CLOSE+ CLOSE;
                
                btn.tag = tag - OPEN + CLOSE;
                [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
            }
        }
        
    }else {
        dic = [[self.selectedArr objectAtIndex:sender.tag - CLOSE] mutableCopy];
        NSString* product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"proid"]];
        if ([array containsObject:product_id]) {//套餐卡包含此产品／服务

            int num = [[dic objectForKey:@"pro_left_count"]intValue];//套餐卡里面的数目
            
            int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//用户选择的数目
            
            if (num > count_num) {//用户次数大于套餐卡提供次数
                //活动通知
                NSDictionary *productDic = [NSDictionary dictionaryWithObjectsAndKeys:product_id,@"id",[dic objectForKey:@"proname"],@"name",[dic objectForKey:@"pprice"],@"price", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saleReload" object:productDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"svcardReload" object:productDic];
            }
            count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//通知之后用户选择的数目
            y =0- [[dic objectForKey:@"pprice"] floatValue];
            if (count_num == 0) {
                [Utils errorAlert:@"您已经在其他套餐卡中使用优惠，不必再重复使用"];
            }else{
                if (num <= count_num) {//用户次数大于套餐卡提供次数
                    //初始count  --num
                    NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:num];
                    [[DataService sharedService].row_id_countArray addObject:str];
                    DLog(@"添加111row_id_countArray = %@",[DataService sharedService].row_id_countArray);
                    //用户选择的次数  －  消费的次数 （用户还需要消费的次数）>=0
                    y = y * num;
                    x = x + y;
                    //重置temp—dic数据
                    [[DataService sharedService].number_id removeObjectForKey:product_id];
                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d",count_num - num] forKey:product_id];
                    
                    [dic setObject:[NSString stringWithFormat:@"%d",num - num] forKey:@"pro_left_count"];
                }else {//用户次数小于套餐卡提供次数
                    //初始count  --count_num
                    NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:count_num];
                    [[DataService sharedService].row_id_countArray addObject:str];
                    DLog(@"添加row_id_countArray = %@",[DataService sharedService].row_id_countArray);
                    //重置temp—dic数据
                    [[DataService sharedService].number_id removeObjectForKey:product_id];
                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d",count_num - count_num] forKey:product_id];
                    
                    y = y * count_num;
                    x =x + y ;
                    
                    [dic setObject:[NSString stringWithFormat:@"%d",num - count_num] forKey:@"pro_left_count"];
                }
                [dic setValue:@"0" forKey:@"selected"];
                [dic setObject:[NSString stringWithFormat:@"%d",num] forKey:@"Total_num"];
                [self.selectedArr replaceObjectAtIndex:sender.tag - CLOSE withObject:dic];
                int tag = btn.tag;
                
                UILabel *lab_prod = (UILabel *)[self viewWithTag:btn.tag+CLOSE];
                lab_prod.text = [NSString stringWithFormat:@"%@(%@)次",[dic objectForKey:@"proname"],[dic objectForKey:@"pro_left_count"]];
                lab_prod.tag = btn.tag-CLOSE+ OPEN+ OPEN;
                
                btn.tag = tag - CLOSE + OPEN;
                [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                
                NSString *price = [NSString stringWithFormat:@"%.2f",x];
                [self.product setObject:self.selectedArr forKey:@"products"];
                [self.product setObject:price forKey:@"show_price"];
                
                NSString *p = [NSString stringWithFormat:@"%.2f",y];
                
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",self.product,@"prod",self.index,@"idx",@"2",@"type", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
            }
        }else {
            [Utils errorAlert:@"您本次消费中没有购买此产品或服务"];
        }
    }
//    DLog(@"self.selectedArr2222 = %@",self.selectedArr);
}


@end
