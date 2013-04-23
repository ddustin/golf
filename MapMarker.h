//
//  MapMarker.h
//  Golf
//
//  Created by Dustin Dettmer on 4/8/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapMarker : NSObject

@property NSString *color;
@property NSString *label;
@property (assign) double latitude;
@property (assign) double longitude;

@end
