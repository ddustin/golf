//
//  MapImage.m
//  Golf
//
//  Created by Dustin Dettmer on 4/8/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "MapImage.h"

@implementation MapImage

+ (MapImage *)shared
{
    static MapImage *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [MapImage new];
    });
    
    return instance;
}

- (UIImage *)mapImage:(double)latitude longitude:(double)longitude zoom:(int)zoom width:(int)width height:(int)height mapMarkers:(NSArray *)mapMarkers
{
    NSString *fmt = @"http://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=%d&size=%dx%d&maptype=satellite&sensor=false&scale=2";
    
    NSString *str = [NSString stringWithFormat:fmt, latitude,
                     longitude, zoom, width, height];
    
    for(MapMarker *mapMarker in mapMarkers) {
        
        str = [str stringByAppendingFormat:@"&markers=color:%@%%7Clabel:%@%%7C%f,%f", mapMarker.color, mapMarker.label, mapMarker.latitude, mapMarker.longitude];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if(error) {
        
        UIAlertView *alert = [UIAlertView new];
        
        alert.title = @"Error";
        alert.message = error.localizedDescription;
        
        [alert addButtonWithTitle:@"Okay"];
        
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        
        return nil;
    }
    
    if(!data)
        return nil;
    
    return [UIImage imageWithData:data];
}

@end
