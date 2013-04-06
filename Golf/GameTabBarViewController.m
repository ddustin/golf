//
//  GameTabBarViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "GameTabBarViewController.h"
#import "Location.h"

@interface GameTabBarViewController ()

@end

@implementation GameTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Request GPS access
    [Location shared];
    
    for(id val in self.viewControllers)
        if([val respondsToSelector:@selector(setHole:)])
            [val setHole:self.hole];
}

@end
