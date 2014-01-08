//
//  AXHelpViewController.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 1/7/14.
//  Copyright (c) 2014 Hoa Diem Nguyet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXHelpViewController.h"
#import "HelpPageViewController.h"

@interface AXHelpViewController : UIPageViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
