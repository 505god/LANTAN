//
//  OrderViewController.m
//  LanTai
//
//  Created by comdosoft on 13-12-3.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "OrderViewController.h"
#import "AppDelegate.h"
@interface OrderViewController ()

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.subview.layer setCornerRadius:8];
    [self.subview.layer setMasksToBounds:YES];
    
    self.nameLab.text = [self.p_object objectForKey:@"name"];
    self.priceLab.text = [self.p_object objectForKey:@"price"];
    if (self.number==2) {
        self.addBtn.hidden = YES;
        self.subtractBtn.hidden = YES;
        self.numLab.hidden = YES;
        self.countLab.hidden = YES;
        
        self.heLab.frame = CGRectMake(43, 130, 45, 19);
        self.totalLab.frame = CGRectMake(88, 130, 94, 19);
    }else {
        self.addBtn.hidden = NO;
        self.subtractBtn.hidden = NO;
        self.numLab.hidden = NO;
        self.countLab.hidden = NO;
        
        self.heLab.frame = CGRectMake(232, 130, 45, 19);
        self.totalLab.frame = CGRectMake(277, 130, 94, 19);
    }
    self.totalLab.text = [self.p_object objectForKey:@"price"];
    
    if ([[self.p_object objectForKey:@"s_type"]integerValue]==1) {
        self.lbl_price.hidden = YES;
        self.totalLab.hidden = YES;
        self.heLab.hidden = YES;
        
        self.numLab.frame = CGRectMake(43, 87, 45, 19);
        self.addBtn.frame = CGRectMake(92, 86, 28, 24);
        self.countLab.frame = CGRectMake(122, 87, 27, 19);
        self.subtractBtn.frame = CGRectMake(153, 86
                                            , 28, 24);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)changeNum:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int count = [self.countLab.text intValue];
    if (btn.tag == 1) {
        if (self.number==0) {
            int num =[[self.p_object objectForKey:@"num"]intValue];
            if (num<0) {
                self.countLab.text = [NSString stringWithFormat:@"%d",count+1];
                self.totalLab.text = [NSString stringWithFormat:@"%.2f",(count+1)*[[self.p_object objectForKey:@"price"]floatValue]];
            }else {
                if (count<num) {
                    self.countLab.text = [NSString stringWithFormat:@"%d",count+1];
                    self.totalLab.text = [NSString stringWithFormat:@"%.2f",(count+1)*[[self.p_object objectForKey:@"price"]floatValue]];
                    
                    self.countLab.text = [NSString stringWithFormat:@"%d",count+1];
                    self.totalLab.text = [NSString stringWithFormat:@"%.2f",(count+1)*[[self.p_object objectForKey:@"price"]floatValue]];
                }else {
                    [Utils errorAlert:@"库存不足"];
                }
            }
        }else if (self.number==1){
            if ([[self.p_object objectForKey:@"s_type"]intValue]==1) {//套装
                self.countLab.text = [NSString stringWithFormat:@"%d",count+1];
            }else {
                int num =[[self.p_object objectForKey:@"num"]intValue];
                if (num<0) {
                    self.countLab.text = [NSString stringWithFormat:@"%d",count+1];
                    self.totalLab.text = [NSString stringWithFormat:@"%.2f",(count+1)*[[self.p_object objectForKey:@"price"]floatValue]];
                }else {
                    if (count<num) {
                        self.countLab.text = [NSString stringWithFormat:@"%d",count+1];
                        self.totalLab.text = [NSString stringWithFormat:@"%.2f",(count+1)*[[self.p_object objectForKey:@"price"]floatValue]];
                        
                        self.countLab.text = [NSString stringWithFormat:@"%d",count+1];
                        self.totalLab.text = [NSString stringWithFormat:@"%.2f",(count+1)*[[self.p_object objectForKey:@"price"]floatValue]];
                    }else {
                        [Utils errorAlert:@"库存不足"];
                    }
                }
            }
        }
    }else {
        if (count>1) {
            self.countLab.text = [NSString stringWithFormat:@"%d",count-1];
            self.totalLab.text = [NSString stringWithFormat:@"%.2f",(count-1)*[[self.p_object objectForKey:@"price"]floatValue]];
        }else {
            [Utils errorAlert:@"至少选择1件"];
        }
    }
}
-(NSString *)checkForm {
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%@-%@-%d",[self.p_object objectForKey:@"id"],self.countLab.text,self.number];
    if (self.number==2) {
        [string appendFormat:@"-%@",[self.p_object objectForKey:@"type"]];
    }
    return string;
}
-(IBAction)sureBtnPressed:(id)sender {
    [DataService sharedService].price_id = [[NSMutableDictionary alloc]init];
    [DataService sharedService].number_id = [[NSMutableDictionary alloc]init];
    [DataService sharedService].id_count_price = [[NSMutableArray alloc]init];
    [DataService sharedService].saleArray = [[NSMutableArray alloc]init];
    [DataService sharedService].row_id_numArray =[[NSMutableArray alloc]init];
    [DataService sharedService].svcardArray =[[NSMutableArray alloc]init];
    [DataService sharedService].row_id_countArray =[[NSMutableArray alloc]init];
    
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        NSString *string = [self checkForm];
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        MakeOrderInterface *log = [[MakeOrderInterface alloc]init];
        self.makeOrderInterface = log;
        self.makeOrderInterface.delegate = self;
        [self.makeOrderInterface getMakeOrderInterfaceDelegateWithContent:string andNum:self.carNum];
    }
}
#pragma mark MakeOrderInterfaceDelegate

-(void)getOrderInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.product_dic = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissPopView:)]) {
                [self.delegate dismissPopView:self];
            }
        });
    });
}
-(void)getOrderInfoDidFailed:(NSString *)errorMsg {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}
@end
