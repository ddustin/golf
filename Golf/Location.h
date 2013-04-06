//
//  Location.h
//  Golf
//
//  Created by Dustin Dettmer on 4/6/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *LocationUpdatedNotification;

@interface Location : NSObject<CLLocationManagerDelegate>

+ (Location*)shared;

- (CLLocation*)location;

- (BOOL)usesMetricSystem;

// Returns meters or yards depending on NSLocale metric system setting
- (double)metersOrYardsFrom:(double)latitude longitude:(double)longitude;

@end
