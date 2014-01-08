//
//  HelpPageViewController.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/16/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
