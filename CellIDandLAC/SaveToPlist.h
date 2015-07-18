//
//  SaveToPlist.h
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/13.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveToPlist : NSObject

+ (NSString*) creatPlist;

+ (BOOL) saveDataToPlist:(NSMutableArray*) searchArray;

+ (NSMutableArray*) readDataFromePlist;

+ (BOOL) isPlistNull;

+ (void) removeDataFromePlist;

@end
