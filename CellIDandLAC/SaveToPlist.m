//
//  SaveToPlist.m
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/13.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#import "SaveToPlist.h"

@implementation SaveToPlist

+ (NSString*) creatPlist
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString* fileName = [path stringByAppendingPathComponent:@"CellIDS.plist"];   //获取路径
    NSLog(@"%@",fileName);
    return fileName;
}

+ (BOOL) saveDataToPlist:(NSMutableArray*) searchArray
{
//    [searchArray writeToFile:[self creatPlist] atomically:YES];
    BOOL isSuccess = [searchArray writeToFile:[self creatPlist] atomically:YES];
    NSLog(isSuccess?@"yes":@"no");
    return isSuccess;
}

+ (NSMutableArray*) readDataFromePlist
{
    NSMutableArray* searchArray = [[NSMutableArray alloc] initWithContentsOfFile:[self creatPlist]];
    return searchArray;
}

+ (BOOL) isPlistNull{
    NSMutableArray *isExist = [[NSMutableArray alloc]initWithContentsOfFile:[self creatPlist]];
    BOOL isPlistNull  = (isExist.count == 0)? YES:NO;
    return isPlistNull;
}

+ (void) removeDataFromePlist
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[self creatPlist] error:&error];
    if (error != nil) {
        NSLog(@"删除文件错误:%@",error);
    }
}

@end
