//
//  Location.m
//  Golf
//
//  Created by Dustin Dettmer on 4/6/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Location.h"

#define METERS_TO_YARDS  1.0936133

NSString *LocationUpdatedNotification = @"LocationUpdatedNotification";

@interface Location()

@property CLLocationManager *locationManager;

@end

@implementation Location

+ (Location *)shared
{
    static Location *location = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        location = [Location new];
    });
    
    return location;
}

- (id)init
{
    self = [super init];
    
    if(self) {
        
        self.locationManager = [CLLocationManager new];
        
        self.locationManager.delegate = self;
        
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdatedNotification object:self];
}

- (CLLocation*)location
{
    return self.locationManager.location;
}

- (BOOL)usesMetricSystem
{
    return [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
}

- (double)metersFrom:(double)latitude longitude:(double)longitude
{
    if(!self.location)
        return INFINITY;
    
    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    return [self.location distanceFromLocation:clLocation];
}

- (double)metersOrYardsFrom:(double)latitude longitude:(double)longitude
{
    // 72 - 66
//    latitude -= 114075884.000090;
//    longitude -= 114075884.000090;
    
    // 72 - 69
//    latitude -= 114075884.00012;
//    longitude -= 114075884.00012;
    
    // 72 - 69
//    latitude -= 114075884.00015;
//    longitude -= 114075884.00015;
    
    // 72 - 70
//    latitude -= 114075884.00017;
//    longitude -= 114075884.00017;
        
    latitude -= 114075884.00023;
    longitude -= 114075884.00023;
    
    double meters = [self metersFrom:latitude longitude:longitude];
    
    if([self usesMetricSystem])
        return meters;
    
    return meters * METERS_TO_YARDS;
}

@end
