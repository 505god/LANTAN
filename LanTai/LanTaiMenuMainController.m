//
//  LanTaiMenuMainController.m
//  LanTai
//
//  Created by david on 13-10-15.
//  Copyright (c) 2013年 david. All rights reserved.
//
#import "AppDelegate.h"
#import "LanTaiMenuMainController.h"
#import "CarObj.h"
#import "ShaixuanView.h"
#import "ServiceModel.h"
#import "CarPosionView.h"
#import "StationModel.h"
#import "ProAndServiceHeader.h"
#import "ComplaintViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomImageView+Addition.h"
#import "RecordTableHeader.h"
#import "ServiceCell.h"
#import "CardCell.h"
#import "SVCardCell.h"
#import "PackageCardCell.h"
#import "PackageRecordCell.h"
#import "QRadioButton.h"
#import "KeyViewController.h"
#define HEADER_IDENTIFIER @"searchResult"
#define PACKAGE_HEADER @"packageTableViewHeader"
#define PACKAGE_FOOTER @"packageTableViewFooter"
#define OPEN 100
#define CLOSE 1000
#define TagOff 100
#define TagOn 1000

#define CELL_WIDHT  200
#define CELL_POSION_WIDHT  260
#define CELL_HEIGHT 120
#define CELL_PADDING 10
#define SCROLLVIEW_LEFT_PADDING 10
#define SERVE_ITEM_HEIGHT 50
#import "PayStyleViewController.h"
@interface LanTaiMenuMainController ()<PayStyleViewDelegate,KeyViewControllerDelegate,QRadioButtonDelegate>
{
    PayStyleViewController *payStyleView;
    KeyViewController *keyViewController;
}
@property (nonatomic,strong) NSMutableArray *waittingCarsArr;
@property (nonatomic,strong) NSMutableDictionary *beginningCarsDic;
@property (nonatomic,strong) NSMutableArray *finishedCarsArr;
@property (nonatomic,strong) NSMutableArray *serveItemsArr;
@property (nonatomic,strong) NSMutableArray *posionItemArr;
@property (nonatomic,strong) NSMutableArray *stationArray;
@property (nonatomic,strong) CarCellView *moviedView;
@property (nonatomic,strong) CarPosionView *moviePosionView;
@property (nonatomic,assign) BOOL isScrollMiddleScrollView;

@property (nonatomic,strong)  NSString *sexStr;
@property (nonatomic,strong)  NSString *propertyStr;

@end

@implementation LanTaiMenuMainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)leftTapped:(id)sender{
    [self.carNumberTextField.textField resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCarYear resignFirstResponder];
    [self.txtKm resignFirstResponder];
    [self.txtCompany resignFirstResponder];
    [self.txtSearch resignFirstResponder];
    
    self.userView = nil;
    self.userView = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    self.userView.delegate = self;
    [self presentPopupViewController:self.userView animationType:MJPopupViewAnimationSlideBottomTop];
}
- (void)removeFromSuperView:(UserViewController *)userViewController; {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    self.userView = nil;
    if ([DataService sharedService].isLoging == YES) {
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        }
                         completion:^(BOOL finished){
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
        
    }
}
-(CarObj *)setAttributeWithDictionary:(NSDictionary *)result {
    CarObj *order = [[CarObj alloc]init];
    order.carID = [NSString stringWithFormat:@"%@",[result objectForKey:@"car_num_id"]];
    order.carPlateNumber = [NSString stringWithFormat:@"%@",[result objectForKey:@"num"]];
    order.orderId = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
    order.status =[NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
    if (![[result objectForKey:@"station_id"]isKindOfClass:[NSNull class]] && [result objectForKey:@"station_id"]!=nil) {
        order.stationId =[NSString stringWithFormat:@"%@",[result objectForKey:@"station_id"]];
    }
    order.serviceName = [NSString stringWithFormat:@"%@",[result objectForKey:@"service_name"]];
    order.lastTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"cost_time"]];
    order.workOrderId = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_id"]];
    if (![[result objectForKey:@"wo_started_at"]isKindOfClass:[NSNull class]] && [result objectForKey:@"wo_started_at"]!=nil) {
        order.serviceStartTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_started_at"]];
    }
    if (![[result objectForKey:@"wo_ended_at"]isKindOfClass:[NSNull class]] && [result objectForKey:@"wo_ended_at"]!=nil) {
        order.serviceEndTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_ended_at"]];
    }
    return order;
}
-(void)getData{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
    NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kService]];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
         if ([data length]>0 && error==nil) {
             [self performSelectorOnMainThread:@selector(setRespondtext:) withObject:data waitUntilDone:NO];
         }
     }
     ];
}

-(void)setRespondtext:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"resu = %@",jsonData);
            if ([[jsonData objectForKey:@"status"]intValue] == 0) {
                //工位数组
                NSArray *station_array = [jsonData objectForKey:@"station_ids"];
                self.stationArray = [[NSMutableArray alloc]init];
                if (station_array.count>0) {
                    for (int k=0; k<station_array.count; k++) {
                        NSDictionary *s_dic = [station_array objectAtIndex:k];
                        StationModel *stationM = [[StationModel alloc]init];
                        stationM.StationID = [s_dic objectForKey:@"id"];
                        stationM.name = [s_dic objectForKey:@"name"];
                        [self.stationArray addObject:stationM];
                    }
                }
                [self setBegningScrollViewContextWithPosionCount:self.stationArray];
                //服务
                NSArray *result_array = [NSArray arrayWithArray:[jsonData objectForKey:@"services"]];
                 self.dataArray = [[NSMutableArray alloc]init];
                if (result_array.count>0) {
                    for (int i=0; i<result_array.count; i++) {
                        NSDictionary *dic = [result_array objectAtIndex:i];
                        ServiceModel *service = [[ServiceModel alloc]init];
                        service.serviceId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                        service.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                        service.price = [NSString stringWithFormat:@"%@.00元",[dic objectForKey:@"price"]];
                        [self.dataArray addObject:service];
                    }
                }
                [self.orderTable reloadData];
                //订单的数组
                NSDictionary *order_dic = [jsonData objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
            }
        }
    }
    if ([DataService sharedService].firstTime == YES) {
        [DataService sharedService].firstTime = NO;
    }
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        if ([DataService sharedService].firstTime == YES) {
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
            [self getData];
        }
    }
}

-(void)netWork:(id)sender {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [self setRightBtnWith:YES];
    }else {
        //设置  判断是否要上传数据
        LanTanDB *db = [[LanTanDB alloc]init];
        NSArray *array = [db getLocalOrderInfo];
        if (array.count>0) {
            [self setRightBtnWith:NO];
        }else {
            [self setRightBtnWith:YES];
        }
    }
}

#pragma mark -同步本地信息
- (void)syncData:(id)sender {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        LanTanDB *db = [[LanTanDB alloc]init];
        NSArray *array = [db getLocalOrderInfo];
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (OrderInfo *model in array) {
            NSDictionary *dic = nil;
            if ([model.status intValue] == 2) {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:model.order_id,@"order_id",model.reason,@"reason",model.request,@"request",model.status,@"status",nil];
            }else if ([model.status intValue] == 0){
                dic = [NSDictionary dictionaryWithObjectsAndKeys:model.order_id,@"order_id",model.status,@"status",nil];
            }else {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:model.order_id,@"order_id",model.customer_id,@"customer_id",model.car_num_id,@"car_num_id",model.content,@"content",model.oprice,@"oprice",model.is_please,@"is_please",model.total_price,@"total_price",model.prods,@"prods",model.brand,@"brand",model.year,@"year",model.birth,@"birth",model.cdistance,@"cdistance",model.userName,@"userName",model.phone,@"phone",model.sex,@"sex",model.billing,@"billing",model.pay_type,@"pay_type",model.is_free,@"is_free",model.status,@"status",model.store_id,@"store_id",model.reason,@"reason",model.request,@"request",model.cproperty,@"cproperty",model.ccompany,@"cgroup_name",nil];
            }
            
            [tempArray addObject:dic];
        }
        NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
        [dicc setObject:tempArray forKey:@"order"];
        if ([NSJSONSerialization isValidJSONObject:dicc]) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicc options:NSJSONWritingPrettyPrinted error:&error];
            NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            DLog(@"json data:%@",json);
            if (json) {
                AppDelegate *app = [AppDelegate shareInstance];
                [MBProgressHUD showHUDAddedTo:app.window animated:YES];
                SyncInterface *log = [[SyncInterface alloc]init];
                self.syncInterface = log;
                self.syncInterface.delegate = self;
                [self.syncInterface getSyncInterfaceDelegateWithSyncInfo:json];
            }
        }
    }
}
#pragma mark 重置工位情况
-(void)setStationDataWithDic:(NSDictionary *)order_dic {
    self.waittingCarsArr = [[NSMutableArray alloc]init];
    self.beginningCarsDic = [[NSMutableDictionary alloc]init];
    self.finishedCarsArr = [[NSMutableArray alloc]init];
    //排队等候
    if (![[order_dic objectForKey:@"0"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"0"]!= nil) {
        NSArray *waiting_array = [order_dic objectForKey:@"0"];
        if (waiting_array.count>0) {
            for (int i=0; i<waiting_array.count; i++) {
                NSDictionary *resultt = [waiting_array objectAtIndex:i];
                CarObj *order = [self setAttributeWithDictionary:resultt];
                [self.waittingCarsArr addObject:order];
            }
        }
    }
    [self setWaittingScrollViewContext];
    //施工中
    if (![[order_dic objectForKey:@"1"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"1"]!= nil) {
        NSArray *working_array = [order_dic objectForKey:@"1"];
        if (working_array.count>0) {
            for (int i=0; i<working_array.count; i++) {
                NSDictionary *resultt = [working_array objectAtIndex:i];
                CarObj *order = [self setAttributeWithDictionary:resultt];
                [self.beginningCarsDic setValue:order forKey:order.stationId];
            }
        }
    }
    [self moveCarIntoCarPosion];
    //等待付款
    if (![[order_dic objectForKey:@"2"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"2"]!= nil) {
        NSArray *finish_array = [order_dic objectForKey:@"2"];
        if (finish_array.count>0) {
            for (int i=0; i<finish_array.count; i++) {
                NSDictionary *resultt = [finish_array objectAtIndex:i];
                CarObj *order = [self setAttributeWithDictionary:resultt];
                [self.finishedCarsArr addObject:order];
            }
        }
    }
    [self setFinishedScrollViewContext];
}
#pragma mark 上传数据回调
-(void)getSyncInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DLog(@"result = %@",result);
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            LanTanDB *db = [[LanTanDB alloc]init];
            BOOL success = [db deleteDataFromOrder];
            if (success) {
                [self setRightBtnWith:YES];
                [Utils errorAlert:@"数据上传成功"];
                
                NSDictionary *order_dic = [result objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
            }
        });
    });
}
-(void)getSyncInfoDidFailed:(NSString *)errorMsg; {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark 刷新数据
-(void)refreshData:(id)sender {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        [self getData];
    }
}
-(void)setRightBtnWith:(BOOL)success {
    self.navigationItem.leftBarButtonItems = nil;
    if (success) {
        [self addLeftnaviItemWithImage:@"peop" andImage:nil];
    }else {
        [self addLeftnaviItemWithImage:@"peop" andImage:@"data"];
    }
}

