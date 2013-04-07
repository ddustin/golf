//
//  PlacemarksViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 4/5/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "PlacemarksViewController.h"
#import "Placemark.h"
#import "Location.h"

@interface PlacemarksViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerContainer;

@property NSArray *placemarks;

@end

@implementation PlacemarksViewController

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
    
    self.placemarks = [Placemark placemarksCourseId:self.hole.courseId.integerValue hole:self.hole.hole.integerValue];
}

- (void)locationUpdated
{
    [self.tableView reloadData];
}

- (void)addChildViewController:(UIViewController *)childController
{
    // We cast to PlacemarksViewController* to get a correct signature for setHole:
    if([childController respondsToSelector:@selector(setHole:)])
        [(PlacemarksViewController*)childController setHole:self.hole];
    
    [super addChildViewController:childController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placemarks.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerContainer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerContainer.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Placemark *placemark = [self.placemarks objectAtIndex:indexPath.row];
    
    double distance = [[Location shared] metersOrYardsFrom:placemark.PlaceMarkLat.doubleValue
                                                 longitude:placemark.PlaceMarkLon.doubleValue];
    
    cell.textLabel.text = placemark.hazard.HazardLongName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f", distance];
    
    return cell;
}

- (void)viewDidUnload {
    [self setHeaderContainer:nil];
    [super viewDidUnload];
}
@end
