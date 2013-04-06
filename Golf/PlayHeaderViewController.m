//
//  PlayHeaderViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 4/6/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "PlayHeaderViewController.h"
#import "Location.h"
#import "Database.h"

@interface PlayHeaderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UILabel *holeLabel;

@end

@implementation PlayHeaderViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated) name:LocationUpdatedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[Location shared] usesMetricSystem])
        self.unit.text = @"meters";
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    self.holeLabel.text = self.hole.hole;
    
    [self locationUpdated];
}

- (void)locationUpdated
{
    [self.hole loadExtraIfNeeded];
    
    if(![[Location shared] location]) {
        
        self.distance.text = @"";
        return;
    }
    
    double amount = [[Location shared] metersOrYardsFrom:self.hole.flag.latitude longitude:self.hole.flag.longitude];
    
    self.distance.text = [NSString stringWithFormat:@"%.0f", amount];
}

- (void)viewDidUnload {
    [self setDistance:nil];
    [self setUnit:nil];
    [self setHoleLabel:nil];
    [super viewDidUnload];
}

@end