//返回按钮，到登录页面
- (void)rightTapped:(id)sender{
    [self.txtName resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCarYear resignFirstResponder];
    [self.txtKm resignFirstResponder];
    [self.txtCompany resignFirstResponder];
    [self.txtSearch resignFirstResponder];
    CGRect frame1 = CGRectMake(0, 0, 815, 724);
    CGRect frame2 = CGRectMake(-815, 0, 815, 724);
    if (self.pageValue == 8) {
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.viewLeft setFrame:frame1];
            [self.packageView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             self.pageValue=0;
                             [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                         }];
    }
    else if (self.pageValue == 3) {
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.payView setFrame:frame1];
            [self.infoView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             self.pageValue=2;
                         }];
    }else if (self.pageValue == 2) {//付款页面
        if ([DataService sharedService].payViewFrom == 0) {
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.viewLeft setFrame:frame1];
                    [self.payView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue=0;
                                 [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                             }];
        }else {
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.searchView setFrame:frame1];
                    [self.payView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue=1;
                             }];
        }
        
    }else if (self.pageValue == 1) {//搜索页面
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.viewLeft setFrame:frame1];
            [self.searchView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             self.pageValue=0;
                             [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                         }];
    }else if (self.pageValue == 0){
        [DataService sharedService].user_id = nil;
        [DataService sharedService].store_id = nil;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userId"];
        [defaults removeObjectForKey:@"storeId"];
        [defaults synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)moveCarIntoCarPosion{
    for (int index = 0; index < [self.posionItemArr count]; index++) {
        CarPosionView *posion = [self.posionItemArr objectAtIndex:index];
        StationModel *ss = (StationModel *)[self.stationArray objectAtIndex:index];
        CarObj *obj = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%@",ss.StationID]];
        
        [posion setCarObj:obj];
    }
}
-(void)setWaittingScrollViewContext{
    for (UIView *subView in [self.leftTopScrollView subviews]) {
        [subView removeFromSuperview];
    }
    for (int index = 0; index < [self.waittingCarsArr count]; index++) {
        CarCellView *view = [[CarCellView alloc] init];
        view.frame = CGRectMake(CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*index, 30, CELL_WIDHT, self.leftTopScrollView.frame.size.height-CELL_PADDING*4);
        view.tag = index;
        CarObj *obj = [self.waittingCarsArr objectAtIndex:index];
        view.carNumber = obj.carPlateNumber;
        view.state = CARWAITTING;
        
        [self.leftTopScrollView addSubview:view];
    }
    self.leftTopScrollView.contentSize = CGSizeMake((CELL_WIDHT+CELL_PADDING)*self.waittingCarsArr.count+CELL_PADDING, self.leftTopScrollView.frame.size.height);
}

-(void)setBegningScrollViewContextWithPosionCount:(NSArray *)array {
    for (UIView *posion in self.posionItemArr) {
        [posion removeFromSuperview];
    }
    [self.posionItemArr removeAllObjects];
    for (int index = 0; index < [array count]; index++) {
        CarPosionView *view = [[CarPosionView alloc] init];
        view.tag = -1;
        StationModel *ss = (StationModel *)[array objectAtIndex:index];
        view.posionID = [ss.StationID intValue];
        view.isEmpty = YES;
        view.posinName = ss.name;
        view.frame = [self getBeginningScrollViewItemRectWithIndex:index];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        view.layer.shadowOffset = (CGSize){0,2};
        [self.middleScrollView addSubview:view];
        [self.posionItemArr addObject:view];
    }
    self.middleScrollView.contentSize = CGSizeMake((CELL_POSION_WIDHT+CELL_PADDING*2)*([array count]%2==0?[array count]/2:([array count]/2+1)),self.middleScrollView.frame.size.height);
}

-(void)setFinishedScrollViewContext{
    for (UIView *subView in [self.bottomLeftScrollView subviews]) {
        [subView removeFromSuperview];
    }
    for (int index = 0; index < [self.finishedCarsArr count]; index++) {
        CarCellView *view = [[CarCellView alloc] init];
        CarObj *obj = [self.finishedCarsArr objectAtIndex:index];
        view.carNumber = obj.carPlateNumber;
        view.state = CARPAYING;
        view.frame = CGRectMake(CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*index, 30, CELL_WIDHT, self.leftTopScrollView.frame.size.height-CELL_PADDING*4);
        view.tag = index;
        view.delegate = self;
        [self.bottomLeftScrollView addSubview:view];
    }
    self.bottomLeftScrollView.contentSize = CGSizeMake((CELL_WIDHT+CELL_PADDING)*self.finishedCarsArr.count+CELL_PADDING,self.bottomLeftScrollView.frame.size.height);
}


-(void)moveCarViewFromTopRightScrollViewIntoBeginningScrollView:(CarCellView*)carView{
    DLog(@"moveCarViewFromTopRightScrollViewIntoBeginningScrollView:carViewTag:%d",carView.tag);
    if ([self.waittingCarsArr count] > 0) {
        [self.beginningCarsDic setObject:[self.waittingCarsArr objectAtIndex:0] forKey:[NSString stringWithFormat:@"%d",carView.tag]];
        CarCellView *car = (CarCellView*)[self.leftTopScrollView viewWithTag:0];
        if (car) {
            CGRect rect = [self.leftTopScrollView convertRect:car.frame toView:self.leftBackgroundView];
            [car removeFromSuperview];
            car.frame = rect;
            [self.leftBackgroundView addSubview:car];
            
            for (UIView *subView in [self.leftTopScrollView subviews]) {
                [subView removeFromSuperview];
            }
            
            [self.waittingCarsArr removeObjectAtIndex:0];
            
            for (int index = 0; index < [self.waittingCarsArr count]; index++) {
                CarCellView *view = [[CarCellView alloc] init];
                view.frame = (CGRect){CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*(index+1),CELL_PADDING,CELL_WIDHT,CELL_HEIGHT};
                view.tag = index;
                [self.leftTopScrollView addSubview:view];
            }
            
            self.leftTopScrollView.contentSize = (CGSize){(CELL_WIDHT+CELL_PADDING)*[self.waittingCarsArr count]+CELL_PADDING,CGRectGetHeight(self.leftTopScrollView.frame)};
            
            
            [UIView animateWithDuration:0.5 animations:^{
                for (int index = 0; index < [self.waittingCarsArr count]; index++) {
                    CarCellView *car = (CarCellView*)[self.leftTopScrollView viewWithTag:index];
                    car.frame = (CGRect){CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*index,CELL_PADDING,CELL_WIDHT,CELL_HEIGHT};
                }
                car.frame = [self getBeginningScrollViewItemRectWithIndex:carView.tag];
                car.tag = carView.tag;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

-(CGRect)getBeginningScrollViewItemRectWithIndex:(int)index{

    float height = (self.middleScrollView.frame.size.height-30-CELL_PADDING*2)/2;
    return (CGRect){CELL_PADDING+(CELL_POSION_WIDHT+CELL_PADDING)*(index/2),CELL_PADDING*3+(height+CELL_PADDING)*(index%2),CELL_POSION_WIDHT,height};
}

-(void)exchangeBeginningCarCellViewPositionWithTouchView:(CarCellView*)touchView{
    for (CarPosionView *subView in self.posionItemArr) {
        CGRect scrollRect = [self.leftBackgroundView convertRect:touchView.frame toView:self.middleScrollView];
        if (CGRectContainsRect(subView.frame,scrollRect) && subView.posionID != touchView.posionID) {
            
            CarObj *obj1 = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%d",touchView.posionID]];
            CarObj *obj2 = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%d",subView.posionID]];
            [self.beginningCarsDic setValue:obj1 forKey:[NSString stringWithFormat:@"%d",subView.posionID]];
            [self.beginningCarsDic setValue:obj2 forKey:[NSString stringWithFormat:@"%d",touchView.posionID]];
            [self.moviePosionView setCarObj:obj2];
            [subView setCarObj:obj1];
            [self didExchangeBeginningCarCellPosionFromIndex:touchView.posionID toIndex:subView.posionID orFromCarObj:obj1 toCarObj:obj2];
            return;
        }
    }
    
    [self.moviePosionView setIsEmpty:NO];
    
}

-(void)failureExchangeBeginningCarCellPosionFromIndex:(int)from toIndex:(int)to orFromCarObj:(CarObj*)fromObj toCarObj:(CarObj*)toObj{
    [self.beginningCarsDic setValue:fromObj forKey:[NSString stringWithFormat:@"%d",from]];
    [self.beginningCarsDic setValue:toObj forKey:[NSString stringWithFormat:@"%d",to]];
    
    for (StationModel *ss in self.stationArray) {
        if ([ss.StationID intValue] == from) {
            CarPosionView *posion1 = [self.posionItemArr objectAtIndex:[self.stationArray indexOfObject:ss]];
            [posion1 setCarObj:fromObj];
        }
    }
    
    for (StationModel *ss in self.stationArray) {
        if ([ss.StationID intValue] == to) {
            CarPosionView *posion2 = [self.posionItemArr objectAtIndex:[self.stationArray indexOfObject:ss]];
            [posion2 setCarObj:toObj];
        }
    }
}

-(void)failureMoveCarCellFromBeginningScrollViewToBottomLeftScrollViewCellPosionFromIndex:(int)from toIndex:(int)to orCarObj:(CarObj*)fromObj{
    for (StationModel *ss in self.stationArray) {
        if ([ss.StationID intValue] == from) {
            CarPosionView *posion1 = [self.posionItemArr objectAtIndex:[self.stationArray indexOfObject:ss]];
            [posion1 setCarObj:fromObj];
        }
    }
    [self.beginningCarsDic setValue:fromObj forKey:[NSString stringWithFormat:@"%d",from]];
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *subView in [self.bottomLeftScrollView subviews]) {
            if ([subView isKindOfClass:[CarCellView class]]) {
                subView.center = (CGPoint){subView.center.x - CGRectGetWidth(subView.frame),subView.center.y};
            }
        }
    } completion:^(BOOL finished) {
        if ([self.finishedCarsArr count] > 0) {
            [self.finishedCarsArr removeObjectAtIndex:0];
            [self setFinishedScrollViewContext];
        }
    }];
}

-(void)moveCarViewFromBeginningScrollViewIntoBottomRightScrollView:(CarCellView*)carView{
    CarObj *carObj = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%d",carView.posionID]];
    [self.finishedCarsArr insertObject:carObj atIndex:0];
    [self.beginningCarsDic removeObjectForKey:[NSString stringWithFormat:@"%d",carView.posionID]];
    
    CGRect rect = (CGRect){CELL_PADDING,CELL_PADDING,CELL_WIDHT,CELL_HEIGHT};
    for (UIView *subView in [self.bottomLeftScrollView subviews]) {
        [subView removeFromSuperview];
    }
    for (int index = 0; index < [self.finishedCarsArr count]; index++) {
        CarCellView *view = [[CarCellView alloc] init];
        view.frame = (CGRect){CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*(index-1),CELL_PADDING*2,CELL_WIDHT,CELL_HEIGHT-CELL_PADDING*4};
        view.tag = index;
        CarObj *obj = [self.finishedCarsArr objectAtIndex:index];
        view.carNumber = obj.carPlateNumber;
        view.state = CARPAYING;
        view.delegate = self;
        if (index == 0) {
            [view setHidden:YES];
        }
        [self.bottomLeftScrollView addSubview:view];
    }
    
    self.bottomLeftScrollView.tag = -1;
    [UIView animateWithDuration:0.5 animations:^{
        for (int index = 0; index < [self.finishedCarsArr count]; index++) {
            CarCellView *view = (CarCellView*)[self.bottomLeftScrollView viewWithTag:index];
            view.frame = (CGRect){CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*index,CELL_PADDING*2,CELL_WIDHT,CELL_HEIGHT-CELL_PADDING*4};
        }
        carView.frame = [self.bottomLeftScrollView convertRect:rect toView:self.leftBackgroundView];
    } completion:^(BOOL finished) {
        CarCellView *view = (CarCellView*)[self.bottomLeftScrollView viewWithTag:0];
        [view setHidden:NO];
        [carView removeFromSuperview];
        self.bottomLeftScrollView.contentSize = (CGSize){(CELL_WIDHT+CELL_PADDING)*[self.finishedCarsArr count]+CELL_PADDING,CGRectGetHeight(self.bottomLeftScrollView.frame)};
        [self didMoveCarCellFromBeginningScrollViewToBottomLeftScrollViewCellPosionFromIndex:carView.posionID toIndex:0 orCarObj:carObj];
    }];
}
#pragma mark 生日
-(void)dateChanged:(id)sender {
    self.txtBirth.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}
- (void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    [super viewDidLoad];
    [self addLeftnaviItemWithImage:@"peop" andImage:nil];
    //搜索
    self.searchTable = nil;
    self.searchTable = [[UITableView alloc]initWithFrame:CGRectMake(96, 160, 636, 500)];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
    [self.searchTable registerClass:[ProAndServiceHeader class] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    [self.searchView addSubview:self.searchTable];

    self.isExitSvcard = NO;
    [DataService sharedService].payNumber=0;
    //日期得pickerView
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.pickerView.maximumDate = [NSDate date];
    [self.pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    self.leftTopScrollView.tag = -1;
    self.bottomLeftScrollView.tag = -1;
    
    self.middleScrollView.showsHorizontalScrollIndicator = NO;
    self.middleScrollView.showsVerticalScrollIndicator = NO;
    //字母数组
    self.letterArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];

    self.carNumberTextField.textField.placeholder = @"请输入车牌号码";
    __weak LanTaiMenuMainController *weakSelf = self;
    [self.carNumberTextField setTextValidationBlock:^BOOL(NSString *text) {
        NSString *emailRegex = @"[\u4E00-\u9FFF]+[A-Za-z]{1}+[A-Z0-9a-z]{5}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:text]) {
            weakSelf.carNumberTextField.alertView.title = kTip;
            weakSelf.carNumberTextField.alertView.message= @"输入正确的车牌号码!";
            return NO;
        }else {
            NSArray *array = [[NSArray alloc]initWithObjects:@"京",@"沪",@"津",@"渝",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新", nil];
            
            NSString *firstLetter = [text substringToIndex:1];
            if (![array containsObject:firstLetter]) {
                weakSelf.carNumberTextField.alertView.title = @"输入正确的车牌号码!";
                return NO;
            }else {
                return YES;
            }
        }  
    }];
    self.carNumberTextField.delegate = self;
    //筛选车牌
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sure:) name:@"sure" object:nil];
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.carNumberTextField.textField];
    
    
    //下拉刷新
    __block LanTaiMenuMainController *manView = self;
    __block UITableView *orderTable_temp = self.orderTable;
    __block BZGFormField *carNumTxt = self.carNumberTextField;
    [_orderTable addPullToRefreshWithActionHandler:^{
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else {
            [carNumTxt.textField resignFirstResponder];
            [manView getData];
        }
        [orderTable_temp.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    [self.searchTable registerClass:[ProAndServiceHeader class] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    
    self.selectClassify = 0;

    self.dataDictionary = [[NSMutableDictionary alloc]init];
    
    //更新总价
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTotal:) name:@"update_total" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saleReload:) name:@"saleReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(svcardReload:) name:@"svcardReload" object:nil];
    //套餐卡页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPackage:) name:@"reloadPackage" object:nil];
    //控制页面
    self.pageValue=0;
    [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
    //性别
    QRadioButton *rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"sex"];
    QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"sex"];
    rb1.frame = CGRectMake(5,3,22,22);
    rb2.frame = CGRectMake(72,3,22,22);
    rb1.tag = 0;
    rb2.tag = 1;
    [self.sexSelectedView addSubview:rb1];
    [self.sexSelectedView addSubview:rb2];
    //属性
    QRadioButton *p1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"property"];
    QRadioButton *p2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"property"];
    p1.frame = CGRectMake(5,3,22,22);
    p2.frame = CGRectMake(72,3,22,22);
    p1.tag = 0;
    p2.tag = 1;
    [self.propertySelectedView addSubview:p1];
    [self.propertySelectedView addSubview:p2];
    
    [self.infoView addGestureRecognizer:self.tapGesture];
    self.searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_background"]];
    self.payView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_background"]];
    self.infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_background"]];
    self.packageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_background"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImge:) name:@"showImge" object:nil];
    
    UIColor * cc = [UIColor grayColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = [NSString stringWithFormat:@"%@",[DataService sharedService].userModel.store_name];
    
    CGRect frame2;
    if (Platform>=7.0) {
        frame2 = CGRectMake(0, 44, 1024, 724);
    }else {
        frame2 = CGRectMake(0, 0, 1024, 724);
    }
    self.sub_view.frame = frame2;
}
-(void)showImge:(NSNotification *)object {
    [self.txtSearch resignFirstResponder];
}

#pragma mark 语音

-(void)hideKeyBoard:(UITapGestureRecognizer *)recognizer {
    [self.txtName resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCarYear resignFirstResponder];
    [self.txtKm resignFirstResponder];
    [self.txtCompany resignFirstResponder];
}
-(IBAction)actionToHideKeyBoard:(id)sender {
    [self.txtName resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCarYear resignFirstResponder];
    [self.txtKm resignFirstResponder];
    [self.txtCompany resignFirstResponder];
}
#pragma mark 搜索关键字种类
-(IBAction)classifyBtnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_active",btn.tag]] forState:UIControlStateNormal];
    NSArray *subViews = [self.searchView subviews];
    for (UIView *vv in subViews) {
        if ([vv isKindOfClass:[UIButton class]]) {
            UIButton *vvBtn = (UIButton *)vv;
            if (vvBtn.tag!=999 && vvBtn.tag!=btn.tag) {
                [vvBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_normal",vvBtn.tag]] forState:UIControlStateNormal];
            }
        }
    }
    self.selectClassify = btn.tag;
    
    if (self.selectClassify==0) {
        if (![[self.dataDictionary objectForKey:@"productName"]isKindOfClass:[NSNull class]] && [self.dataDictionary objectForKey:@"productName"]!=nil) {
            self.searchResult = [self.dataDictionary objectForKey:@"product"];
            self.txtSearch.text = [self.dataDictionary objectForKey:@"productName"];
        }else {
            self.searchResult = nil;
            self.txtSearch.text = nil;
        }
    }else if (self.selectClassify==1) {
        if (![[self.dataDictionary objectForKey:@"serviceName"]isKindOfClass:[NSNull class]] && [self.dataDictionary objectForKey:@"serviceName"]!=nil) {
            self.searchResult = [self.dataDictionary objectForKey:@"service"];
            self.txtSearch.text = [self.dataDictionary objectForKey:@"serviceName"];
        }else {
            self.searchResult = nil;
            self.txtSearch.text = nil;
        }
    }else {
        if (![[self.dataDictionary objectForKey:@"cardName"]isKindOfClass:[NSNull class]] && [self.dataDictionary objectForKey:@"cardName"]!=nil) {
            self.searchResult = [self.dataDictionary objectForKey:@"card"];
            self.txtSearch.text = [self.dataDictionary objectForKey:@"cardName"];
        }else {
            self.searchResult = nil;
            self.txtSearch.text = nil;
        }
    }
    [self.searchTable reloadData];
}
- (void)sure:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    NSString *str = [dic objectForKey:@"name"];
    self.carNumberTextField.textField.text = str;
    [UIView animateWithDuration:0.35 animations:^{
        self.sxView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.sxView.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.sxView.view removeFromSuperview];
            self.sxView = nil;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 付款---------付款
-(void)carCellViewDidSelected:(CarCellView *)view{
    CarObj *carObject = (CarObj *)[self.finishedCarsArr objectAtIndex:view.tag];
    if ([carObject.status integerValue]==8) {
        [Utils errorAlert:@"订单已确认,请到后台付款!"];
    }else if ([carObject.status integerValue]==9){//套餐卡支付
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else {
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
            [params setObject:carObject.orderId forKey:@"order_id"];
            NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kPackageOrderinfo]];
            NSOperationQueue *queue=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
                if ([data length]>0 && error==nil) {
                    [self performSelectorOnMainThread:@selector(package_payMoney:) withObject:data waitUntilDone:NO];
                }
            }
             ];
        }
