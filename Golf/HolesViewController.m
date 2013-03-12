//
//  LayupViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "HolesViewController.h"
#import "TouchXML.h"
#import "Hole.h"

@interface HolesViewController ()

@property (nonatomic, strong) NSArray *holes;

@end

@implementation HolesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.course objectForKey:@"CourseName"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Back";
    
    self.navigationItem.backBarButtonItem = barButton;
    
    NSString *courseData = [self.course objectForKey:@"CourseData"];
    
    CXMLDocument *document = [[CXMLDocument alloc] initWithXMLString:courseData options:0 error:nil];
    
    CXMLNode *node = [document nodeForXPath:@"//*[local-name() = 'GetCourseKMLResult']" error:nil];
    
    NSString *xmlString = [node stringValue];
    
    xmlString = [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    
    document = [[CXMLDocument alloc]
                initWithXMLString:xmlString
                options:0
                error:nil];
    
    NSMutableArray *array = [@[] mutableCopy];
    
    for(CXMLElement *element in [[document nodeForXPath:@"//*[local-name() = 'HoleBounds']" error:nil] children]) {
        
        NSString *hole = [[element.children objectAtIndex:0] stringValue];
        
        [array addObject:[[Hole alloc] initWithCourseData:courseData hole:hole]];
    }
    
    self.holes = array;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.holes.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Hole %@", [[self.holes objectAtIndex:indexPath.row] hole]];
    
    return cell;
}

@end
