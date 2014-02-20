//
//  LanTaiMenuMainController.h
//  LanTai
//
//  Created by david on 13-10-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BZGFormField.h"
#import "CarCellView.h"
#import "DRScrollView.h"
#import "ProAndServiceCell.h"
#import "BaseViewController.h"
#import "OrderViewController.h"
#import "CardCell.h"
#import "SyncInterface.h"
#import "GetServiceInterface.h"
#import "SearchInterface.h"
#import "CarBrandModel.h"
#import "CancleOrderInterface.h"
#import "UserViewController.h"
#import "SVSegmentedControl.h"
#import "ServeItemView.h"
#import "RecordTableFooter.h"
#import "PackagePayView.h"
#import "packagePayInterface.h"
@class ShaixuanView;
@protocol BZGFormFieldDelegate;

@interface LanTaiMenuMainController : BaseViewController<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BZGFormFieldDelegate,CarCellViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate,OrderViewDelegate,GetServiceInterfaceDelegate,SearchInterfaceDelegate,SyncInterfaceDelegate,UIAlertViewDelegate,CancleOrderInterfaceDelegate,UserViewDelegate,ServeItemViewDelegate,RecordTableFooterDelegate,PackagePayViewDelegate,packagePayInterfaceDelegate>

@property (nonatomic, strong) packagePayInterface *p_payInterface;
@property (nonatomic, strong) PackagePayView *packagePayView;
@property (nonatomic, strong) CancleOrderInterface *cancleOrderInterface;
@property (nonatomic, strong) SyncInterface*syncInterface;
@property (nonatomic, strong) GetServiceInterface *getServiceInterface;
@property (nonatomic, strong) SearchInterface *searchInterface;
@property (nonatomic, strong) UserViewController *userView;
@property (nonatomic, strong) OrderViewController *orderView;
@property (strong, nonatomic) IBOutlet UIScrollView *leftTopScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *bottomLeftScrollView;
@property (strong, nonatomic) IBOutlet DRScrollView *middleScrollView;

@property (strong, nonatomic) IBOutlet UIView *leftBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *viewLeft;
@property (strong, nonatomic) IBOutlet BZGFormField *carNumberTextField;
@property (strong, nonatomic) IBOutlet UIView *leftMiddlebgView;
@property (strong, nonatomic) IBOutlet UIView *rightBackgroundView;
@property (nonatomic, strong) NSIndexPath *idx_path;
@property (nonatomic, strong) CarBrandModel *car_brand;
@property (nonatomic,strong) IBOutlet UITableView *orderTable;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) ShaixuanView *sxView;
@property (nonatomic,strong) NSMutableArray *letterArray;

@property (nonatomic,strong) NSTimer *timer;

- (IBAction)touchDragGesture:(UIPanGestureRecognizer *)sender;

@property (nonatomic,strong) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) IBOutlet UIView *sub_view;
//搜索界面
@property (nonatomic, strong) IBOutlet UIView *searchView;
@property (nonatomic, strong) IBOutlet UITextField *txtSearch;
@property (nonatomic, strong) UITableView *searchTable;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, assign) NSInteger selectClassify;
@property (nonatomic, strong) NSMutableArray *save_cardArray;
//信息页面
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (nonatomic,strong) IBOutlet UITextField *txtCarNum,*txtCarYear,*txtName,*txtPhone,*txtBirth,*txtBrand,*txtKm,*txtCompany;
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) IBOutlet UIPickerView *brandView;
@property (weak, nonatomic) IBOutlet UIView *sexSelectedView;
@property (weak, nonatomic) IBOutlet UIView *propertySelectedView;

//付款页面
@property (nonatomic, strong) IBOutlet UIButton *addInfo;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
@property (nonatomic, assign) NSInteger isSuccess;
@property (nonatomic, strong) IBOutlet UIButton *pay_btn;
@property (strong, nonatomic) NSString *prod_type;//判断购买的是产品、服务、卡类
@property (strong, nonatomic) NSString *sv_card_password;///设置密码
@property (assign, nonatomic) BOOL isExitSvcard;//判断是否存在储值卡
@property (nonatomic, strong) IBOutlet UIView *pay_bottom_view;
@property (nonatomic, strong) SVSegmentedControl *svSegBtn;
@property (nonatomic, assign) BOOL isCommiting;//判断是否跳转评价页面
@property (nonatomic, strong) NSMutableDictionary *customer;
@property (nonatomic, strong) NSMutableArray *brandList;
@property (nonatomic, strong) NSMutableArray *firstArray,*secondArray,*thirdArray;

@property (nonatomic, strong) NSMutableArray *payResult;
@property (strong, nonatomic) IBOutlet UIView *payView;
@property (nonatomic, strong) IBOutlet UILabel *lblCarNum,*lblBrand,*lblUsername,*lblPhone,*lblTotal,*lblcode,*lblproperty,*lblCompany,*lbl_company;
@property (nonatomic, strong) UITableView *payTable;
@property (nonatomic, assign) CGFloat total_count;
@property (nonatomic, assign) CGFloat total_count_temp;
//套餐卡页面
@property (nonatomic, strong) IBOutlet UITextField *package_search_txt;
@property (nonatomic, strong) NSString *is_car_num;//0:车牌  1:电话
@property (nonatomic, strong) NSMutableDictionary *package_customer;
@property (strong, nonatomic) IBOutlet UIView *packageView;
@property (nonatomic, strong) IBOutlet UILabel *p_carnum,*p_brand,*p_username,*p_phone,*p_property,*p_company;
@property (strong, nonatomic) IBOutlet UILabel *p_carnum_lbl,*p_brand_lbl,*p_username_lbl,*p_phone_lbl,*p_property_lbl,*p_company_lbl;
@property (nonatomic, strong) NSMutableArray *packageList;
@property (strong, nonatomic) UITableView *packageTable;
//控制页面
@property (nonatomic, assign) NSInteger pageValue;
@property (nonatomic, assign) NSInteger make_order;
@end