//        self.packagePayView = nil;
//        self.packagePayView = [[PackagePayView alloc]initWithNibName:@"PackagePayView" bundle:nil];
//        self.packagePayView.delegate = self;
//        self.packagePayView.order_id = [NSString stringWithFormat:@"%@",carObject.orderId];
//        [self presentPopupViewController:self.packagePayView animationType:MJPopupViewAnimationSlideBottomTop];
    }else {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else {
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
            [params setObject:carObject.orderId forKey:@"order_id"];
            NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kOrderinfo]];
            NSOperationQueue *queue=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
                 if ([data length]>0 && error==nil) {
                     [self performSelectorOnMainThread:@selector(payMoney:) withObject:data waitUntilDone:NO];
                 }
             }
             ];
        }
    }
}
//套餐卡支付
- (void)dismissPackagePayView:(PackagePayView *)packagePayView andResult:(NSDictionary*)result;{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    
    //工位情况
    NSDictionary *order_dic = [result objectForKey:@"orders"];
    [self setStationDataWithDic:order_dic];
    
    if (packagePayView.type==0) {
        [Utils errorAlert:@"取消订单成功!"];
    }else if (packagePayView.type==1){
        [Utils errorAlert:@"支付成功!"];
    }
    self.packagePayView=nil;
}
-(void)layoutViewWithDictionary:(NSDictionary *)p_dic {
    //付款
    [self.payTable removeFromSuperview];
    self.payTable = nil;
    self.payTable = [[UITableView alloc]initWithFrame:CGRectMake(96, 160, 636, 450)];
    self.payTable.delegate = self;
    self.payTable.dataSource = self;
    [self.payTable registerClass:[ProAndServiceHeader class] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    [self.payView addSubview:self.payTable];
    
    //储值卡
    self.save_cardArray = [NSMutableArray arrayWithArray:[p_dic objectForKey:@"save_cards"]];
    
    //车辆品牌型号
    if (self.brandList.count==0) {
        self.brandList = [[NSMutableArray alloc]init];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[p_dic objectForKey:@"car_info"]];
        [self initBrandListWithArray:tempArray];
        [self addDataToBrandAndmodelWithArray:self.brandList];
    }
    
    //订单信息
    self.customer = nil;
    self.customer = [[NSMutableDictionary alloc]initWithDictionary:[p_dic objectForKey:@"order_infos"]];
    if (self.make_order==0) {
        self.addInfo.hidden=YES;
        [self.pay_btn setTitle:@"确认" forState:UIControlStateNormal];
        [self.pay_btn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.pay_btn addTarget:self action:@selector(package_payOrder:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        self.addInfo.hidden=NO;
        [self.pay_btn setTitle:[NSString stringWithFormat:@"%@",[DataService sharedService].isJurisdiction==1?@"付款":@"确认"] forState:UIControlStateNormal];
        [self.pay_btn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.pay_btn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.payResult = [[NSMutableArray alloc]init];
    if ([p_dic objectForKey:@"product"]) {
        [self.payResult addObjectsFromArray:[p_dic objectForKey:@"product"]];
    }
    if ([p_dic objectForKey:@"sales"]) {
        [self.payResult addObjectsFromArray:[p_dic objectForKey:@"sales"]];
    }
    if ([p_dic objectForKey:@"sv_cards"]) {
        [self.payResult addObjectsFromArray:[p_dic objectForKey:@"sv_cards"]];
    }
    if ([p_dic objectForKey:@"p_cards"]) {
        NSArray *p_card_array = [NSArray arrayWithArray:[p_dic objectForKey:@"p_cards"]];
        for (NSDictionary *dic in p_card_array) {
            NSArray *product_array = [NSArray arrayWithArray:[dic objectForKey:@"products"]];
            if (product_array.count>0) {
                BOOL isOk = NO;
                int k=0;
                while (k<product_array.count) {
                    NSDictionary *product_dic = [product_array objectAtIndex:k];
                    int left_num = [[product_dic objectForKey:@"pro_left_count"]integerValue];
                    if (left_num>0) {
                        isOk= YES;
                        [self.payResult addObject:dic];
                        break;
                    }else
                        k++;
                }
            }
        }
    }
    if (self.make_order==0) {//套餐卡下单
        for (int i=0; i<self.payResult.count; i++) {
            NSMutableDictionary *product = [NSMutableDictionary dictionaryWithDictionary:[self.payResult objectAtIndex:i]];
            if ([product objectForKey:@"id"]) {//产品
                NSString *p_id = [NSString stringWithFormat:@"%@",[product objectForKey:@"id"]];//产品id
                for (int j=0; j<self.payResult.count; j++){
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.payResult objectAtIndex:j]];
                    BOOL isExit=NO;
                    if([dic objectForKey:@"pid"]){//套餐卡
                      NSMutableArray *p_array = [NSMutableArray arrayWithArray:[dic objectForKey:@"products"]];
                        if (p_array.count>0) {
                            for (int k=0; k<p_array.count; k++) {
                                NSMutableDictionary *p_dic =[NSMutableDictionary dictionaryWithDictionary:[p_array objectAtIndex:k]];//套餐里包含产品
                                NSString * product_id = [NSString stringWithFormat:@"%@",[p_dic objectForKey:@"proid"]];
                                
                                if ([p_id isEqualToString:product_id]) {
                                    isExit=YES;
                                    int num = [[p_dic objectForKey:@"pro_left_count"]intValue];
                                    [p_dic setValue:[NSString stringWithFormat:@"%d",num-1] forKey:@"pro_left_count"];
                                    [p_dic setValue:@"0" forKey:@"selected"];
                                    [p_array replaceObjectAtIndex:k withObject:p_dic];
                                    [dic setObject:p_array forKey:@"products"];
                                    [self.payResult replaceObjectAtIndex:j withObject:dic];
                                    break;
                                }
                            }
                        }
                    }
                    if (isExit==YES) {
                        break;
                    }
                }
            }
        }
    }
    [DataService sharedService].productList = [NSMutableArray arrayWithArray:self.payResult];
    //车牌
    self.lblCarNum.text = [NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cnum"]];
    self.txtCarNum.text = self.lblCarNum.text;
    //车辆品牌，型号
    if (![[self.customer objectForKey:@"cbrand"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cbrand"]!=nil) {
        if (![[self.customer objectForKey:@"cmodel"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cmodel"]!=nil) {
            self.lblBrand.text = [NSString stringWithFormat:@"%@-%@",[self.customer objectForKey:@"cbrand"],[self.customer objectForKey:@"cmodel"]];
        }else {
            self.lblBrand.text = [NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cbrand"]];
        }
    }else {
        CapitalModel *capital = (CapitalModel *)[self.brandList objectAtIndex:0];
        BrandModel *brand = (BrandModel *)[capital.barndList objectAtIndex:0];
        ModelModel *model = (ModelModel *)[brand.modelList objectAtIndex:0];
        self.lblBrand.text = [NSString stringWithFormat:@"%@-%@",brand.name,model.name];
    }
    [self initBrandView];
    self.txtBrand.text = self.lblBrand.text;
    //订单号
    self.lblcode.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"ocode"]];
    //姓名
    if (![[self.customer objectForKey:@"cname"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cname"]!=nil) {
        self.lblUsername.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cname"]];
    }else {
        self.lblUsername.text = @"";
    }
    self.txtName.text = self.lblUsername.text;
    //电话
    if (![[self.customer objectForKey:@"cmoilephone"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cmoilephone"]!=nil) {
        self.lblPhone.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cmoilephone"]];
    }else {
        self.lblPhone.text = @"";
    }
    self.txtPhone.text = self.lblPhone.text;
    //性别
    if (![[self.customer objectForKey:@"csex"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"csex"]!=nil) {
        self.sexStr = [NSString stringWithFormat:@"%@",[self.customer objectForKey:@"csex"]];
    }else {
        self.sexStr = @"0";
    }
    //属性
    if (![[self.customer objectForKey:@"cproperty"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cproperty"]!=nil) {
        self.propertyStr = [NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cproperty"]];
        if ([self.propertyStr integerValue]==0) {
            self.lblproperty.text = @"个人";
            self.txtCompany.text = @"";
            self.lblCompany.text = @"";
            self.lblCompany.hidden = YES;
            self.lbl_company.hidden = YES;
        }else {
            self.lblproperty.text = @"单位";
            self.lblCompany.hidden = NO;
            self.lbl_company.hidden = NO;
            if (![[self.customer objectForKey:@"cgroup_name"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cgroup_name"]!=nil) {
                self.txtCompany.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cgroup_name"]];
                self.lblCompany.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cgroup_name"]];
            }else {
                self.txtCompany.text = @"";
                self.lblCompany.text = @"";
            }
        }
    }else {
        self.propertyStr = @"0";
        self.lblproperty.text = @"个人";
        self.txtCompany.text = @"";
        self.lblCompany.text = @"";
        self.lblCompany.hidden = YES;
        self.lbl_company.hidden = YES;
    }
    //里程
    if (![[self.customer objectForKey:@"cdistance"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cdistance"]!=nil) {
        self.txtKm.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cdistance"]];
    }else {
        self.txtKm.text = @"";
    }
    //生日
    if (![[self.customer objectForKey:@"cbirthday"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cbirthday"]!=nil) {
        self.txtBirth.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cbirthday"]];
        self.pickerView.date = [self.dateFormatter dateFromString:self.txtBirth.text];
    }else {
        self.txtBirth.text = @"";
        self.pickerView.date = [NSDate date];
    }
    //购车时间
    if (![[self.customer objectForKey:@"cbuyyear"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"cbuyyear"]!=nil) {
        self.txtCarYear.text =[NSString stringWithFormat:@"%@",[self.customer objectForKey:@"cbuyyear"]];
    }else {
        self.txtCarYear.text = @"";
    }
    //总价
    if (self.make_order==0) {//套餐卡下单
        self.total_count = 0;
        self.lblTotal.text = @"合计:0元";
    }else {
        self.total_count =[[self.customer objectForKey:@"oprice"]floatValue];
        self.lblTotal.text = [NSString stringWithFormat:@"合计:%.2f元",[[self.customer objectForKey:@"oprice"]floatValue]];
    }
    [DataService sharedService].total_count = self.total_count;
    //满意度
    [self.svSegBtn removeFromSuperview];
    self.svSegBtn = nil;
    self.svSegBtn = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不满意",@"一般", @"好",@"很好", nil]];
    [self.svSegBtn addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	self.svSegBtn.crossFadeLabelsOnDrag = YES;
	self.svSegBtn.thumb.tintColor = [UIColor colorWithRed:0.9882 green:0.1647 blue:0.1686 alpha:1];
	self.svSegBtn.backgroundImage = [UIImage imageNamed:@"svBtn"];
    self.svSegBtn.frame = CGRectMake(7, 42, 322, 40);
    if (![[self.customer objectForKey:@"oplease"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"oplease"]!=nil) {
        self.svSegBtn.selectedIndex = [[self.customer objectForKey:@"oplease"]intValue];
        self.svSegBtn.isCanSelected = NO;
    }else {
        self.svSegBtn.selectedIndex = 3;
        self.svSegBtn.isCanSelected = YES;
    }
    [self.pay_bottom_view addSubview:self.svSegBtn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame1 = CGRectMake(0, 0, 815, 724);
        CGRect frame2 = CGRectMake(-815, 0, 815, 724);
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.payView setFrame:frame1];
            [self.searchView setFrame:frame2];
            [self.viewLeft setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             
                             if (self.selectClassify==0) {
                                 self.searchResult=nil;
                                 [self.searchTable reloadData];
                                 [self.dataDictionary removeObjectForKey:@"product"];
                                 [self.dataDictionary removeObjectForKey:@"productName"];
                             }
                             [DataService sharedService].first = YES;
                             self.pageValue = 2;
                             [self.payTable reloadData];
                         }];
        
    });

}
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
	if (segmentedControl.selectedIndex == 0) {
        if (![[self.customer objectForKey:@"oplease"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"oplease"]!=nil) {
            if (![[self.customer objectForKey:@"oplease"]intValue]==0) {
                ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
                complaint.info = [NSMutableDictionary dictionaryWithDictionary:self.customer];
                [self.navigationController pushViewController:complaint animated:YES];
            }
        }else {
            ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
            complaint.info = [NSMutableDictionary dictionaryWithDictionary:self.customer];
            [self.navigationController pushViewController:complaint animated:YES];
        }
    }
}
-(void)package_payMoney:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *p_dic=(NSDictionary *)jsonObject;
            if ([[p_dic objectForKey:@"status"]intValue] == 1) {
                self.make_order=0;
                [self addRightnaviItemsWithImage:@"shareBt" andImage:@"refresh"];
                self.prod_type = [NSString stringWithFormat:@"%@",[p_dic objectForKey:@"prod_type"]];
                [DataService sharedService].price_id = [[NSMutableDictionary alloc]init];
                [DataService sharedService].number_id = [[NSMutableDictionary alloc]init];
                [DataService sharedService].id_count_price = [[NSMutableArray alloc]init];
                [DataService sharedService].saleArray = [[NSMutableArray alloc]init];
                [DataService sharedService].row_id_numArray =[[NSMutableArray alloc]init];
                [DataService sharedService].svcardArray =[[NSMutableArray alloc]init];
                [DataService sharedService].row_id_countArray =[[NSMutableArray alloc]init];
                [self layoutViewWithDictionary:p_dic];
                [DataService sharedService].payViewFrom = 0;
            }else if ([[p_dic objectForKey:@"status"]intValue] == 0) {
                NSDictionary *order_dic = [p_dic objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
                [Utils errorAlert:[p_dic objectForKey:@"msg"]];
            }
        }
    }
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
}
#pragma mark 获取优惠 order_info status  1 已经付过款  0 操作成功
-(void)payMoney:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *p_dic=(NSDictionary *)jsonObject;
            if ([[p_dic objectForKey:@"status"]intValue] == 1) {
                self.make_order=1;
                [self addRightnaviItemsWithImage:@"shareBt" andImage:@"refresh"];
                self.prod_type = [NSString stringWithFormat:@"%@",[p_dic objectForKey:@"prod_type"]];
                [DataService sharedService].price_id = [[NSMutableDictionary alloc]init];
                [DataService sharedService].number_id = [[NSMutableDictionary alloc]init];
                [DataService sharedService].id_count_price = [[NSMutableArray alloc]init];
                [DataService sharedService].saleArray = [[NSMutableArray alloc]init];
                [DataService sharedService].row_id_numArray =[[NSMutableArray alloc]init];
                [DataService sharedService].svcardArray =[[NSMutableArray alloc]init];
                [DataService sharedService].row_id_countArray =[[NSMutableArray alloc]init];
                [self layoutViewWithDictionary:p_dic];
                [DataService sharedService].payViewFrom = 0;
            }else if ([[p_dic objectForKey:@"status"]intValue] == 0) {
                NSDictionary *order_dic = [p_dic objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
                [Utils errorAlert:[p_dic objectForKey:@"msg"]];
            }
        }
    }
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
}
#pragma mark property
-(CarBrandModel *)car_brand {
    if (_car_brand==nil) {
        _car_brand = [[CarBrandModel alloc]init];
    }
    return _car_brand;
}
-(NSMutableArray *)waittingCarsArr{
    if (!_waittingCarsArr) {
        _waittingCarsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _waittingCarsArr;
}

-(NSMutableDictionary *)beginningCarsDic{
    if (!_beginningCarsDic) {
        _beginningCarsDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _beginningCarsDic;
}

-(NSMutableArray *)finishedCarsArr{
    if (!_finishedCarsArr) {
        _finishedCarsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _finishedCarsArr;
}

-(NSMutableArray *)serveItemsArr{
    if (!_serveItemsArr) {
        _serveItemsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _serveItemsArr;
}

-(NSMutableArray *)posionItemArr{
    if (!_posionItemArr) {
        _posionItemArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _posionItemArr;
}
-(NSMutableArray *)stationArray{
    if (!_stationArray) {
        _stationArray = [NSMutableArray array];
    }
    return _stationArray;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark --

- (void)refreshServeItemsBtClicked:(id)sender {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        [DataService sharedService].firstTime = YES;
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        [self getData];
    }
}

- (IBAction)touchDragGesture:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.middleScrollView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        for (UIView *subView in [self.middleScrollView subviews]) {
            if ([subView isKindOfClass:[CarPosionView class]]) {
                CarCellView *cellView = [((CarPosionView*)subView) carView];
                CGRect carRect = [subView convertRect:cellView.frame toView:self.middleScrollView];
                if ([subView isKindOfClass:[CarPosionView class]] && CGRectContainsPoint(carRect, point) && ![((CarPosionView*)subView) isEmpty]) {
                    
                    self.moviedView = [cellView copyCarCellView];
                    self.moviePosionView = (CarPosionView*)subView;
                    self.moviedView.posionID = self.moviePosionView.posionID;
                    [self.leftBackgroundView addSubview:self.moviedView];
                    self.moviedView.beforeMoiveRect = carRect;
                    self.moviedView.parentViewRect = subView.frame;
                    [self.moviedView setHidden:YES];
                    self.moviePosionView.isEmpty = YES;
                    self.isScrollMiddleScrollView = NO;
                    break;
                }
            }
        }
    }else
        if (sender.state == UIGestureRecognizerStateEnded) {
            if (self.moviedView) {
                //drag down
                if (CGRectGetMaxY(self.moviedView.frame) - CGRectGetMinY(self.bottomLeftScrollView.frame) > 20) {
                    [self moveCarViewFromBeginningScrollViewIntoBottomRightScrollView:self.moviedView];
                }else{
                    //drag exchang
                    [self exchangeBeginningCarCellViewPositionWithTouchView:self.moviedView];
                }
                
                self.moviedView.frame = self.moviedView.beforeMoiveRect;
                [self.moviedView removeFromSuperview];
                self.moviedView = nil;
                self.moviePosionView = nil;
            }
            
        }else{
            if (self.moviedView) {
                CGPoint movepoint = [sender locationInView:self.leftBackgroundView];
                if (CGRectGetMaxX(self.leftBackgroundView.frame) < CGRectGetMaxX(self.moviedView.frame) && !self.isScrollMiddleScrollView) {
                    [self.middleScrollView startScrollContentWithStep:CELL_WIDHT/4];
                    self.isScrollMiddleScrollView = YES;
                }else
                if (CGRectGetMinX(self.moviedView.frame) <= 0 && !self.isScrollMiddleScrollView) {
                    [self.middleScrollView startScrollContentWithStep:-CELL_WIDHT/4];
                    self.isScrollMiddleScrollView = YES;
                }else
                if (self.isScrollMiddleScrollView) {
                    if (movepoint.x < self.moviedView.center.x && CGRectGetMaxX(self.leftBackgroundView.frame) <= CGRectGetMaxX(self.moviedView.frame)) {
                        [self.middleScrollView stopScroll];
                        self.moviedView.center = movepoint;
                        self.isScrollMiddleScrollView = NO;
                    }else
                    if (movepoint.x > self.moviedView.center.x && CGRectGetMinX(self.moviedView.frame) <= 0) {
                        [self.middleScrollView stopScroll];
                        self.moviedView.center = movepoint;
                        self.isScrollMiddleScrollView = NO;
                    }else{
                        self.moviedView.center = (CGPoint){(CGRectGetMaxX(self.moviedView.frame) < CGRectGetMaxX(self.leftBackgroundView.frame) || CGRectGetMinX(self.moviedView.frame) >=0)?movepoint.x:self.moviedView.center.x,movepoint.y};
                    }
                }
                else{
                    self.moviedView.center = movepoint;
                    [self.moviedView setHidden:NO];
                }
            }
        }
}

#pragma mark 调整工位
static NSString *work_order_id_station_id = nil;
static NSMutableDictionary *work_dic = nil;
-(void)didExchangeBeginningCarCellPosionFromIndex:(int)from toIndex:(int)to orFromCarObj:(CarObj*)fromObj toCarObj:(CarObj*)toObj{
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        work_dic = [[NSMutableDictionary alloc]init];
        [work_dic setObject:[NSString stringWithFormat:@"%d",from] forKey:@"from"];
        [work_dic setObject:[NSString stringWithFormat:@"%d",to] forKey:@"to"];
        [work_dic setObject:fromObj forKey:@"fromObj"];
        if (toObj) {
            work_order_id_station_id = [NSString stringWithFormat:@"%@_%@,%@_%@",toObj.workOrderId,fromObj.stationId,fromObj.workOrderId,toObj.stationId];
            
            [work_dic setObject:toObj forKey:@"toObj"];
        }else {
            work_order_id_station_id = [NSString stringWithFormat:@"%@_%d",fromObj.workOrderId,to];
        }
        
        if (work_order_id_station_id) {
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
            [params setObject:[DataService sharedService].user_id forKey:@"user_id"];
            [params setObject:work_order_id_station_id forKey:@"wo_station_ids"];
            DLog(@"params = %@",params);
            NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kStation]];
            NSOperationQueue *queue=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
                 if ([data length]>0 && error==nil) {
                     [self performSelectorOnMainThread:@selector(selectStation:) withObject:data waitUntilDone:NO];
                 }
             }
             ];
        }
    }
}
#pragma mark 切换工位  status 0 代表成功， 1代表后台出错
-(void)selectStation:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"jsonData = %@",jsonData);
            if ([[jsonData objectForKey:@"status"]intValue] == 0) {
                NSDictionary *order_dic = [jsonData objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
            }else {
                [Utils errorAlert:[jsonData objectForKey:@"msg"]];
                int from = [[work_dic objectForKey:@"from"]intValue];
                int to = [[work_dic objectForKey:@"to"]intValue];
                CarObj *fromObj = (CarObj *)[work_dic objectForKey:@"fromObj"];
                if (![[work_dic objectForKey:@"toObj"]isKindOfClass:[NSNull class]] && [work_dic objectForKey:@"toObj"]!=nil) {
                    CarObj *toObj = (CarObj *)[work_dic objectForKey:@"toObj"];
                    
                    [self failureExchangeBeginningCarCellPosionFromIndex:from toIndex:to orFromCarObj:fromObj toCarObj:toObj];
                }else {
                    [self failureExchangeBeginningCarCellPosionFromIndex:from toIndex:to orFromCarObj:fromObj toCarObj:NULL];
                }
            }
        }
    }
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}
#pragma mark 施工完成

static NSString *work_order_id = nil;
static NSMutableDictionary *finish_dic = nil;
-(void)didMoveCarCellFromBeginningScrollViewToBottomLeftScrollViewCellPosionFromIndex:(int)from toIndex:(int)to orCarObj:(CarObj*)fromObj{
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        finish_dic = [[NSMutableDictionary alloc]init];
        [finish_dic setObject:[NSString stringWithFormat:@"%d",from] forKey:@"from"];
        [finish_dic setObject:[NSString stringWithFormat:@"%d",to] forKey:@"to"];
        [finish_dic setObject:fromObj forKey:@"carObj"];
        
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        work_order_id = fromObj.workOrderId;
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
        [params setObject:[DataService sharedService].user_id forKey:@"user_id"];
        [params setObject:work_order_id forKey:@"work_order_id"];
        NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kWaitPay]];
        NSOperationQueue *queue=[[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
             if ([data length]>0 && error==nil) {
                 [self performSelectorOnMainThread:@selector(finishOrder:) withObject:data waitUntilDone:NO];
             }
         }
         ];
    }
}
#pragma mark手动等待付款work_order_finished  status  0 表示此车已在等待付款行列  1 操作成功  2 工单未找到
-(void)finishOrder:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"jsonData = %@",jsonData);
            if ([[jsonData objectForKey:@"status"]intValue] == 1) {
                NSDictionary *order_dic = [jsonData objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
            }else if ([[jsonData objectForKey:@"status"]intValue] == 0) {
                NSDictionary *order_dic = [jsonData objectForKey:@"orders"];
                
                [self setStationDataWithDic:order_dic];
                [Utils errorAlert:@"已经开始等待付款!"];
            }else {
                [Utils errorAlert:[jsonData objectForKey:@"msg"]];
                int from = [[finish_dic objectForKey:@"from"]intValue];
                int to = [[finish_dic objectForKey:@"to"]intValue];
                CarObj *obj = (CarObj *)[finish_dic objectForKey:@"carObj"];
                [self failureMoveCarCellFromBeginningScrollViewToBottomLeftScrollViewCellPosionFromIndex:from toIndex:to orCarObj:obj];
            }
        }
    }
    
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}
#pragma mark 快速下单选择服务
-(void)quickToMakeOrder {
    if (self.carNumberTextField.textField.text.length != 0) {
        ServiceModel *service = (ServiceModel *)[self.dataArray objectAtIndex:self.idx_path.row];
        service_id = [NSString stringWithFormat:@"%@",service.serviceId];
        if (service_id) {
            if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
                [Utils errorAlert:@"暂无网络!"];
            }else {
                AppDelegate *app = [AppDelegate shareInstance];
                [MBProgressHUD showHUDAddedTo:app.window animated:YES];
                GetServiceInterface *log = [[GetServiceInterface alloc]init];
                self.getServiceInterface = log;
                self.getServiceInterface.delegate = self;
                [self.getServiceInterface getServiceInterfaceDelegateWithNum:self.carNumberTextField.textField.text andService:service_id];
            }
        }
    }else {
        [Utils errorAlert:@"请输入车牌号码!"];
    }
}
#pragma mark 下单方式
//快速下单
-(IBAction)fastToOrder:(id)sender {
    
    [self.txtSearch resignFirstResponder];
    [self.carNumberTextField.textField resignFirstResponder];
    CGRect frame1 = CGRectMake(0, 0, 815, 724);
    CGRect frame2 = CGRectMake(-815, 0, 815, 724);
    
    [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.viewLeft setFrame:frame1];
        [self.searchView setFrame:frame2];
        [self.payView setFrame:frame2];
        [self.infoView setFrame:frame2];
        [self.packageView setFrame:frame2];
    }
                     completion:^(BOOL finished){
                         self.pageValue = 0;
                         [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                     }];
}
//正常下单
-(IBAction)normalToOrder:(id)sender {
    
    if (self.carNumberTextField.textField.text.length ==0) {
        [Utils errorAlert:@"请输入车牌号"];
    }else {
        [self.carNumberTextField.textField resignFirstResponder];
        CGRect frame1 = CGRectMake(0, 0, 815, 724);
        CGRect frame2 = CGRectMake(-815, 0, 815, 724);
        
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.viewLeft setFrame:frame2];
            [self.searchView setFrame:frame1];
            [self.payView setFrame:frame2];
            [self.infoView setFrame:frame2];
            [self.packageView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             [self addRightnaviItemsWithImage:@"shareBt" andImage:@"refresh"];
                             self.pageValue =1;
                         }];
    }
}

//套餐卡消费
-(IBAction)packageBtnPressed:(id)sender {
    [self.txtSearch resignFirstResponder];
    [self.carNumberTextField.textField resignFirstResponder];
    NSString *str = @"";
    NSString *emailRegex = @"[\u4E00-\u9FFF]+[A-Za-z]{1}+[A-Z0-9a-z]{5}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:self.carNumberTextField.textField.text]) {
        str = @"输入正确的车牌号码!";
    }else{
        NSArray *array = [[NSArray alloc]initWithObjects:@"京",@"沪",@"津",@"渝",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新", nil];
        
        NSString *firstLetter = [self.carNumberTextField.textField.text substringToIndex:1];
        if (![array containsObject:firstLetter]) {
            str =@"输入正确的车牌号码!";
        }else {
            self.is_car_num = @"0";
        }
    }
    if (str.length>0) {
        [Utils errorAlert:str];
    }else {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else {
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
            [params setObject:self.carNumberTextField.textField.text forKey:@"num"];
            [params setObject:self.is_car_num forKey:@"type"];
            NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kpackage]];
            NSOperationQueue *queue=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
                if ([data length]>0 && error==nil) {
                    [self performSelectorOnMainThread:@selector(packageRespondtext:) withObject:data waitUntilDone:NO];
                }
            }
             ];
        }
    }
}
-(void)packageRespondtext:(NSData *)data  {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            [self.packageTable removeFromSuperview];
            self.packageTable = nil;
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                //客户信息
                self.package_customer = [NSMutableDictionary dictionaryWithDictionary:[jsonData objectForKey:@"user"]];
                //套餐卡列表
                self.packageList = nil;
                self.packageList = [NSMutableArray arrayWithArray:[jsonData objectForKey:@"package_cards"]];
                [DataService sharedService].packageList =[NSMutableArray arrayWithArray:self.packageList];
            
                self.packageTable = [[UITableView alloc]initWithFrame:CGRectMake(96, 160, 636, 450)];
                self.packageTable.delegate = self;
                self.packageTable.dataSource = self;
                self.packageTable.backgroundColor = [UIColor clearColor];
                [self.packageTable registerClass:[RecordTableHeader class] forHeaderFooterViewReuseIdentifier:PACKAGE_HEADER];
                [self.packageTable registerClass:[RecordTableFooter class] forHeaderFooterViewReuseIdentifier:PACKAGE_FOOTER];
                [self.packageView addSubview:self.packageTable];
            }else if ([[jsonData objectForKey:@"status"]integerValue]==0){
                self.package_customer=nil;
                self.p_carnum.text = self.carNumberTextField.textField.text;
                self.p_username.hidden = YES;
                self.p_username_lbl.hidden = YES;
                self.p_phone.hidden = YES;
                self.p_phone_lbl.hidden = YES;
                self.p_brand.hidden = YES;
                self.p_brand_lbl.hidden = YES;
                self.p_property.hidden = YES;
                self.p_property_lbl.hidden = YES;
                self.p_company.hidden = YES;
                self.p_company_lbl.hidden = YES;
                self.packageList = nil;
            }else {
                self.package_customer = [NSMutableDictionary dictionaryWithDictionary:[jsonData objectForKey:@"customer"]];
                self.p_carnum.text = self.carNumberTextField.textField.text;
                self.packageList = nil;
            }
            //车牌--必须有
            self.p_carnum.text = self.carNumberTextField.textField.text;
            if (self.package_customer) {
                //姓名
                if (![[self.package_customer objectForKey:@"cname"]isKindOfClass:[NSNull class]] && [self.package_customer objectForKey:@"cname"]!=nil) {
                    self.p_username.hidden = NO;
                    self.p_username_lbl.hidden = NO;
                    self.p_username.text =[NSString stringWithFormat:@"%@",[self.package_customer objectForKey:@"cname"]];
                }else {
                    self.p_username.hidden = YES;
                    self.p_username_lbl.hidden = YES;
                }
                //电话
                if (![[self.package_customer objectForKey:@"cmoilephone"]isKindOfClass:[NSNull class]] && [self.package_customer objectForKey:@"cmoilephone"]!=nil) {
                    self.p_phone.hidden = NO;
                    self.p_phone_lbl.hidden = NO;
                    self.p_phone.text =[NSString stringWithFormat:@"%@",[self.package_customer objectForKey:@"cmoilephone"]];
                    self.p_brand.frame = CGRectMake(351, 93, 242, 26);
                    self.p_brand_lbl.frame = CGRectMake(304, 93, 47, 26);
                }else {
                    self.p_phone.hidden = YES;
                    self.p_phone_lbl.hidden = YES;
                    self.p_brand.frame = CGRectMake(177, 93, 242, 26);
                    self.p_brand_lbl.frame = CGRectMake(130, 93, 47, 26);
                }
                //车辆品牌，型号
                if (![[self.package_customer objectForKey:@"cbrand"]isKindOfClass:[NSNull class]] && [self.package_customer objectForKey:@"cbrand"]!=nil) {
                    self.p_brand.hidden= NO;
                    self.p_brand_lbl.hidden = NO;
                    if (![[self.package_customer objectForKey:@"cmodel"]isKindOfClass:[NSNull class]] && [self.package_customer objectForKey:@"cmodel"]!=nil) {
                        self.p_brand.text = [NSString stringWithFormat:@"%@-%@",[self.package_customer objectForKey:@"cbrand"],[self.package_customer objectForKey:@"cmodel"]];
                    }else {
                        self.p_brand.text = [NSString stringWithFormat:@"%@",[self.package_customer objectForKey:@"cbrand"]];
                    }
                }else {
                    self.p_brand.hidden= YES;
                    self.p_brand_lbl.hidden = YES;
                }
                if (self.p_phone.hidden==YES && self.p_brand.hidden==YES) {
                    self.p_property.frame = CGRectMake(177, 93, 110, 26);
                    self.p_property_lbl.frame = CGRectMake(130, 93, 47, 26);
                    self.p_company.frame = CGRectMake(351, 93, 327, 26);
                    self.p_company_lbl.frame = CGRectMake(304, 93, 47, 26);
                    self.packageTable.frame = CGRectMake(89, 127, 636, 564);
                }else {
                    self.p_property.frame = CGRectMake(177, 127, 110, 26);
                    self.p_property_lbl.frame = CGRectMake(130, 127, 47, 26);
                    self.p_company.frame = CGRectMake(351, 127, 327, 26);
                    self.p_company_lbl.frame = CGRectMake(304, 127, 47, 26);
                    self.packageTable.frame = CGRectMake(89, 161, 636, 530);
                }
                //属性
                self.p_property.hidden=NO;
                self.p_property_lbl.hidden=NO;
                self.package_search_txt.text=nil;
                if (![[self.package_customer objectForKey:@"cproperty"]isKindOfClass:[NSNull class]] && [self.package_customer objectForKey:@"cproperty"]!=nil) {
                    if ([[self.package_customer objectForKey:@"cproperty"] integerValue]==0) {
                        self.p_property.text = @"个人";
                        self.p_company.hidden = YES;
                        self.p_company_lbl.hidden = YES;
                    }else {
                        self.p_property.text = @"单位";
                        self.p_company.hidden = NO;
                        self.p_company_lbl.hidden = NO;
                        if (![[self.package_customer objectForKey:@"cgroup_name"]isKindOfClass:[NSNull class]] && [self.package_customer objectForKey:@"cgroup_name"]!=nil) {
                            self.p_company.text =[NSString stringWithFormat:@"%@",[self.package_customer objectForKey:@"cgroup_name"]];
                        }else {
                            self.p_company.text = @"";
                            self.p_company_lbl.text = @"";
                        }
                    }
                }else {
                    self.p_property.text = @"个人";
                    self.p_company.hidden = YES;
                    self.p_company_lbl.hidden = YES;
                }
            }
            CGRect frame1 = CGRectMake(0, 0, 815, 724);
            CGRect frame2 = CGRectMake(-815, 0, 815, 724);
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.packageView setFrame:frame1];
                [self.viewLeft setFrame:frame2];
                [self.searchView setFrame:frame2];
                [self.payView setFrame:frame2];
                [self.infoView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 [self addRightnaviItemsWithImage:@"shareBt" andImage:@"refresh"];
                                 self.pageValue =8;
                                 [self.packageTable reloadData];
                             }];
        }
    }
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
}

