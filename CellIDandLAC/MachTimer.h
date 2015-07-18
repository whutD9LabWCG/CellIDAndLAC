//
//  MachTimer.h
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/12.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <mach/mach_time.h>


@interface MachTimer : NSObject
{
    uint64_t timeZero;
}
+ (id) timer;
- (void) start;
- (uint64_t) elapsed;
- (float) elapsedSeconds;

@end
