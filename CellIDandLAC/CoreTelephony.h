//
//  CoreTelephony.h
//  CellIDandLAC
//
//  Created by Mr.Chang on 15/7/11.
//  Copyright © 2015年 Mr.Chang. All rights reserved.
//

#ifndef CoreTelephony_h
#define CoreTelephony_h

#include <CoreFoundation/CoreFoundation.h>


struct CTResult
{
    int flag;
    int a;
    
};

extern CFStringRef const kCTCellMonitorCellType;
extern CFStringRef const kCTCellMonitorCellTypeServing;
extern CFStringRef const kCTCellMonitorCellTypeNeighbor;
extern CFStringRef const kCTCellMonitorCellId;
extern CFStringRef const kCTCellMonitorLAC;
extern CFStringRef const kCTCellMonitorMCC;
extern CFStringRef const kCTCellMonitorMNC;
extern CFStringRef const kCTCellMonitorUpdateNotification;

id _CTServerConnectionCreate(CFAllocatorRef, void*, int*);
void _CTServerConnectionAddToRunLoop(id, CFRunLoopRef, CFStringRef);

#ifdef __LP64__

void _CTServerConnectionRegisterForNotification(id, CFStringRef);
void _CTServerConnectionCellMonitorStart(id);
void _CTServerConnectionCellMonitorStop(id);
void _CTServerConnectionCellMonitorCopyCellInfo(id, void*, CFArrayRef*);

#else

void _CTServerConnectionRegisterForNotification(struct CTResult*, id, CFStringRef);
#define _CTServerConnectionRegisterForNotification(connection, notification) { struct CTResult res; _CTServerConnectionRegisterForNotification(&res, connection, notification); }

void _CTServerConnectionCellMonitorStart(struct CTResult*, id);
#define _CTServerConnectionCellMonitorStart(connection) { struct CTResult res; _CTServerConnectionCellMonitorStart(&res, connection); }

void _CTServerConnectionCellMonitorStop(struct CTResult*, id);
#define _CTServerConnectionCellMonitorStop(connection) { struct CTResult res; _CTServerConnectionCellMonitorStop(&res, connection); }

void _CTServerConnectionCellMonitorCopyCellInfo(struct CTResult*, id, void*, CFArrayRef*);
#define _CTServerConnectionCellMonitorCopyCellInfo(connection, tmp, cells) { struct CTResult res; _CTServerConnectionCellMonitorCopyCellInfo(&res, connection, tmp, cells); }

#endif


int CellMonitorCallback(id connection, CFStringRef string, CFDictionaryRef dictionary, void *data)
{
    int tmp = 0;
    CFArrayRef cells = NULL;
    _CTServerConnectionCellMonitorCopyCellInfo(connection, (void*)&tmp, &cells);
    if (cells == NULL)
    {
        return 0;
    }
    
    for (NSDictionary* cell in (__bridge NSArray*)cells)
    {
        int LAC, CID, MCC, MNC;
        
        if ([cell[(NSString*)kCTCellMonitorCellType] isEqualToString:(NSString*)kCTCellMonitorCellTypeServing])
        {
            LAC = [cell[(NSString*)kCTCellMonitorLAC] intValue];
            CID = [cell[(NSString*)kCTCellMonitorCellId] intValue];
            MCC = [cell[(NSString*)kCTCellMonitorMCC] intValue];
            MNC = [cell[(NSString*)kCTCellMonitorMNC] intValue];
            
//            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:cell[(NSString*)kCTCellMonitorLAC],@"LAC",cell[(NSString*)kCTCellMonitorCellId],@"CID", nil];
            if (cell[(NSString*)kCTCellMonitorLAC] && cell[(NSString*)kCTCellMonitorCellId]) {
                NSDictionary *dict = @{@"LAC":[NSString stringWithFormat:@"%d",LAC],@"CID":[NSString stringWithFormat:@"%d",CID]};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CellIDandLAC" object:dict];
//                NSLog(@"000000000000000.....%d",CID);
//                NSLog(@".....lllllac....%d",LAC);
            }
        }
        else if ([cell[(NSString*)kCTCellMonitorCellType] isEqualToString:(NSString*)kCTCellMonitorCellTypeNeighbor])
        {
        }
    }
    
    CFRelease(cells);
    
    return 0;
}


#endif /* CoreTelephony_h */