-(IBAction)packageSearchByPhone:(id)sender {
    [self.package_search_txt resignFirstResponder];
    NSString *regexCall = @"1[0-9]{10}";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.package_search_txt.text]) {
        self.is_car_num = @"1";//电话号码；
        
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
        [params setObject:self.package_search_txt.text forKey:@"num"];
        [params setObject:self.is_car_num forKey:@"type"];
        NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kpackage]];
        NSOperationQueue *queue=[[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
            if ([data length]>0 && error==nil) {
                [self performSelectorOnMainThread:@selector(packageRespondtext:) withObject:data waitUntilDone:NO];
            }
        }
         ];
    }else {
        [Utils errorAlert:@"请输入正确的电话号码!"];
    }
}
#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    if ([tableView isEqual:self.searchTable] || [tableView isEqual:self.payTable] || [tableView isEqual:self.packageTable]) {
        return 44;
    }else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:self.packageTable]) {
        return 44;
    }else
        return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    if ([tableView isEqual:self.packageTable]){
        RecordTableFooter *footer = (RecordTableFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:PACKAGE_FOOTER];
        footer.delegate = self;
        return footer;
    }
    else
        return nil;
}

#pragma mark RecordTableFooterDelegate
-(void)packageCancelPressed; {
    [self.package_search_txt resignFirstResponder];
    [DataService sharedService].package_product = nil;
    CGRect frame1 = CGRectMake(0, 0, 815, 724);
    CGRect frame2 = CGRectMake(-815, 0, 815, 724);
    [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.viewLeft setFrame:frame1];
        [self.packageView setFrame:frame2];
    }
                     completion:^(BOOL finished){
                         self.pageValue=0;
                         [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                     }];
}
-(void)packageSurePressed; {
    NSLog(@"确定");
    [self.package_search_txt resignFirstResponder];
    if ([DataService sharedService].package_product.count>0) {
        NSString *str = [[DataService sharedService].package_product objectAtIndex:0];
        NSArray *arr = [str componentsSeparatedByString:@"_"];
        
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
        [params setObject:[DataService sharedService].user_id forKey:@"staff_id"];
        [params setObject:self.p_carnum.text forKey:@"num"];
        [params setObject:[NSString stringWithFormat:@"%@",[self.package_customer objectForKey:@"cid"]] forKey:@"customer_id"];
        [params setObject:[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]] forKey:@"cprid"];
        [params setObject:[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]] forKey:@"product_id"];
        NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kpackage_order]];
        NSOperationQueue *queue=[[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
            if ([data length]>0 && error==nil) {
                [self performSelectorOnMainThread:@selector(orderFromPackage:) withObject:data waitUntilDone:NO];
            }
        }
         ];
    }else {
        [Utils errorAlert:@"请选择产品或服务!"];
    }
}
-(void)orderFromPackage:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"jsondata = %@",jsonData);
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                //工位情况
                NSDictionary *order_dic = [jsonData objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
                
                CGRect frame1 = CGRectMake(0, 0, 815, 724);
                CGRect frame2 = CGRectMake(-815, 0, 815, 724);
                [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.viewLeft setFrame:frame1];
                    [self.packageView setFrame:frame2];
                }
                                 completion:^(BOOL finished){
                                     self.pageValue = 0;
                                     [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                                 }];
            }else {
                [Utils errorAlert:[jsonData objectForKey:@"msg"]];
            }
        }
    }
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchTable]) {
        ProAndServiceHeader *header = (ProAndServiceHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER_IDENTIFIER];
        header.nameLab.hidden= YES;
        header.priceLab.hidden= YES;
        header.countLab.hidden= YES;
        header.totalPrice.hidden= YES;
        header.lab2.text = @"库存";
        header.lab3.text = @"单价(元)";
        header.lab4.text = @"单价(元)";
        header.lab5.text = @"项目";
        header.lab3.hidden= NO;
        header.lab4.hidden= YES;
        header.lab5.hidden= YES;
        if (self.selectClassify == 0) {
            header.lab1.text = @"产品";
        }else if (self.selectClassify == 1) {
            header.lab1.text = @"服务";
        }else {
            header.lab2.hidden= YES;
            header.lab3.hidden= YES;
            header.lab4.hidden= NO;
            header.lab5.hidden= NO;
            header.lab1.text = @"卡类";
            
        }
        return header;
    }else if ([tableView isEqual:self.payTable]) {
        ProAndServiceHeader *header = (ProAndServiceHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER_IDENTIFIER];
        header.nameLab.text = @"名称";
        header.priceLab.text = @"单价(元)";
        header.countLab.text = @"数量";
        header.totalPrice.text = @"总价(元)";
        header.lab1.hidden= YES;
        header.lab2.hidden= YES;
        header.lab3.hidden= YES;
        header.lab4.hidden= YES;
        header.lab5.hidden= YES;
        return header;
    }
    else if ([tableView isEqual:self.packageTable]){
        RecordTableHeader *header = (RecordTableHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:PACKAGE_HEADER];
        return header;
    }
    else
         return nil;
}

