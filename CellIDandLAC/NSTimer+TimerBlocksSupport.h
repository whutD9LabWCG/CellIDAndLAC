//
//  NSTimer+TimerBlocksSupport.h
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/26.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (TimerBlocksSupport)

+ (NSTimer *)timerBlocks_scheduledTimerWithTimerInteval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

@end
