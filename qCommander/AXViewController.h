//
//  AXViewController.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 7/11/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface AXViewController : UIViewController

@property (strong) Firebase * firebase;
- (IBAction)cmdNext:(id)sender;

- (IBAction)cmdPrev:(id)sender;
@end