static NSString *service_id = nil;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.searchTable]) {
        return self.searchResult.count;
    }else if ([tableView isEqual:self.payTable]) {
        return self.payResult.count;
    }else if ([tableView isEqual:self.packageTable]) {
        return self.packageList.count;
    }else
        return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self.searchTable]) {//搜索页面
        NSDictionary *pro = (NSDictionary *)[self.searchResult objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kDomain,[pro objectForKey:@"img_small"]]];
        if (self.selectClassify==0 || self.selectClassify==1) {
            static NSString *identifier =@"ProAndServiceCell";
            ProAndServiceCell *cell = (ProAndServiceCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ProAndServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withProduct:pro indexPath:indexPath type:0];
            }
            [cell.pImg addDetailShow:pro andSearchType:self.selectClassify];
            cell.url = url;
            
            cell.lab1.text = [NSString stringWithFormat:@"%@",[pro objectForKey:@"name"]];
            cell.lab3.text = [NSString stringWithFormat:@"%@",[pro objectForKey:@"price"]];
            int num = [[pro objectForKey:@"num"]intValue];
            if (num<0) {
                cell.lab2.text = @"";
            }else {
                cell.lab2.text = [NSString stringWithFormat:@"%d",num];
            }
            
            cell.orderBtn.tag = indexPath.row;
            [cell.orderBtn addTarget:self action:@selector(orderdBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else {//搜索卡类
            NSString *identifier = @"CardCell";
            CardCell *cell = (CardCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[CardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withProduct:pro indexPath:indexPath type:0];
            }
            NSArray *subViews = [cell.contentView subviews];
            for (UIView *vv in subViews) {
                if ([vv isKindOfClass:[UILabel class]]) {
                    UILabel *vvLab = (UILabel *)vv;
                    if (vvLab.tag == 89898989) {
                        [vvLab removeFromSuperview];
                    }
                }
            }
            cell.url = url;
            [cell.pImg addDetailShow:pro andSearchType:self.selectClassify];
            cell.priceLab.text = [pro objectForKey:@"price"];
            cell.nameLab.text = [pro objectForKey:@"name"];
            cell.orderBtn.tag = indexPath.row;
            [cell.orderBtn addTarget:self action:@selector(orderdBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            CGRect frame = CGRectMake(360, 0, 180, 44);
            //0是打折卡,1是储值卡,2是套餐卡
            int search_type = [[pro objectForKey:@"type"]integerValue];
            if (![[pro objectForKey:@"products"]isKindOfClass:[NSNull class]] && [pro objectForKey:@"products"]!=nil) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:[pro objectForKey:@"products"]];
                int len = array.count;
                for (int i=0; i<len; i++) {
                    frame.origin.y = 44 * i;
                    
                    UILabel *lblProd = [[UILabel alloc] initWithFrame:frame];
                    lblProd.lineBreakMode = NSLineBreakByCharWrapping;
                    lblProd.numberOfLines = 0;
                    lblProd.tag = 89898989;
                    lblProd.backgroundColor = [UIColor clearColor];
                    if (search_type == 0) {
                        NSDictionary *dic = [array objectAtIndex:i];
                        CGFloat discount =[[dic objectForKey:@"discount"]floatValue];
                        lblProd.text = [NSString stringWithFormat:@"%@:%.1f折",[dic objectForKey:@"name"],discount];
                    }else if (search_type == 1){
                        lblProd.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
                    }else {
                        NSDictionary *dic = [array objectAtIndex:i];
                        lblProd.text = [NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@"name"],[dic objectForKey:@"num"]];
                    }
                    [cell.contentView addSubview:lblProd];
                }
            }else {
                frame.origin.y=0;
                UILabel *lblProd = [[UILabel alloc] initWithFrame:frame];
                [cell.contentView addSubview:lblProd];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if ([tableView isEqual:self.payTable]) {//付款页面
        NSMutableDictionary *product = [self.payResult objectAtIndex:indexPath.row];
        
        if ([product objectForKey:@"id"]) {//产品，服务
            //第一次加载tableView
            if ([DataService sharedService].first == YES) {
                
                [[DataService sharedService].price_id setObject:[product objectForKey:@"price"] forKey:[NSString stringWithFormat:@"%@",[product objectForKey:@"id"]]];
                [[DataService sharedService].number_id setObject:[product objectForKey:@"count"] forKey:[NSString stringWithFormat:@"%@",[product objectForKey:@"id"]]];
                NSString *str = [NSString stringWithFormat:@"%@_%@_%@",[product objectForKey:@"id"],[product objectForKey:@"count"],[self.customer objectForKey:@"oprice"]];
                [[DataService sharedService].id_count_price addObject:str];
                
            }
            static NSString *CellIdentifier = @"ServiceCell";
            ServiceCell *cell = (ServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:0];
            }
            cell.lblName.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"name"]];
            cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"price"]];
            cell.lblCount.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"count"]];
            cell.lbltotal.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"show_price"]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if([product objectForKey:@"sale_id"]) {//活动
            NSString *CellIdentifier = [NSString stringWithFormat:@"sale_%d_%d", indexPath.section,indexPath.row];
            SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:0];
            }
            
            NSArray *subViews = [cell.contentView subviews];
            for (UIView *v in subViews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)v;
                    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
                    if (tagStr.length == 3) {
                        int tag_x = btn.tag - OPEN;
                        if ([[product objectForKey:@"selected"]intValue] == 1) {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            btn.tag = tag_x + CLOSE;
                            
                        }else {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if([product objectForKey:@"svid"]) {//打折卡
            NSString *CellIdentifier = [NSString stringWithFormat:@"card_%d_%d", indexPath.section,indexPath.row];
            SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:1];
            }
            
            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"show_price"]floatValue]];
            
            cell.nameLab.text = [product objectForKey:@"svname"];
            
            NSArray *subViews = [cell.contentView subviews];
            for (UIView *v in subViews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)v;
                    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
                    if (tagStr.length == 3) {
                        int tag_x = btn.tag - OPEN;
                        NSDictionary *dic = [[product objectForKey:@"products"] objectAtIndex:tag_x];
                        if ([[dic objectForKey:@"selected"]intValue] == 1) {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            btn.tag = tag_x + CLOSE;
                            
                        }else {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if([product objectForKey:@"pid"]) {//套餐卡
            NSString *CellIdentifier = [NSString stringWithFormat:@"PackageCardCell%d", [indexPath row]];
            PackageCardCell *cell = (PackageCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            int p_status = [[product objectForKey:@"status"]integerValue];//判断正常下单还是套餐卡下单
            if (cell == nil) {
                cell = [[PackageCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:p_status];
            }
            NSArray *subViews = [cell subviews];
            for (UIView *v in subViews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)v;
                    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
                    if (tagStr.length == 3) {
                        int tag_x = btn.tag - OPEN;
                        NSDictionary *dic = [[product objectForKey:@"products"] objectAtIndex:tag_x];
                        if ([[dic objectForKey:@"selected"]intValue] == 1) {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            btn.tag = tag_x + CLOSE;
                            
                            UILabel *lab_prod = (UILabel *)[cell viewWithTag:tag_x+OPEN+OPEN];
                            lab_prod.text = [NSString stringWithFormat:@"%@(%@)次",[dic objectForKey:@"proname"],[dic objectForKey:@"pro_left_count"]];
                            lab_prod.tag = tag_x+CLOSE+CLOSE;
                        }else {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
            if ([[product objectForKey:@"is_new"] integerValue]==1) {
                
                cell.lblName.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"pname"]];
                cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"pprice"] floatValue]];
            }else{
                
                cell.lblName.text = [product objectForKey:@"pname"];
                cell.lblPrice.text = [NSString stringWithFormat:@"0.00"];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        return nil;
    }
    else if ([tableView isEqual:self.packageTable]) {//套餐卡页面
        NSString *CellIdentifier = [NSString stringWithFormat:@"PackageCell%d", [indexPath row]];
        PackageRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSMutableDictionary *order = [self.packageList objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[PackageRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier item:order indexPath:indexPath];
        }
        if (![[order objectForKey:@"ended_at"] isKindOfClass:[NSNull class]] && [order objectForKey:@"ended_at"]!= nil) {
            cell.dateLab.text = [order objectForKey:@"ended_at"];
        }
        cell.nameLab.text = [order objectForKey:@"name"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {//快速下单页面
        static NSString *CellIdentifier = @"cellIden";
        ServeItemView *cell = (ServeItemView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [[ServeItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        ServiceModel *service = (ServiceModel *)[self.dataArray objectAtIndex:indexPath.row];
        [cell.serveBt setTitle:service.name forState:UIControlStateNormal];
        cell.path = indexPath;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.isSelected = YES;
        }
        return cell;
    }
}
-(void)serveItemView:(ServeItemView *)itemView didSelectedItemAtIndexPath:(NSIndexPath *)path {
    [self.carNumberTextField.textField resignFirstResponder];
    self.idx_path = path;
    NSString *emailRegex = @"[\u4E00-\u9FFF]+[A-Za-z]{1}+[A-Z0-9a-z]{5}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:self.carNumberTextField.textField.text]) {
        [Utils errorAlert:@"输入正确的车牌号码!"];
    }else {
        NSArray *array = [[NSArray alloc]initWithObjects:@"京",@"沪",@"津",@"渝",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新", nil];
        
        NSString *firstLetter = [self.carNumberTextField.textField.text substringToIndex:1];
        if (![array containsObject:firstLetter]) {
            [Utils errorAlert:@"输入正确的车牌号码!"];
        }else {
            if (self.pageValue != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTip message:@"是否快速下单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag=99;
                [alert show];
            }else {
                NSArray *subViews = self.orderTable.visibleCells;
                for (UIView *vv in subViews) {
                    if ([vv isKindOfClass:[ServeItemView class]]) {
                        ServeItemView *ss = (ServeItemView *)vv;
                        if (ss.path.row != path.row) {
                            ss.isSelected = NO;
                        }else {
                            ss.isSelected = YES;
                        }
                    }
                }
                [self quickToMakeOrder];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.searchTable]) {
        if (self.selectClassify==0 || self.selectClassify==1) {
            return 44;
        }else {
            NSDictionary *dic = [self.searchResult objectAtIndex:indexPath.row];
            if (![[dic objectForKey:@"products"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"products"]!=nil) {
                NSArray *array = [dic objectForKey:@"products"];
                if (array.count>0) {
                    return 44*array.count;
                }else
                    return 44;
            }else
                return 44;
        }
    }
    else if ([tableView isEqual:self.payTable]) {
        NSDictionary *product = [self.payResult objectAtIndex:indexPath.row];
        if ([product objectForKey:@"products"]) {
            int count = [[product objectForKey:@"products"] count];
            count = count == 0 ? 1 : count;
            return count * 44;
        }else
            return 44;
    }
    else if ([tableView isEqual:self.packageTable]){
        NSDictionary *order = [self.packageList objectAtIndex:indexPath.row];
        int count = [[order objectForKey:@"products"] count];
        if (count == 0) {
            return 44+20;
        }
        return count * 44 +20;
    }
    else
        return 35;
}
#pragma mark 搜索页面－－下单

-(void)orderdBtnPressed:(id)sender {
    [self.txtSearch resignFirstResponder];
    [self.carNumberTextField.textField resignFirstResponder];
    UIButton *btn = (UIButton *)sender;
    NSString *str = @"";
    NSString *emailRegex = @"[\u4E00-\u9FFF]+[A-Za-z]{1}+[A-Z0-9a-z]{5}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:self.carNumberTextField.textField.text]) {
        str = @"输入正确的车牌号码!";
    }else {
        NSArray *array = [[NSArray alloc]initWithObjects:@"京",@"沪",@"津",@"渝",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新", nil];
        
        NSString *firstLetter = [self.carNumberTextField.textField.text substringToIndex:1];
        if (![array containsObject:firstLetter]) {
            str =@"输入正确的车牌号码!";
        }
    }
    if (str.length>0) {
        [Utils errorAlert:str];
    }else {
        NSDictionary *pro = (NSDictionary *)[self.searchResult objectAtIndex:btn.tag];
        self.orderView = nil;
        self.orderView = [[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
        self.orderView.delegate = self;
        self.orderView.number = self.selectClassify;
        self.orderView.carNum = self.carNumberTextField.textField.text;
        self.orderView.p_object = pro;
        [self presentPopupViewController:self.orderView animationType:MJPopupViewAnimationSlideBottomTop];
    }
}
-(void)textFieldChanged:(NSNotification *)sender {
    UITextField *txtField = (UITextField *)sender.object;
    
    if (txtField.text.length == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.sxView.view removeFromSuperview];
        self.sxView = nil;
        [UIView commitAnimations];
        
    }else if (txtField.text.length == 1) {
        for (int i=0; i<self.letterArray.count; i++) {
            NSString *str = [self.letterArray objectAtIndex:i];
            if ([str isEqualToString:txtField.text] || ([[str lowercaseString] isEqualToString:txtField.text])) {
                NSArray *array = [[DataService sharedService].sectionArray objectAtIndex:i];
                if (array.count>0 && self.sxView == nil) {
                    self.sxView = [[ShaixuanView alloc]initWithNibName:@"ShaixuanView" bundle:nil];
                    self.sxView.view.frame = CGRectMake(self.carNumberTextField.frame.origin.x, 45+self.carNumberTextField.frame.origin.y, 0, 0);
                    self.sxView.dataArray = array;
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.35];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    self.sxView.view.frame = CGRectMake(self.carNumberTextField.frame.origin.x, 45+self.carNumberTextField.frame.origin.y, 200, 200);
                    [self.rightBackgroundView addSubview:self.sxView.view];
                    [UIView commitAnimations];
                    
                }
            }
        }
    }else if (txtField.text.length > 1) {
        [UIView animateWithDuration:0.35 animations:^{
            self.sxView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.sxView.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.sxView.view removeFromSuperview];
                self.sxView = nil;
            }
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.carNumberTextField.textField resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCarYear resignFirstResponder];
    [self.txtKm resignFirstResponder];
    [self.txtSearch resignFirstResponder];
    [self.txtCompany resignFirstResponder];
}

#pragma mark 搜索 🔍

- (IBAction)clickSearchBtn:(id)sender {
    [self.txtSearch resignFirstResponder];
    [self.carNumberTextField.textField resignFirstResponder];
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        if(self.txtSearch.text.length==0) {
            self.txtSearch.text = @" ";
        }
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        SearchInterface *log = [[SearchInterface alloc]init];
        self.searchInterface = log;
        self.searchInterface.delegate = self;
        [self.searchInterface getSearchInterfaceDelegateWithText:self.txtSearch.text andType:[NSString stringWithFormat:@"%d",self.selectClassify]];
    }
}

#pragma mark 快速下单
//status:1 有符合工位 2 没工位 3 多个工位 4 工位上暂无技师  5 多个车牌
-(void)getServiceInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            NSDictionary *order_dic = [result objectForKey:@"orders"];
            [self setStationDataWithDic:order_dic];
        });
    });
}
-(void)getServiceInfoDidFailed:(NSString *)errorMsg {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}

#pragma mark 搜索产品
-(void)getSearchInfoDidFinished:(NSArray *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (self.selectClassify==0) {
            [self.dataDictionary setObject:result forKey:@"product"];
            [self.dataDictionary setObject:self.txtSearch.text forKey:@"productName"];
        }else if (self.selectClassify==1) {
            [self.dataDictionary setObject:result forKey:@"service"];
            [self.dataDictionary setObject:self.txtSearch.text forKey:@"serviceName"];
        }else {
            [self.dataDictionary setObject:result forKey:@"card"];
            [self.dataDictionary setObject:self.txtSearch.text forKey:@"cardName"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            self.searchResult = nil;
            self.searchResult= [[NSMutableArray alloc]initWithArray:result];
            [self.searchTable reloadData];
        });
    });
}
-(void)getSearchInfoDidFailed:(NSString *)errorMsg {
    self.searchResult = nil;
    [self.searchTable reloadData];
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark brandlist
-(void)initBrandListWithArray:(NSMutableArray *)array {
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        CapitalModel *capital = [[CapitalModel alloc]init];
        capital.capital_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        capital.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        capital.barndList = [[NSMutableArray alloc]init];
        //品牌
        if (![[dic objectForKey:@"brands"]isKindOfClass:[NSNull class]]) {
            NSArray *brand_array = [dic objectForKey:@"brands"];
            if (brand_array.count > 0) {
                for (int j=0; j<brand_array.count; j++) {
                    NSDictionary *brand_dic = [brand_array objectAtIndex:j];
                    BrandModel *brand = [[BrandModel alloc]init];
                    brand.name =[NSString stringWithFormat:@"%@",[brand_dic objectForKey:@"name"]];
                    brand.brand_id = [NSString stringWithFormat:@"%@",[brand_dic objectForKey:@"id"]];
                    brand.capital_id = [NSString stringWithFormat:@"%@",[brand_dic objectForKey:@"capital_id"]];
                    brand.modelList = [[NSMutableArray alloc]init];
                    if (![[brand_dic objectForKey:@"models"]isKindOfClass:[NSNull class]]) {
                        NSArray *models_array = [brand_dic objectForKey:@"models"];
                        if (models_array.count >0) {
                            for (int k=0; k<models_array.count; k++) {
                                NSDictionary *model_dic = [models_array objectAtIndex:k];
                                ModelModel *model = [[ModelModel alloc]init];
                                
                                model.name = [NSString stringWithFormat:@"%@",[model_dic objectForKey:@"name"]];
                                model.model_id = [NSString stringWithFormat:@"%@",[model_dic objectForKey:@"id"]];
                                model.brand_id = [NSString stringWithFormat:@"%@",[model_dic objectForKey:@"car_brand_id"]];
                                [brand.modelList addObject:model];
                            }
                        }
                    }
                    
                    [capital.barndList addObject:brand];
                }
            }
        }
        [self.brandList addObject:capital];
    }
}
#pragma mark 保存车辆品牌／型号到数据库
-(void)addDataToBrandAndmodelWithArray:(NSMutableArray *)array {
    LanTanDB *lantan = [[LanTanDB alloc]init];
    NSArray *localArray = [lantan getLocalBrand];
    if (localArray.count == 0) {
        for (int i=0; i<array.count; i++) {
            CapitalModel *capital = (CapitalModel *)[array objectAtIndex:i];
            
            [lantan addDataWithCapitalModel:capital];
            if (capital.barndList.count>0) {
                for (int j=0; j<capital.barndList.count; j++) {
                    BrandModel *brand = (BrandModel *)[capital.barndList objectAtIndex:j];
                    [lantan addDataWithBrandModel:brand];
                    if (brand.modelList.count>0) {
                        for (int k=0; k<brand.modelList.count; k++) {
                            ModelModel *model = (ModelModel *)[brand.modelList objectAtIndex:k];
                            [lantan addDataWithModelModel:model];
                        }
                    }
                }
            }
        }
    }
}
#pragma mark --
#pragma mark 下单完成
#pragma mark --
- (void)dismissPopView:(OrderViewController *)payStyleViewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    NSDictionary *p_dic = [NSDictionary dictionaryWithDictionary:payStyleViewController.product_dic];
    self.prod_type = [NSString stringWithFormat:@"%@",[p_dic objectForKey:@"prod_type"]];
    //工位情况
    NSDictionary *order_dic = [p_dic objectForKey:@"orders"];
    [self setStationDataWithDic:order_dic];
    if (self.selectClassify==1) {
        CGRect frame1 = CGRectMake(0, 0, 815, 724);
        CGRect frame2 = CGRectMake(-815, 0, 815, 724);
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.viewLeft setFrame:frame1];
            [self.searchView setFrame:frame2];
            [self.payView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             self.searchResult=nil;
                             [self.searchTable reloadData];
                             [self.dataDictionary removeObjectForKey:@"service"];
                             [self.dataDictionary removeObjectForKey:@"serviceName"];
                             self.pageValue = 0;
                             [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                         }];
    }else {
        self.make_order=1;
        [self layoutViewWithDictionary:p_dic];
        [DataService sharedService].payViewFrom = 1;
    }
    self.orderView = nil;
}

