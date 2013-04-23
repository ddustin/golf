//
//  MapImage.h
//  Golf
//
//  Created by Dustin Dettmer on 4/8/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapMarker.h"

@interface MapImage : NSObject

+ (MapImage*)shared;

- (UIImage*)mapImage:(double)latitude longitude:(double)longitude zoom:(int)zoom width:(int)width height:(int)height mapMarkers:(NSArray*)mapMarkers;

@end
