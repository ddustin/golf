//
//  CourseChoiceViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "CourseChoiceViewController.h"
#import "HolesViewController.h"
#import <sqlite3.h>

@interface CourseChoiceViewController ()

@property (nonatomic, strong) NSMutableArray *courses;

@end

@implementation CourseChoiceViewController

static int callback(void *param, int argc, char **argv, char **azColName)
{
    CourseChoiceViewController *self = (__bridge CourseChoiceViewController *)(param);
    
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    
    for(int i= 0; i < argc; i++)
    {
        id value = [NSNull null];
        
        if(argv[i])
            value = [NSString stringWithUTF8String:argv[i]];
        
        [dictionary setObject:value forKey:[NSString stringWithUTF8String:azColName[i]]];
    }
    
    [self.courses addObject:dictionary];
    
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"db" withExtension:@"sqlite"];
    
    sqlite3 *db = NULL;
    char *zErrMsg = 0;
    
    int res = sqlite3_open(url.path.UTF8String, &db);
    
    (void)res;
    NSParameterAssert(res == SQLITE_OK);
    
    NSString *query = @"SELECT * FROM FavoriteCourse";
    
    self.courses = [@[] mutableCopy];
    
    sqlite3_exec(db, query.UTF8String, callback, (__bridge void *)(self), &zErrMsg);
    
    if(zErrMsg)
        NSLog(@"Query error: %s", zErrMsg);
    
    sqlite3_close(db);
    
    NSLog(@"%@", [[self.courses objectAtIndex:0] allKeys]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courses.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *course = [self.courses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [course objectForKey:@"CourseName"];
    cell.detailTextLabel.text = [course objectForKey:@"City"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:HolesViewController.class]) {
        
        HolesViewController *controller = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        controller.course = [self.courses objectAtIndex:indexPath.row];
    }
}

@end
