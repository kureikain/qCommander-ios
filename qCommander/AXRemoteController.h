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

#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMoviePlayerController.h>

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>"

typedef enum  {
    online,
    offline
} QSConnectionStatus;

@interface AXRemoteController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) MPMoviePlayerController *audioPlayer;

@property (nonatomic, strong) MPNowPlayingInfoCenter * nowPlayingCenter;

@property (nonatomic, strong) IBOutlet UILabel *accessCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *connectivityIndicator;

@property (nonatomic) BOOL lockControl;

@property (nonatomic, strong) AXControl *remoteControl;
@property (nonatomic, strong) AXQSlide *slide;

@property (weak, nonatomic) IBOutlet WTURLImageView *screenshot;

@property (strong, nonatomic) IBOutlet UILabel *slideTitle;
@property (strong, nonatomic) IBOutlet UISlider *slideJumper;


@property QSConnectionStatus browserConnectStatus;

@property (strong, nonatomic) IBOutlet UILabel *currentSlideNumberIndicator;


/*
 Initiate connection to this slideshow
 */
- (void) connectWithAccessCode:(NSString *) code;

/*
 Action button
 */

/*
 Lock to avoid accident move slide
 */
- (IBAction)toggleControlLock:(id)sender;

- (IBAction)cmdPrevious:(id)sender;
- (IBAction)cmdNext:(id)sender;
- (IBAction)cmdFirst:(id)sender;
- (IBAction)cmdLast:(id)sender;

- (IBAction)slideMove:(id)sender;


@end
