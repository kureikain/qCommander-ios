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
#import <WTURLImageView/WTURLImageView.h>

//typedef enum slide slide;
//

@interface AXRemoteController : UIViewController


@property (nonatomic, strong) IBOutlet UILabel *accessCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *connectivityIndicator;

@property (nonatomic) BOOL lockControl;

@property (nonatomic, strong) AXControl *remoteControl;
@property (nonatomic, strong) AXQSlide *slide;

@property (weak, nonatomic) IBOutlet WTURLImageView *screenshot;

@property (strong, nonatomic) IBOutlet UILabel *slideTitle;


/*
 Initiate connection to this slideshow
 */
- (void) connectWithAccessCode:(NSString *) code;

/*
 Update current screenshot to phone
 */
- (void) refreshScreenshot;

/*
 Action button
 */

/*
 Lock to avoid accident move slide
 */
- (IBAction)toggleControlLock:(id)sender;

- (IBAction)cmdPrevious:(id)sender;
- (IBAction)cmdNext:(id)sender;
@end