#pragma mark 车辆的pickerview
- (void)initBrandView{
    if ((_brandList.count>0) && (![[_customer objectForKey:@"cbrand"] isKindOfClass:[NSNull class]]) && _customer &&([_customer objectForKey:@"cbrand"] != nil)) {
        self.firstArray = [NSMutableArray arrayWithArray:self.brandList];
        [self.brandView reloadAllComponents];
        for (int i = 0; i<_brandList.count; i++) {
            CapitalModel *capital = (CapitalModel *)[_brandList objectAtIndex:i];
            BOOL isOut = NO;
            if (capital.barndList.count >0) {
                for (int j=0; j<capital.barndList.count; j++) {
                    BrandModel *brand = (BrandModel *)[capital.barndList objectAtIndex:j];
                    
                    NSString *nameBrand = [NSString stringWithFormat:@"%@",[_customer objectForKey:@"cbrand"]];
                    if ([brand.name isEqualToString:nameBrand]) {
                        
                        self.secondArray = [NSMutableArray arrayWithArray:capital.barndList];
                        if (brand.modelList.count>0) {
                            self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
                        }
                        [self.brandView selectRow:i inComponent:0 animated:YES];
                        [self.brandView reloadComponent:1];
                        [self.brandView selectRow:j inComponent:1 animated:YES];
                        [self.brandView reloadComponent:2];
                        
                        if (brand.modelList.count>0) {
                            for (int k=0; k<brand.modelList.count; k++) {
                                ModelModel *model = (ModelModel *)[brand.modelList objectAtIndex:k];
                                NSString *modelName = [NSString stringWithFormat:@"%@",[_customer objectForKey:@"cmodel"]];
                                if ([model.name isEqualToString:modelName]) {
                                    isOut = YES;
                                    [self.brandView selectRow:k inComponent:2 animated:YES];
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            if (isOut) {
                break;
            }
        }
    }else {
        if (self.brandList.count > 0) {
            self.firstArray = [NSMutableArray arrayWithArray:self.brandList];
            CapitalModel *capital = (CapitalModel *)[self.firstArray objectAtIndex:0];
            self.secondArray = [NSMutableArray arrayWithArray:capital.barndList];
            BrandModel *brand = (BrandModel *)[capital.barndList objectAtIndex:0];
            self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
            [self.brandView selectRow:0 inComponent:0 animated:YES];
            [self.brandView selectRow:0 inComponent:1 animated:YES];
            [self.brandView selectRow:0 inComponent:2 animated:YES];
            [self.brandView reloadAllComponents];
        }
    }
}
#pragma mark 车辆

#pragma mark - picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 40;
            break;
            
        case 1:
            return 150;
            break;
            
        case 2:
            return 150;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerVieww numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if (self.firstArray.count == 0) {
                return 1;
            }
            return self.firstArray.count;
            break;
            
        case 1:
            if (self.secondArray.count == 0) {
                return 1;
            }
            return self.secondArray.count;
            break;
            
        case 2:
            if (self.thirdArray.count == 0) {
                return 1;
            }
            return self.thirdArray.count;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerVieww titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if (self.firstArray.count>0) {
                CapitalModel*capital = (CapitalModel *)[self.firstArray objectAtIndex:row];
                return capital.name;
            }
            return @"";
            break;
            
        case 1:
            if (self.secondArray.count>0) {
                BrandModel *brand = (BrandModel *)[self.secondArray objectAtIndex:row];
                return brand.name;
            }
            return @"";
            break;
            
        case 2:
            if (self.thirdArray.count>0) {
                ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:row];
                return model.name;
            }
            return @"";
            break;
            
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerVieww didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSMutableString *brandStr = nil;
    switch (component) {
        case 0:
            if (self.firstArray.count>0) {
                brandStr = [NSMutableString string];
                CapitalModel *capital = [self.firstArray objectAtIndex:row];
                self.secondArray = [NSMutableArray arrayWithArray:capital.barndList];
                [self.brandView reloadComponent:1];
                [self.brandView selectRow:0 inComponent:1 animated:YES];
                
                if (self.secondArray.count > 0) {
                    BrandModel *brand = [self.secondArray objectAtIndex:0];
                    self.car_brand.brand = brand.name;
                    if (brand.modelList!=nil) {
                        self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
                        ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:0];
                        self.car_brand.model = model.name;
                    }else {
                        self.thirdArray = nil;
                    }
                }else {
                    self.thirdArray = nil;
                }
                [self.brandView reloadComponent:2];
                [self.brandView selectRow:0 inComponent:2 animated:YES];
            }
            break;
            
        case 1:
            if (self.secondArray.count>0) {
                BrandModel *brand = [self.secondArray objectAtIndex:row];
                self.car_brand.brand = brand.name;
                if (brand.modelList!=nil) {
                    self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
                    ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:0];
                    self.car_brand.model = model.name;
                }else {
                    self.thirdArray = nil;
                }
                [self.brandView reloadComponent:2];
                [self.brandView selectRow:0 inComponent:2 animated:YES];
                
            }
            break;
            
        case 2:
            if (self.secondArray.count>0) {
                ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:row];
                self.car_brand.model = model.name;
            }
            break;
            
        default:
            break;
            
    }
    self.txtBrand.text = [NSString stringWithFormat:@"%@-%@",self.car_brand.brand,self.car_brand.model];
}
#pragma mark  总价更新
- (void)updateTotal:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    //dic套餐卡剩余
    CGFloat f = 0;
    if (self.total_count == 0) {
        f = self.total_count_temp + [[dic objectForKey:@"object"] floatValue];
    }else {
        f = self.total_count + [[dic objectForKey:@"object"] floatValue];
    }
    
    if (f < 0) {
        self.total_count = 0.0;
        self.total_count_temp = f;
    }else {
        self.total_count = f;
        self.total_count_temp = f;
    }
    self.lblTotal.text = [NSString stringWithFormat:@"合计:%.2f(元)",self.total_count];
    NSIndexPath *idx = [dic objectForKey:@"idx"];
    [self.payResult replaceObjectAtIndex:idx.row withObject:[dic objectForKey:@"prod"]];
    
    [DataService sharedService].productList = [NSMutableArray arrayWithArray:self.payResult];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.payTable reloadData];
    });
}
- (void)reloadPackage:(NSNotification *)notification{
    self.packageList = [DataService sharedService].packageList;
    NSString *str = [notification object];
    if (str != nil) {
        NSArray *arr = [str componentsSeparatedByString:@"_"];
        NSMutableDictionary *mutable_dic = [NSMutableDictionary dictionaryWithDictionary:[[DataService sharedService].packageList objectAtIndex:[[arr objectAtIndex:2]intValue]]];
        if ([[mutable_dic objectForKey:@"cpard_relation_id"]integerValue]==[[arr objectAtIndex:0]integerValue]) {//套餐卡relationID
            NSMutableArray *mutable_arr = [NSMutableArray arrayWithArray:[mutable_dic objectForKey:@"products"]];
            for (int i=0; i<mutable_arr.count; i++) {
                NSMutableDictionary *p_dic = [NSMutableDictionary dictionaryWithDictionary:[mutable_arr objectAtIndex:i]];
                if ([[p_dic objectForKey:@"id"]integerValue] == [[arr objectAtIndex:1]integerValue]) {//产品id
                    [p_dic setValue:@"1" forKey:@"selected"];
                    
                    [mutable_arr replaceObjectAtIndex:i withObject:p_dic];
                    [mutable_dic setObject:mutable_arr forKey:@"products"];
                    [[DataService sharedService].packageList replaceObjectAtIndex:[[arr objectAtIndex:2]intValue] withObject:mutable_dic];
                    [[DataService sharedService].package_product removeAllObjects];
                    
                    //通过index找到cell
                    NSIndexPath *idx = [NSIndexPath indexPathForRow:[[arr objectAtIndex:2]intValue] inSection:0];
                    PackageRecordCell *cell = (PackageRecordCell *)[self.packageTable cellForRowAtIndexPath:idx];
                    UIButton *btn =(UIButton *)[cell viewWithTag:OPEN+i];
                    int tag = btn.tag;
                    btn.tag = tag - OPEN + CLOSE;
                    [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    NSLog(@"&&^^&W&*8 = %@",[DataService sharedService].package_product);
}
- (void)svcardReload:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    
    NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];//服务／产品的id
    
    NSMutableArray *collection_index = [NSMutableArray array];//单个活动消费的产品index集合
    NSMutableArray *collection_id = [NSMutableArray array];//单个活动消费的产品id集合
    NSMutableArray *collection_number = [NSMutableArray array];//单个活动消费的产品number集合
    NSMutableArray *collection = [NSMutableArray array];//纪录位置
    
    NSMutableArray *p_arr = nil;
    NSMutableDictionary *p_dic=nil;
    
    CGFloat discount_x = 0;
    CGFloat discount_y = 0;
    
    NSArray *array = [[DataService sharedService].number_id allKeys];
    if ([array containsObject:product_id]) {
        discount_x = [[dic objectForKey:@"price"] floatValue];//服务／产品的  单价
        int num_count = 0;//放在单列里面此id产品消费次数
        int index_row = 0;
        if ([DataService sharedService].svcardArray.count >0) {
            for (int i=0; i<[DataService sharedService].svcardArray.count; i++) {
                NSMutableString *str = [[DataService sharedService].svcardArray objectAtIndex:i];
                str = [NSMutableString stringWithString:[str substringToIndex:str.length-1]];
                NSArray *arr = [str componentsSeparatedByString:@"_"];
                [collection_index addObject:[arr objectAtIndex:0]];
                [collection_id addObject:[arr objectAtIndex:1]];
                [collection_number addObject:[arr objectAtIndex:2]];
                
            }
        }
        //遍历 id的集合找到位置
        for (int i=0; i<collection_id.count; i++) {
            NSString *prod_id = [collection_id objectAtIndex:i];
            if ([product_id intValue] == [prod_id intValue]) {
                [collection addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        NSMutableArray *collection_temp = [NSMutableArray array];//纪录row_id_numArray里面要删除的元素
        
        if (collection.count>0) {
            for (int i=0; i<collection.count; i++) {
                int h = [[collection objectAtIndex:i]intValue];//位置
                //根据位置找到index
                index_row = [[collection_index objectAtIndex:h]intValue];
                //通过index找到的活动
                NSMutableDictionary *product_dic = [[DataService sharedService].productList objectAtIndex:index_row];
                discount_y = [[product_dic objectForKey:@"show_price"]floatValue];
                //通过index找到cell
                NSIndexPath *idx = [NSIndexPath indexPathForRow:index_row inSection:0];
                SVCardCell *cell = (SVCardCell *)[self.payTable cellForRowAtIndexPath:idx];
                
                p_arr = [product_dic objectForKey:@"products"];
                
                for (int k=0; k<p_arr.count; k++) {
                    p_dic = [[p_arr objectAtIndex:k] mutableCopy];
                    NSString * pro_id = [p_dic objectForKey:@"pid"];
                    if ([pro_id intValue] == [product_id intValue]){
                        //重置number_id数据
                        int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                        
                        num_count = [[collection_number objectAtIndex:h]intValue];//放在单列里面此id产品消费次数
                        [[DataService sharedService].number_id removeObjectForKey:product_id];
                        [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];

                        [p_dic setValue:@"1" forKey:@"selected"];
                        [p_arr replaceObjectAtIndex:k withObject:p_dic];
                        
                        CGFloat scard_discount = 1 -[[p_dic objectForKey:@"pdiscount"]floatValue]/10;//折扣
                        CGFloat y =[[p_dic objectForKey:@"pprice"] floatValue];
                        
                        discount_y = discount_y +y *num_count *scard_discount;
                        //删除
                        [collection_temp addObject:[[DataService sharedService].svcardArray objectAtIndex:h]];
                        
                        UIButton *btn =(UIButton *)[cell viewWithTag:OPEN+k];
                        int tag = btn.tag;
                        btn.tag = tag - OPEN + CLOSE+k;
                        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                        if (discount_y<0) {
                            cell.lblPrice.text = @"0.00";
                        }else {
                            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y];
                        }
                        
                        
                        [product_dic setObject:p_arr forKey:@"products"];
                        [product_dic setObject:[NSString stringWithFormat:@"%.2f",discount_y] forKey:@"show_price"];
                        
                        NSString *p = [NSString stringWithFormat:@"%.2f",y *num_count *scard_discount];
                        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",product_dic,@"prod",idx,@"idx",@"2",@"type", nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];

                    }
                }
///
            }
        }
        if (collection_temp.count>0) {
            [[DataService sharedService].svcardArray removeObjectsInArray:collection_temp];
        }
    }
}
- (void)saleReload:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    
    NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];//服务／产品的id
    
    NSMutableArray *collection_index = [NSMutableArray array];//单个活动消费的产品index集合
    NSMutableArray *collection_id = [NSMutableArray array];//单个活动消费的产品id集合
    NSMutableArray *collection_number = [NSMutableArray array];//单个活动消费的产品number集合
    NSMutableArray *collection = [NSMutableArray array];//纪录位置
    NSMutableArray *collection2 = [NSMutableArray array];//纪录位置
    
    NSMutableArray *p_arr = nil;
    NSMutableDictionary *p_dic=nil;
    
    CGFloat discount_x = 0;
    CGFloat discount_y = 0;
    
    NSArray *array = [[DataService sharedService].number_id allKeys];
    if ([array containsObject:product_id]) {
        discount_x = [[dic objectForKey:@"price"] floatValue];//服务／产品的  单价
        int num_count = 0;//放在单列里面此id产品消费次数
        int index_row = 0;
        int num = 0;//活动里面剩余次数
        if ([DataService sharedService].row_id_numArray.count >0) {
            for (int i=0; i<[DataService sharedService].row_id_numArray.count; i++) {
                NSMutableString *str = [[DataService sharedService].row_id_numArray objectAtIndex:i];
                str = [NSMutableString stringWithString:[str substringToIndex:str.length-1]];
                NSArray *arr = [str componentsSeparatedByString:@"_"];
                [collection_index addObject:[arr objectAtIndex:0]];
                [collection_id addObject:[arr objectAtIndex:1]];
                [collection_number addObject:[arr objectAtIndex:2]];
                
            }
        }
        //遍历 id的集合找到位置
        for (int i=0; i<collection_id.count; i++) {
            NSString *prod_id = [collection_id objectAtIndex:i];
            if ([product_id intValue] == [prod_id intValue]) {
                [collection addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        NSMutableArray *collection_temp = [NSMutableArray array];//纪录row_id_numArray里面要删除的元素
        NSMutableArray *sale_tempArray = [NSMutableArray array];//纪录活动里面需要删除的数据
        
        if (collection.count>0) {
            for (int i=0; i<collection.count; i++) {
                int h = [[collection objectAtIndex:i]intValue];//位置
                //根据位置找到index
                index_row = [[collection_index objectAtIndex:h]intValue];
                //通过index找到的活动
                NSMutableDictionary *product_dic = [[DataService sharedService].productList objectAtIndex:index_row];
                
                discount_y = 0-[[product_dic objectForKey:@"show_price"]floatValue];//差价
                //通过index找到cell
                NSIndexPath *idx = [NSIndexPath indexPathForRow:index_row inSection:0];
                SVCardCell *cell = (SVCardCell *)[self.payTable cellForRowAtIndexPath:idx];
                
                p_arr = [product_dic objectForKey:@"products"];//活动里面产品的集合
                
                for (int k=0; k<p_arr.count; k++) {
                    p_dic = [[p_arr objectAtIndex:k] mutableCopy];
                    NSString * pro_id = [p_dic objectForKey:@"product_id"];//活动包含的服务/产品id
                    num = [[p_dic objectForKey:@"prod_num"]intValue];//活动里面剩余次数
                    if ([pro_id intValue] == [product_id intValue]) {//id相同,找到服务,产品
                        //重置number_id数据
                        int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                        
                        num_count = [[collection_number objectAtIndex:h]intValue];//放在单列里面此id产品消费次数
                        if ([DataService sharedService].saleArray.count>0) {
                            for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                                NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                                NSArray *arr = [str componentsSeparatedByString:@"_"];
                                NSString *s_id = [arr objectAtIndex:0];//活动id
                                if ([s_id intValue] == [[product_dic objectForKey:@"sale_id"] intValue]) {
                                    [sale_tempArray addObject:[[DataService sharedService].saleArray objectAtIndex:i]];
                                }
                            }
                        }
                        
                        [[DataService sharedService].number_id removeObjectForKey:product_id];
                        [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                        
                        [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                        [p_arr replaceObjectAtIndex:k withObject:p_dic];
                        //删除
                        [collection_temp addObject:[[DataService sharedService].row_id_numArray objectAtIndex:h]];
                    }else {
                        //遍历 id的集合找到位置
                        for (int m=0; m<collection_id.count; m++) {
                            NSString *prod_id = [collection_id objectAtIndex:m];
                            if ([prod_id intValue] == [pro_id intValue]) {
                                [collection2 addObject:[NSString stringWithFormat:@"%d",m]];
                            }
                        }
                        if (collection2.count>0) {
                            for (int j=0; j<collection2.count; j++) {
                                int d = [[collection2 objectAtIndex:j]intValue];
                                NSString *sale_index = [collection_index objectAtIndex:d];
                                if ([sale_index intValue] == index_row) {
                                    num_count = [[collection_number objectAtIndex:d]intValue];//放在单列里面此id产品消费次数
                                    
                                    if ([DataService sharedService].saleArray.count>0) {
                                        for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                                            NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                                            NSArray *arr = [str componentsSeparatedByString:@"_"];
                                            NSString *s_id = [arr objectAtIndex:0];//活动id
                                            if ([s_id intValue] == [[product_dic objectForKey:@"sale_id"] intValue]) {
                                                [sale_tempArray addObject:[[DataService sharedService].saleArray objectAtIndex:i]];
                                            }
                                        }
                                    }
                                    
                                    //重置number_id数据
                                    int count_num = [[[DataService sharedService].number_id objectForKey:pro_id]intValue];//剩余次数
                                    [[DataService sharedService].number_id removeObjectForKey:pro_id];
                                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:pro_id];
                                    
                                    [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                                    [p_arr replaceObjectAtIndex:k withObject:p_dic];
                                    //删除
                                    [collection_temp addObject:[[DataService sharedService].row_id_numArray objectAtIndex:d]];
                                }
                            }
                        }
                    }
                }
                UIButton *btn =(UIButton *)[cell viewWithTag:OPEN];
                int tag = btn.tag;
                btn.tag = tag - OPEN + CLOSE;
                [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                
                CGFloat lbl_price = [cell.lblPrice.text floatValue];
                if ((lbl_price+discount_y) <0.0001f ) {
                    cell.lblPrice.text = @"0.00";
                }else {
                    cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
                }
                [product_dic setValue:@"1" forKey:@"selected"];
                [product_dic setObject:p_arr forKey:@"products"];
                //////////////////////////////////////////////////////////////////////////////
                [product_dic setObject:@"0" forKey:@"show_price"];
                
                NSString *p = [NSString stringWithFormat:@"%.2f",discount_y];
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",product_dic,@"prod",idx,@"idx",@"2",@"type", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
            }
        }
        if (collection_temp.count>0) {
            [[DataService sharedService].row_id_numArray removeObjectsInArray:collection_temp];
        }
        if (sale_tempArray.count>0) {
            [[DataService sharedService].saleArray removeObjectsInArray:sale_tempArray];
        }
    }
}
#pragma mark 补充信息
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    if ([groupId isEqualToString:@"sex"]) {
        self.sexStr = [NSString stringWithFormat:@"%d",radio.tag];
    }else {
        if (radio.tag==0) {
            [self.txtCompany setEnabled:NO];
        }else {
            [self.txtCompany setEnabled:YES];
        }
        self.propertyStr = [NSString stringWithFormat:@"%d",radio.tag];
    }
}
-(IBAction)changeInfoBtnPressed:(id)sender {
    NSArray *s_subViews = [self.sexSelectedView subviews];
    for (UIView *v in s_subViews) {
        if ([v isKindOfClass:[QRadioButton class]]) {
            QRadioButton *btn = (QRadioButton *)v;
            if (btn.tag == [self.sexStr integerValue]) {
                [btn setChecked:YES];
            }
        }
    }
    
    NSArray *p_subViews = [self.propertySelectedView subviews];
    for (UIView *v in p_subViews) {
        if ([v isKindOfClass:[QRadioButton class]]) {
            QRadioButton *btn = (QRadioButton *)v;
            if (btn.tag == [self.propertyStr integerValue]) {
                [btn setChecked:YES];
            }
        }
    }
    
    CGRect frame1 = CGRectMake(0, 0, 815, 724);
    CGRect frame2 = CGRectMake(-815, 0, 815, 724);
    [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.infoView setFrame:frame1];
        [self.payView setFrame:frame2];
    }
                     completion:^(BOOL finished){
                         self.pageValue = 3;
                     }];
    
}
-(IBAction)infoFinishBtnPressed:(id)sender  {
    NSString *str = @"";
    //获取年份
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit  | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = [dateComponent year];

    if (self.txtName.text.length==0) {
        str = @"请输入你的姓名";
    }else if (self.secondArray.count == 0) {
        str = @"请选择汽车品牌";
    }
    if (str.length == 0) {
        if(self.txtPhone.text.length == 0 ) {
            str = @"请输入联系电话";
        }else {
            NSString *regexCall = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))|(((\\+86)|(86))?+\\d{11})$)";
            NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
            if ([predicateCall evaluateWithObject:self.txtPhone.text]) {
                
            }else {
                str = @"请输入准确的联系电话";
            }
        }
    }
    if (str.length == 0) {
        if ([self.propertyStr integerValue]==1) {
            if (self.txtCompany.text.length==0) {
                str = @"请输入单位名称";
            }else {
                self.lblCompany.hidden = NO;
                self.lbl_company.hidden = NO;
                self.lblCompany.text = self.txtCompany.text;
                self.lblproperty.text = @"单位";
            }
        }else {
            self.lblCompany.hidden = YES;
            self.lbl_company.hidden = YES;
            self.lblCompany.text = @"";
            self.txtCompany.text = @"";
            self.lblproperty.text = @"个人";
        }
    }
    if (str.length == 0) {
        if (self.txtCarYear.text.length == 0) {
            str = @"请输入购车时间";
        }else {
            //判断年份
            NSString *regexCall = @"(19[0-9]{2})|(2[0-9]{3})";
            NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
            if ([predicateCall evaluateWithObject:self.txtCarYear.text]) {
                int car_year = [self.txtCarYear.text intValue];
                if (car_year > year) {
                    str = @"请输入准确的购车时间";
                }
            }else {
                str = @"请输入准确的购车时间";
            }
        }
    }
    if (self.txtKm.text.length!=0 && str.length==0) {
        NSString *regexCall =@"^\\d+$";
        NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
        if (![predicateCall evaluateWithObject:self.txtKm.text]) {
            str = @"请输入准确的行车里程";
        }
    }
    
    if (str.length>0) {
        [Utils errorAlert:str];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认电话号码?" message:self.txtPhone.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=999;
        [alert show];
    }
}
- (NSString *)checkForm {
    NSMutableString *prod_ids = [NSMutableString string];
    int x=0;
    for (NSDictionary *product in self.payResult) {
        if ([product objectForKey:@"id"]){
            //服务
            NSMutableArray *tempArray = [NSMutableArray array];
            if ([DataService sharedService].id_count_price.count>0) {
                for (int i=0; i<[DataService sharedService].id_count_price.count; i++) {
                    NSMutableString *str = [[DataService sharedService].id_count_price objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    NSString *p_id = [arr objectAtIndex:0];//产品id
                    if ([p_id intValue] == [[product objectForKey:@"id"]intValue]) {
                        if (![tempArray containsObject:p_id]) {
                            [prod_ids appendFormat:@"0_%@,",str];
                            [tempArray addObject:p_id];
                        }
                    }
                }
            }
        }else if([product objectForKey:@"sale_id"] && [[product objectForKey:@"selected"] intValue] == 0){
            //活动
            x += 1;
            if ([DataService sharedService].saleArray.count>0) {
                for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                    NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    NSString *s_id = [arr objectAtIndex:0];//活动id
                    if ([s_id intValue] == [[product objectForKey:@"sale_id"] intValue]) {
                        [prod_ids appendFormat:@"1_%@,",str];
                    }
                }
            }
            
        }else if([product objectForKey:@"svid"]){
            if ([[product objectForKey:@"svtype"]intValue ] == 1) {//购买的储值卡
                if (self.isExitSvcard == YES) {
                    [prod_ids appendFormat:@"2_%d_%d_%d_%@,",[[product objectForKey:@"svid"] intValue],[[product objectForKey:@"svtype"] intValue],[[product objectForKey:@"is_new"] intValue],self.sv_card_password];
                }else {
                    [prod_ids appendFormat:@"2_%d_%d_%d,",[[product objectForKey:@"svid"] intValue],[[product objectForKey:@"svtype"] intValue],[[product objectForKey:@"is_new"] intValue]];
                }
            }else {//打折卡
                NSMutableString *c_str = [NSMutableString string];
                for (NSDictionary *pro in [product objectForKey:@"products"]) {
                    if([[pro objectForKey:@"selected"] intValue]==0) {
                        for (int i=0; i<[DataService sharedService].svcardArray.count; i++) {
                            NSMutableString *str = [[DataService sharedService].svcardArray objectAtIndex:i];
                            NSArray *arr = [str componentsSeparatedByString:@"_"];
                            NSString *s_id = [arr objectAtIndex:1];
                            if ([s_id intValue] == [[pro objectForKey:@"pid"]intValue]) {
                                CGFloat scard_discount = 1 -[[pro objectForKey:@"pdiscount"]floatValue]/10;//折扣
                                CGFloat y = [[pro objectForKey:@"pprice"] floatValue];//单价
                                [c_str appendFormat:@"%d=%.2f=%d_",[s_id intValue],scard_discount*y*[[arr objectAtIndex:2]intValue],[[arr objectAtIndex:2]intValue]];
                            }
                        }
                    }
                }
                if ([[product objectForKey:@"is_new"] intValue] == 1) {
                    [prod_ids appendFormat:@"2_%d_%d_%d_%@,",[[product objectForKey:@"svid"] intValue],[[product objectForKey:@"svtype"] intValue],[[product objectForKey:@"is_new"] intValue],c_str];
                }else if ([[product objectForKey:@"is_new"] intValue]==0 && c_str.length>0){
                    [prod_ids appendFormat:@"2_%d_%d_%d_%@%d,",[[product objectForKey:@"svid"] intValue],[[product objectForKey:@"svtype"] intValue],[[product objectForKey:@"is_new"] intValue],c_str,[[product objectForKey:@"csrid"] intValue]];
                }
            }
        }else if([product objectForKey:@"pid"]){
            //套餐卡
            NSMutableString *p_str = [NSMutableString string];
            for (NSDictionary *pro in [product objectForKey:@"products"]) {
                if([[pro objectForKey:@"selected"] intValue]==0){
                    
                    int num = [[pro objectForKey:@"Total_num"]intValue] - [[pro objectForKey:@"pro_left_count"]intValue];
                    [p_str appendFormat:@"%d=%d_",[[pro objectForKey:@"proid"] intValue],num];
                }
            }
            int has_pcard = [[product objectForKey:@"is_new"] intValue];
            if (has_pcard == 1) {
                [prod_ids appendFormat:@"3_%d_%d,",[[product objectForKey:@"pid"] intValue],[[product objectForKey:@"is_new"] intValue]];
            }else if (has_pcard==0 && p_str.length>0){
                [prod_ids appendFormat:@"3_%d_%d_%@%d,",[[product objectForKey:@"pid"] intValue],[[product objectForKey:@"is_new"] intValue],p_str,[[product objectForKey:@"cprid"] intValue]];
            }
        }
    }
    if (x>1) {
        return @"";
    }
    return prod_ids;
}
- (void)closepopView:(KeyViewController *)keyView{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    if (keyViewController.isSuccess) {
        self.sv_card_password = keyViewController.passWord;
        if ([DataService sharedService].isJurisdiction==0) {
            [self goTofastOrder];
        }else {
            [self comfirmOrderInfo];
        }
    }
    keyViewController = nil;
}
-(NSMutableDictionary *)pastInfo {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *str = [self checkForm];
    //汽车品牌
    BrandModel *brand = [self.secondArray objectAtIndex:[self.brandView selectedRowInComponent:1]];
    if (brand.modelList != nil) {
        ModelModel *model = [brand.modelList objectAtIndex:[self.brandView selectedRowInComponent:2]];
        [dic setObject:[NSString stringWithFormat:@"%@_%@",brand.brand_id,model.model_id]forKey:@"brand"];
    }else {
        [dic setObject:[NSString stringWithFormat:@"%@",brand.brand_id] forKey:@"brand"];
    }
    if (self.txtCarYear.text.length>0) {
        [dic setObject:self.txtCarYear.text forKey:@"year"];
    }
    if (self.txtBirth.text.length>0) {
        [dic setObject:self.txtBirth.text forKey:@"birth"];
    }
    if (self.txtKm.text.length>0){
        [dic setObject:self.txtKm.text forKey:@"cdistance"];
    }
    [dic setObject:self.txtName.text forKey:@"userName"];
    [dic setObject:self.txtPhone.text forKey:@"phone"];
    [dic setObject:self.sexStr forKey:@"sex"];
    [dic setObject:self.propertyStr forKey:@"cproperty"];
    [dic setObject:self.txtCompany.text forKey:@"cgroup_name"];
    [dic setObject:[self.customer objectForKey:@"oid"] forKey:@"order_id"];
    [dic setObject:[self.customer objectForKey:@"cid"] forKey:@"customer_id"];
    [dic setObject:[self.customer objectForKey:@"cnum_id"] forKey:@"car_num_id"];
    [dic setObject:[self.customer objectForKey:@"opname"] forKey:@"content"];
    [dic setObject:[self.customer objectForKey:@"oprice"] forKey:@"oprice"];
    [dic setObject:[NSString stringWithFormat:@"%d",self.svSegBtn.selectedIndex] forKey:@"is_please"];
    [dic setObject:[NSString stringWithFormat:@"%.2f",self.total_count] forKey:@"total_price"];
    [dic setObject:[str substringToIndex:str.length - 1] forKey:@"prods"];
    return dic;
}
-(void)comfirmOrderInfo {
    payStyleView = nil;
    payStyleView = [[PayStyleViewController alloc] initWithNibName:@"PayStyleViewController" bundle:nil];
    payStyleView.delegate = self;

    NSMutableDictionary *dic = [self pastInfo];
    payStyleView.save_cardArray = [NSMutableArray arrayWithArray:self.save_cardArray];
    payStyleView.order = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [self presentPopupViewController:payStyleView animationType:MJPopupViewAnimationSlideBottomBottom];
}
#pragma mark lifestyle

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(netWork:) userInfo:nil repeats:YES];

    NSArray *subviews = [self.pay_bottom_view subviews];
    if ([DataService sharedService].payNumber ==1) {
        for (UIView *vv in subviews) {
            if ([vv isKindOfClass:[SVSegmentedControl class]]) {
                SVSegmentedControl *vv_svSeg = (SVSegmentedControl *)vv;
                vv_svSeg.isCanSelected = NO;
            }
        }
    }else {
        for (UIView *vv in subviews) {
            if ([vv isKindOfClass:[SVSegmentedControl class]]) {
                SVSegmentedControl *vv_svSeg = (SVSegmentedControl *)vv;
                [vv_svSeg moveThumbToIndex:3 animate:YES];
            }
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark 付款
//套餐卡下单
-(void)package_payOrder:(id)sender {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else {
        self.isSuccess=1;
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        packagePayInterface *log = [[packagePayInterface alloc]init];
        self.p_payInterface = log;
        self.p_payInterface.delegate = self;

        [self.p_payInterface getPackageInterfaceDelegateWithorderId:[self.customer objectForKey:@"oid"] andType:@"1" andPleased:[NSString stringWithFormat:@"%d",self.svSegBtn.selectedIndex]];
    }
}
//正常下单
-(void)payOrder:(id)sender {
    self.isExitSvcard = NO;
    NSString *str = @"";
    if ([self.prod_type integerValue]==2) {
        if (self.txtName.text.length==0) {
            str = @"请补充信息";
        }
        if (str.length==0 && self.txtPhone.text.length == 0) {
            str = @"请补充信息";
        }
        if (str.length==0 && self.txtBrand.text.length == 0) {
            str = @"请补充信息";
        }
    }
    if (str.length>0) {
        [Utils errorAlert:str];
    }else {
        NSString *string = [self checkForm];
        if ([string length]>0) {
            for (NSDictionary *product in self.payResult) {
                if([product objectForKey:@"svid"] && [[product objectForKey:@"svtype"]intValue]==1) {
                    self.isExitSvcard = YES;
                    keyViewController = nil;
                    keyViewController = [[KeyViewController alloc]initWithNibName:@"KeyViewController" bundle:nil];
                    keyViewController.delegate = self;
                    [self presentPopupViewController:keyViewController animationType:MJPopupViewAnimationSlideBottomBottom];
                }
            }
            if (self.isExitSvcard == NO) {
                if ([DataService sharedService].isJurisdiction==1) {//付款权限
                    [self comfirmOrderInfo];
                }else {
                    [self goTofastOrder];
                }
            }
        }else{
            [Utils errorAlert:@"活动最多可以选择一个"];
        }
    }
}
-(void)goTofastOrder {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        NSMutableDictionary *dic = [self pastInfo];
        [dic setObject:[DataService sharedService].store_id forKey:@"store_id"];
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        NSMutableURLRequest *request=[Utils getRequest:dic string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kConfirm]];
        NSOperationQueue *queue=[[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
             if ([data length]>0 && error==nil) {
                 [self performSelectorOnMainThread:@selector(confirmOrder:) withObject:data waitUntilDone:NO];
             }
         }
         ];
    }
}
-(void)confirmOrder:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if ([[jsonData objectForKey:@"status"]intValue] == 1) {
                NSDictionary *order_dic = [jsonData objectForKey:@"orders"];
                [self setStationDataWithDic:order_dic];
                
                [Utils errorAlert:@"订单确认成功,请到后台付款!"];
                CGRect frame1 = CGRectMake(0, 0, 815, 724);
                CGRect frame2 = CGRectMake(-815, 0, 815, 724);
                [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.viewLeft setFrame:frame1];
                    [self.searchView setFrame:frame2];
                    [self.payView setFrame:frame2];
                }
                                 completion:^(BOOL finished){
                                     self.pageValue = 0;
                                [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                                 }];
            }else {
                [Utils errorAlert:[jsonData objectForKey:@"msg"]];
            }
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
        }
    }
}
-(IBAction)cancelOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTip message:@"确定取消订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=99000;
    [alert show];
}

