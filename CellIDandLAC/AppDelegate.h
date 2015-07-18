//
//  AppDelegate.h
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/11.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LogUtility(fmt, ...) NSLog((@"\n[AppName:ThemeHotel]\n[Func:%s]\n[Line %d]\n[Time %s [%s]]" fmt),__FUNCTION__,__LINE__,__DATE__,__TIME__,##__VA_ARGS__);

#define LogUInfo LogUtility(@"");

#define CMLog(format, ...) NSLog(@"running------>%s:%@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__]);

#define MARK CMLog(@"");


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

