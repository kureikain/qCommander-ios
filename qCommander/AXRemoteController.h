//
//  AXRemoteController.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/15/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AXQSlide.h"
#import "AXControl.h"

//typedef enum slide slide;
//

@interface AXRemoteController : UIViewController


@property (nonatomic, strong) IBOutlet UILabel *accessCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *connectivityIndicator;


@property (nonatomic, strong) AXControl *remoteControl;
@property (nonatomic, strong) AXQSlide *slide;

/*
 Initiate connection to this slideshow
 */
- (void) connectWithAccessCode:(NSString *) code;

/*
 Action button
 */
- (IBAction)cmdPrevious:(id)sender;
- (IBAction)cmdNext:(id)sender;
@end