- (void)closePopVieww:(PayStyleViewController *)payStyleViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    
    if (payStyleViewController.isSuccess) {
        if (payStyleViewController.waittingCarsArr.count>0) {
            self.waittingCarsArr = payStyleViewController.waittingCarsArr;
        }else {
            self.waittingCarsArr = [[NSMutableArray alloc]init];
        }
        if (payStyleViewController.beginningCarsDic.allKeys.count>0) {
            self.beginningCarsDic = payStyleViewController.beginningCarsDic;
        }else {
            self.beginningCarsDic = [[NSMutableDictionary alloc]init];
        }
        if (payStyleViewController.finishedCarsArr.count>0) {
            self.finishedCarsArr = payStyleViewController.finishedCarsArr;
        }else {
            self.finishedCarsArr = [[NSMutableArray alloc]init];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setWaittingScrollViewContext];
        [self moveCarIntoCarPosion];
        [self setFinishedScrollViewContext];
        CGRect frame1 = CGRectMake(0, 0, 815, 724);
        CGRect frame2 = CGRectMake(-815, 0, 815, 724);
        if ([DataService sharedService].payViewFrom == 0) {
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.viewLeft setFrame:frame1];
                [self.searchView setFrame:frame2];
                [self.payView setFrame:frame2];
                [self.infoView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue = 0;
                                 [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                             }];
        }else {
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.viewLeft setFrame:frame2];
                [self.searchView setFrame:frame1];
                [self.payView setFrame:frame2];
                [self.infoView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue = 1;
                             }];
        }
        payStyleView = nil;
    });
}

