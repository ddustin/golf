//
//  Placemark.h
//  Golf
//
//  Created by Dustin Dettmer on 4/5/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HazardAbbreviations.h"

@interface Placemark : NSObject

@property NSString *PlaceMarkID;
@property NSString *PlaceMarkName;
@property NSNumber *PlaceMarkLat;
@property NSNumber *PlaceMarkLon;
@property NSNumber *PlaceMarkDistance;
@property NSNumber *Visible;

- (HazardAbbreviations*)hazard;

+ (NSArray*)placemarksCourseId:(int)courseId hole:(int)hole;

@end
