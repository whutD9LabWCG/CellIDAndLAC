//
//  ViewController.m
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/11.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#import "ViewController.h"
#import "CoreTelephony.h"
#import "SaveToPlist.h"

#import "MachTimer.h"

@interface ViewController ()<UIAlertViewDelegate>
{
    BOOL isFinished;
    
    NSMutableArray *arrayOfCellIDS;
    NSMutableDictionary *dictOfCellID_Time;
    NSMutableDictionary *dictOfOneLocation;
    NSMutableArray *arrayOfDicts;
    
    MachTimer *timer;
    float elapsedTime;
    
    UIAlertView *clearErrorDataAlert;
    UIAlertView *clearAllDataAlert;
    
}
@property (weak, nonatomic) IBOutlet UITextField *locationName;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearErrorBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveLocationData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayOfCellIDS  = [[NSMutableArray alloc]init];
    dictOfCellID_Time = [[NSMutableDictionary alloc]init];
    dictOfOneLocation = [[NSMutableDictionary alloc]init];
    arrayOfDicts = [[NSMutableArray alloc]init];
    isFinished = NO;
    timer = [MachTimer timer];
    
    self.startBtn.enabled = YES;
    self.endBtn.enabled = NO;
    self.clearErrorBtn.enabled = NO;
    self.saveLocationData.enabled = NO;
    
    self.locationName.enabled = NO;
    
    id CTConnection = _CTServerConnectionCreate(NULL, CellMonitorCallback, NULL);
    _CTServerConnectionAddToRunLoop(CTConnection, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    _CTServerConnectionRegisterForNotification(CTConnection, kCTCellMonitorUpdateNotification);
    _CTServerConnectionCellMonitorStart(CTConnection);
    
}
- (IBAction)startBtn:(UIButton *)sender {
    [timer start];
    
    NSString *cidStr = self.cellID.text;
//    [dictOfCellID_Time setObject:@0 forKey:[NSNumber numberWithInteger:[cidStr integerValue]]];
//    [arrayOfCellIDS addObject:[NSNumber numberWithInteger:[cidStr integerValue]]];

    [dictOfCellID_Time setObject:@"0" forKey:cidStr];
    [arrayOfCellIDS addObject:cidStr];
    
    self.startBtn.enabled = NO;
    self.endBtn.enabled = YES;
    self.clearErrorBtn.enabled = YES;
    self.saveLocationData.enabled = NO;
    
    self.locationName.enabled = NO;
}
- (IBAction)endBtn:(UIButton *)sender {
    elapsedTime = [timer elapsedSeconds];
    isFinished = YES;
    
    float lastTotalTime = [[dictOfCellID_Time objectForKey:[arrayOfCellIDS lastObject]] floatValue];
    lastTotalTime += elapsedTime;
    [dictOfCellID_Time setObject:[NSString stringWithFormat:@"%f",lastTotalTime] forKey:[arrayOfCellIDS lastObject]];
    
    
    self.startBtn.enabled = NO;
    self.endBtn.enabled = NO;
    self.clearErrorBtn.enabled = YES;
    self.saveLocationData.enabled = YES;
    
    self.locationName.enabled = YES;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示消息"
                                                   message:@"请输入录入基站地点名称"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}
- (IBAction)saveBtn:(UIButton *)sender {
    
    if (self.locationName.text.length) {
        NSLog(@"%@",dictOfCellID_Time);
        if (dictOfCellID_Time.count) {
            [dictOfOneLocation setObject:dictOfCellID_Time forKey:self.locationName.text];
            BOOL isPlistNull = [SaveToPlist isPlistNull];
            if (!isPlistNull) {
                arrayOfDicts = [SaveToPlist readDataFromePlist];
            }
            [arrayOfDicts addObject:dictOfOneLocation];
            
            BOOL isSuccess = [SaveToPlist saveDataToPlist:arrayOfDicts];
            NSLog(@"存入plist的所有的dictionary%@",[SaveToPlist readDataFromePlist]);
            
            [arrayOfCellIDS removeAllObjects];
            [dictOfCellID_Time removeAllObjects];
            [dictOfOneLocation removeAllObjects];
            [arrayOfDicts removeAllObjects];
            
            isFinished = NO;
            
            self.startBtn.enabled = YES;
            self.endBtn.enabled = NO;
            self.clearErrorBtn.enabled = NO;
            self.saveLocationData.enabled = NO;
            
            self.locationName.enabled = NO;
            
            if (isSuccess) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示消息"
                                                               message:@"录入基站数据成功！"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示消息"
                                                               message:@"录入基站数据失败！"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                [alert show];
            }

        }
        else {
            NSLog(@"要录入的基站采集数据为空！");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示消息"
                                                           message:@"要录入的基站采集数据为空！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示消息"
                                                       message:@"录入基站地点名称为空"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }

}

