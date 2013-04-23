//
//  ArielViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ArielViewController.h"
#import "MapImage.h"

@interface ArielViewController ()

@property (weak, nonatomic) IBOutlet UILabel *distanceNumber;
@property (weak, nonatomic) IBOutlet UILabel *distanceUnit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property NSMutableArray *markers;

@end

static const int width = 320;
static const int height = 287;

@implementation ArielViewController

- (void)updateImage
{
    double latitude = self.hole.center.latitude;
    double longitude = self.hole.center.longitude;
    int zoom = (int)self.hole.zoom;
    NSArray *mapMarkers = [self.markers copy];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *image = [[MapImage shared] mapImage:latitude longitude:longitude zoom:zoom width:width height:height mapMarkers:mapMarkers];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGPoint point = CGPointMake(image.size.width / 2, image.size.height / 2);
            
            point.x -= self.scrollView.bounds.size.width / 2;
            point.y -= self.scrollView.bounds.size.height / 2;
            
            CGFloat max = image.size.width / self.scrollView.bounds.size.width;
            
            max = MIN(max, image.size.height / self.scrollView.bounds.size.height);
            
            self.imageView.contentMode = UIViewContentModeCenter;
            self.imageView.frame = (CGRect) { { 0, 0 }, image.size };
            self.imageView.image = image;
            self.scrollView.contentSize = image.size;
            self.scrollView.contentOffset = point;
            self.scrollView.minimumZoomScale = 1.0f;
            self.scrollView.maximumZoomScale = max;
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.markers = [@[] mutableCopy];
    
    [self updateImage];
}

- (void)addChildViewController:(UIViewController *)childController
{
    // We cast to ArielViewController* to get a correct signature for setHole:
    if([childController respondsToSelector:@selector(setHole:)])
        [(ArielViewController*)childController setHole:self.hole];
    
    [super addChildViewController:childController];
}

struct DblContainer
{
    double a, b;
};

- (struct DblContainer)ToGeographic:(double)mercatorX_lon mercatorY_lat:(double)mercatorY_lat
{
    NSParameterAssert(!(fabs(mercatorX_lon) < 180 && fabs(mercatorY_lat) < 90));
    
    NSParameterAssert(! ((fabs(mercatorX_lon) > 20037508.3427892) || (fabs(mercatorY_lat) > 20037508.3427892)));
    
    double x = mercatorX_lon;
    double y = mercatorY_lat;
    double num3 = x / 6378137.0;
    double num4 = num3 * 57.295779513082323;
    double num5 = floor((double)((num4 + 180.0) / 360.0));
    double num6 = num4 - (num5 * 360.0);
    double num7 = 1.5707963267948966 - (2.0 * atan(exp((-1.0 * y) / 6378137.0)));
    mercatorX_lon = num6;
    mercatorY_lat = num7 * 57.295779513082323;
    
    return (struct DblContainer){ mercatorX_lon, mercatorY_lat };
}

- (struct DblContainer)ToWebMercator:(double)mercatorX_lon mercatorY_lat:(double)mercatorY_lat
{
    NSParameterAssert(!((fabs(mercatorX_lon) > 180 || fabs(mercatorY_lat) > 90)));
    
    double num = mercatorX_lon * 0.017453292519943295;
    double x = 6378137.0 * num;
    double a = mercatorY_lat * 0.017453292519943295;
    
    mercatorX_lon = x;
    mercatorY_lat = 3189068.5 * log((1.0 + sin(a)) / (1.0 - sin(a)));
    
    return (struct DblContainer){ mercatorX_lon, mercatorY_lat };
}

- (IBAction)longTap:(UILongPressGestureRecognizer*)recognizer
{
    if(recognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint p = [recognizer locationInView:self.imageView];
    
    double xdiff = p.x - self.imageView.frame.size.width / 2;
    double ydiff = self.imageView.frame.size.height / 2 - p.y;
    
    double worldCoordXDiff = xdiff / pow(2, self.hole.zoom);
    double worldCoordYDiff = ydiff / pow(2, self.hole.zoom);
    
    struct DblContainer tmp;
    
    tmp = [self ToWebMercator:self.hole.center.longitude mercatorY_lat:self.hole.center.latitude];
    
    tmp.a += worldCoordXDiff * 78000;
    tmp.b += worldCoordYDiff * 78000;
    
    tmp = [self ToGeographic:tmp.a mercatorY_lat:tmp.b];
    
    MapMarker *marker = [MapMarker new];
    
    marker.color = @"blue";
    marker.label = @"G";
    marker.longitude = tmp.a;
    marker.latitude = tmp.b;
    
    [self.markers addObject:marker];
    
    [self updateImage];
}

@end
