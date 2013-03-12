//
//  GameTabBarViewController.h
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hole;

@interface GameTabBarViewController : UITabBarController

@property (nonatomic, strong) Hole *hole;

@end