#pragma mark -  基站变化回调函数
- (void)notificationHandler:(NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    
    if (!isFinished) {
        if (arrayOfCellIDS.count) {
            if (![[dict objectForKey:@"CID"] isEqualToString:[arrayOfCellIDS lastObject]]) {
                elapsedTime = [timer elapsedSeconds];
                NSLog(@"------%f",elapsedTime);
                
                float lastTotalTime = [[dictOfCellID_Time objectForKey:[arrayOfCellIDS lastObject]] floatValue];
                NSLog(@"初始值%f",lastTotalTime);
                
                lastTotalTime += elapsedTime;
                NSLog(@"+++++++%f",lastTotalTime);
                
                [dictOfCellID_Time setObject:[NSString stringWithFormat:@"%f",lastTotalTime] forKey:[arrayOfCellIDS lastObject]];
                [arrayOfCellIDS addObject:[dict objectForKey:@"CID"]];
                
                [timer start];
            }
        }
    }
    else NSLog(@"fishedddddddddd");
    
    NSLog(@"/////////%@",[dict objectForKey:@"CID"]);
    self.LAC.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"LAC"]];
    self.cellID.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CID"]];
}

#pragma mark -  清除数据

- (IBAction)clearTheErrorData:(UIButton *)sender {
    clearErrorDataAlert = [[UIAlertView alloc]initWithTitle:@"提示消息"
                                                   message:@"要删除有问题数据吗？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确认",nil];
    [clearErrorDataAlert show];
}

- (IBAction)clearAllData:(UIButton *)sender {
    clearAllDataAlert = [[UIAlertView alloc]initWithTitle:@"提示消息"
                                                   message:@"要删除Plist文件内容吗？"
                                                  delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确认",nil];
    [clearAllDataAlert show];
}

#pragma mark - uialerviewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == clearErrorDataAlert) {
        if(buttonIndex == 1)
        
        [arrayOfCellIDS removeAllObjects];
        [dictOfCellID_Time removeAllObjects];
        [dictOfOneLocation removeAllObjects];
        [arrayOfDicts removeAllObjects];
        
        isFinished = NO;
        
        self.startBtn.enabled = YES;
        self.endBtn.enabled = NO;
        self.clearErrorBtn.enabled = YES;
        self.saveLocationData.enabled = NO;
        
        self.locationName.enabled = NO;
    }
    if (alertView == clearAllDataAlert) {
        if (buttonIndex == 1) {
            
            [SaveToPlist removeDataFromePlist];
            
            [arrayOfCellIDS removeAllObjects];
            [dictOfCellID_Time removeAllObjects];
            [dictOfOneLocation removeAllObjects];
            [arrayOfDicts removeAllObjects];
        }
    }
}


#pragma mark -  通知的註冊和發送
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationHandler:) name:@"CellIDandLAC" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated

{
    [super viewDidDisappear:YES];
    [self deregisterNotification];
}

- (void)dealloc {
    [self deregisterNotification];
}

-(void)deregisterNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CellIDandLAC" object:nil];
}

# pragma 关闭虚拟键盘

// 通过点击return关闭虚拟键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// 通过点击背景关闭虚拟键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - button colorset

-  (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - Btn set

- (void)setStartBtn:(UIButton *)startBtn
{
    _startBtn = startBtn;
    [_startBtn setBackgroundImage:[self imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_startBtn setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateDisabled];
}

-(void)setEndBtn:(UIButton *)endBtn
{
    _endBtn = endBtn;
    [_endBtn setBackgroundImage:[self imageWithColor:[UIColor greenColor]] forState:UIControlStateNormal];
    [_endBtn setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateDisabled];
    
}

- (void)setClearErrorBtn:(UIButton *)clearErrorBtn
{
    _clearErrorBtn = clearErrorBtn;
    [_clearErrorBtn setBackgroundImage:[self imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
    [_clearErrorBtn setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateDisabled];
}

-(void)setClearAllBtn:(UIButton *)clearAllBtn
{
    _clearAllBtn = clearAllBtn;
    [_clearAllBtn setBackgroundImage:[self imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
    [_clearAllBtn setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateDisabled];
}

- (void)setSaveLocationData:(UIButton *)saveLocationData
{
    _saveLocationData = saveLocationData;
    [_saveLocationData setBackgroundImage:[self imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    [_saveLocationData setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateDisabled];
}

@end
