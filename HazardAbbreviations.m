//
//  HazardAbbreviations.m
//  Golf
//
//  Created by Dustin Dettmer on 4/6/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "HazardAbbreviations.h"
#import "Database.h"

@implementation HazardAbbreviations

+ (NSArray*)shared
{
    static NSArray *hazards = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hazards = [Database query:@"SELECT * FROM HazardAbbreviations" classType:self.class];
    });
    
    return hazards;
}

+ (HazardAbbreviations*)hazardForAbbr:(NSString *)HazardAbbr
{
    for(HazardAbbreviations *object in [self shared])
        if([object.HazardAbbr isEqual:HazardAbbr])
            return object;
    
    return nil;
}

@end
