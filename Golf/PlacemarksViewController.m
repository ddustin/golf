//
//  PlacemarksViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 4/5/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "PlacemarksViewController.h"
#import "Placemark.h"

@interface PlacemarksViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerContainer;

@property NSArray *placemarks;

@end

@implementation PlacemarksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.placemarks = [Placemark placemarksCourseId:self.hole.courseId.integerValue hole:self.hole.hole.integerValue];
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
    
    cell.textLabel.text = placemark.hazard.HazardLongName;
    cell.detailTextLabel.text = @"200";
    
    return cell;
}

- (void)viewDidUnload {
    [self setHeaderContainer:nil];
    [super viewDidUnload];
}
@end
