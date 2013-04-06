//
//  ArielViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ArielViewController.h"

@interface ArielViewController ()

@property (weak, nonatomic) IBOutlet UILabel *distanceNumber;
@property (weak, nonatomic) IBOutlet UILabel *distanceUnit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ArielViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *fmt = @"http://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=%.0f&size=%dx%d&maptype=satellite&sensor=false&scale=2";
    
    int width = 320;
    int height = 287;
    
    NSString *str = [NSString stringWithFormat:fmt, self.hole.center.latitude,
                     self.hole.center.longitude, self.hole.zoom, width, height];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
        
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
    }];
}

- (void)addChildViewController:(UIViewController *)childController
{
    // We cast to ArielViewController* to get a correct signature for setHole:
    if([childController respondsToSelector:@selector(setHole:)])
        [(ArielViewController*)childController setHole:self.hole];
    
    [super addChildViewController:childController];
}

@end
