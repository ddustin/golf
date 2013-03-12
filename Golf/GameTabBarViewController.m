//
//  GameTabBarViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "GameTabBarViewController.h"

@interface GameTabBarViewController ()

@end

@implementation GameTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for(id val in self.viewControllers)
        if([val respondsToSelector:@selector(setHole:)])
            [val setHole:self.hole];
}

@end