#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }else {
        if (alertView.tag == 99) {
            CGRect frame1 = CGRectMake(0, 0, 815, 724);
            CGRect frame2 = CGRectMake(-815, 0, 815, 724);
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.viewLeft setFrame:frame1];
                [self.searchView setFrame:frame2];
                [self.payView setFrame:frame2];
                [self.infoView setFrame:frame2];
            }
                             completion:^(BOOL finish){
                                 self.pageValue = 0;
                                 [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                             }];
            
            [self.txtSearch resignFirstResponder];
            [self.txtCarYear resignFirstResponder];
            [self.txtName resignFirstResponder];
            [self.txtPhone resignFirstResponder];
            [self.carNumberTextField.textField resignFirstResponder];
            [self.txtKm resignFirstResponder];
            [self.txtCompany resignFirstResponder];
            [self quickToMakeOrder];
            
        }else if (alertView.tag == 999){
            self.lblBrand.text = self.txtBrand.text;
            self.lblPhone.text = self.txtPhone.text;
            self.lblUsername.text = self.txtName.text;

            CGRect frame1 = CGRectMake(0, 0, 815, 724);
            CGRect frame2 = CGRectMake(-815, 0, 815, 724);
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.payView setFrame:frame1];
                [self.infoView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue = 2;
                             }];
        }
        else {
            if (self.make_order==1) {
                if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
                    LanTanDB *db = [[LanTanDB alloc]init];
                    OrderInfo *order = [[OrderInfo alloc]init];
                    order.order_id = [NSString stringWithFormat:@"%@",[self.customer objectForKey:@"oid"]];
                    order.status = [NSString stringWithFormat:@"%d",0];
                    order.store_id = [NSString stringWithFormat:@"%@",[DataService sharedService].store_id];
                    [db addDataWithDictionary:order];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Utils errorAlert:@"订单已取消"];
                        
                        CGRect frame1 = CGRectMake(0, 0, 815, 724);
                        CGRect frame2 = CGRectMake(-815, 0, 815, 724);
                        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [self.viewLeft setFrame:frame2];
                            [self.searchView setFrame:frame1];
                            [self.payView setFrame:frame2];
                            [self.infoView setFrame:frame2];
                        }
                                         completion:^(BOOL finished){
                                             self.pageValue = 1;
                                         }];
                        
                    });
                }else {
                    AppDelegate *app = [AppDelegate shareInstance];
                    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
                    CancleOrderInterface *log = [[CancleOrderInterface alloc]init];
                    self.cancleOrderInterface = log;
                    self.cancleOrderInterface.delegate = self;
                    [self.cancleOrderInterface getCancleOrderInterfaceDelegateWithorderId:[self.customer objectForKey:@"oid"]];
                }
            }else {
                if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
                    [Utils errorAlert:@"暂无网络!"];
                }else {
                    self.isSuccess=0;
                    AppDelegate *app = [AppDelegate shareInstance];
                    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
                    packagePayInterface *log = [[packagePayInterface alloc]init];
                    self.p_payInterface = log;
                    self.p_payInterface.delegate = self;
                    [self.p_payInterface getPackageInterfaceDelegateWithorderId:[self.customer objectForKey:@"oid"] andType:@"0" andPleased:[NSString stringWithFormat:@"%d",self.svSegBtn.selectedIndex]];
                }
            }
        }
    }
}
#pragma mark 取消订单代理
-(void)getCancleOrderInfoDidFinished:(NSDictionary *)result; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *order_dic = [result objectForKey:@"orders"];
            [self setStationDataWithDic:order_dic];
            [Utils errorAlert:@"订单已取消"];
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            CGRect frame1 = CGRectMake(0, 0, 815, 724);
            CGRect frame2 = CGRectMake(-815, 0, 815, 724);
            
            if ([DataService sharedService].payViewFrom == 0) {
                [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.viewLeft setFrame:frame1];
                    [self.searchView setFrame:frame2];
                    [self.payView setFrame:frame2];
                    [self.infoView setFrame:frame2];
                }
                                 completion:^(BOOL finished){
                                     self.pageValue = 0;
                                [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                                 }];
            }else {
                [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.viewLeft setFrame:frame2];
                    [self.searchView setFrame:frame1];
                    [self.payView setFrame:frame2];
                    [self.infoView setFrame:frame2];
                }
                                 completion:^(BOOL finished){
                                     self.pageValue = 1;
                                 }];
            }
            
        });
    });
}
-(void)getCancleOrderInfoDidFailed:(NSString *)errorMsg; {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark packagePayInterfaceDelegate
-(void)getPackageInfoDidFinished:(NSDictionary *)result; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            
            if (self.isSuccess==0) {
                [Utils errorAlert:@"取消订单成功!"];
            }else if (self.isSuccess==1){
                [Utils errorAlert:@"支付成功!"];
            }
            CGRect frame1 = CGRectMake(0, 0, 815, 724);
            CGRect frame2 = CGRectMake(-815, 0, 815, 724);
            
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.viewLeft setFrame:frame1];
                [self.searchView setFrame:frame2];
                [self.payView setFrame:frame2];
                [self.infoView setFrame:frame2];
                [self.packageView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue = 0;
                                 [self addRightnaviItemsWithImage:nil andImage:@"refresh"];
                                 //工位情况
                                 NSDictionary *order_dic = [result objectForKey:@"orders"];
                                 [self setStationDataWithDic:order_dic];
                             }];
            

        });
    });
}
-(void)getPackageInfoDidFailed:(NSString *)errorMsg; {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}

@end
