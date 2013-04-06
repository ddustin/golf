//
//  HazardAbbreviations.h
//  Golf
//
//  Created by Dustin Dettmer on 4/6/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HazardAbbreviations : NSObject

@property NSString *HazardAbbr;
@property NSString *HazardShortName;
@property NSString *HazardLongName;
@property NSString *IconFileName;

+ (NSArray*)shared;

+ (HazardAbbreviations*)hazardForAbbr:(NSString*)HazardAbbr;

@end
