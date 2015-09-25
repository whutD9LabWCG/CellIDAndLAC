//
//  NSTimer+TimerBlocksSupport.m
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/26.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#import "NSTimer+TimerBlocksSupport.h"

@implementation NSTimer (TimerBlocksSupport)

+ (NSTimer *)timerBlocks_scheduledTimerWithTimerInteval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer
{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
