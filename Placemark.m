//
//  Placemark.m
//  Golf
//
//  Created by Dustin Dettmer on 4/5/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Placemark.h"
#import "Database.h"
#import <sqlite3.h>

@implementation Placemark

+ (NSArray*)placemarksCourseId:(int)courseId hole:(int)hole
{
    NSMutableString *query = [NSMutableString string];
    
    [query appendString:@"SELECT PlaceMarkID, PlaceMarkName, PlaceMarkLat, PlaceMarkLon, PlaceMarkDistance, Visible FROM PlaceMarks"];
    
    [query appendFormat:@" WHERE CourseID=%d AND HoleNum=%d", courseId, hole];
    
    return [Database query:query classType:self.class];
}

- (HazardAbbreviations*)hazard
{
    return [HazardAbbreviations hazardForAbbr:self.PlaceMarkName];
}

- (NSString*)description
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendFormat:@"placemarkId: %@ ", self.PlaceMarkID];
    [str appendFormat:@"name: %@ ", self.PlaceMarkName];
    [str appendFormat:@"latitude: %@ ", self.PlaceMarkLat];
    [str appendFormat:@"longitude: %@ ", self.PlaceMarkLon];
    [str appendFormat:@"distance: %@ ", self.PlaceMarkDistance];
    [str appendFormat:@"visible: %@ ", self.Visible];
    
    return str;
}

@end
