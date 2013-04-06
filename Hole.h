//
//  Course.h
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Hole : NSObject

@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) NSString *hole;

@property (nonatomic, assign) float zoom;
@property (nonatomic, assign) CLLocationCoordinate2D center;
@property (nonatomic, assign) CLLocationCoordinate2D gleft;
@property (nonatomic, assign) CLLocationCoordinate2D gright;
@property (nonatomic, assign) CLLocationCoordinate2D tleft;
@property (nonatomic, assign) CLLocationCoordinate2D tright;
@property (nonatomic, assign) double angle;

@property (nonatomic, assign) CLLocationCoordinate2D flag;

- (id)initWithCourseData:(NSString*)corseData courseId:(NSString*)courseId hole:(NSString*)hole;

- (void)loadExtraIfNeeded;

@end
