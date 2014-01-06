//
//  AXRemoteController.m
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/15/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import "AXRemoteController.h"

@interface AXRemoteController ()

@end

@implementation AXRemoteController

@synthesize connectivityIndicator
            , accessCodeLabel
            , lockControl
            ,nowPlayingCenter

            ,slide
            , slideTitle
            , screenshot
            , browserConnectStatus
            , slideJumper
            , currentSlideNumberIndicator

,audioPlayer
;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.lockControl = FALSE;
    
    [[AVAudioSession sharedInstance] setDelegate: self];
    NSError *myErr;
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    //initialize our audio player
//    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.cocoanetics.com/files/Cocoanetics_031.mp3"]];
  
    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/ap84sy8h47r48ra/empty.wav?dl=1&token_hash=AAGkuxjDHGK-MUefkdmSAhlUj0NLLtX1gE7cLXnLeKkOyw"]];
    
    [audioPlayer setShouldAutoplay:NO];
    [audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    audioPlayer.view.hidden = YES;
    [audioPlayer setRepeatMode:MPMovieRepeatModeOne];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    
    //UI setup and style for the app
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:40/255.0f green:209/255.0f blue:119/255.0f alpha:1.0f];
    
    //Remove the title of back button. only chevron icon.
    self.navigationController.navigationBar.topItem.title = @" ";
    
    [slideJumper setContinuous:NO];
    [self setTitle:[NSString stringWithFormat:@"Connected: %@", slide.token]];
    
//    currentSlideNumberIndicator.layer.borderColor = [UIColor colorWithRed:245/255.f green:111/255.0f blue:108/255.0f alpha:1.0f].CGColor;
//    currentSlideNumberIndicator.layer.borderWidth = 1.0;
//    CALayer *imageLayer = currentSlideNumberIndicator.layer;
//    [imageLayer setCornerRadius:round(currentSlideNumberIndicator.frame.size.width/2)];
//    [imageLayer setBorderWidth:2];
//    [imageLayer setMasksToBounds:YES];
    currentSlideNumberIndicator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slide_pop"]];
    // End UI Setup
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
Allow this receiving remote event from lock screen
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            NSLog(@"4");
            break;
        case UIEventSubtypeRemoteControlPlay:
            break;
        case UIEventSubtypeRemoteControlPause:
            NSLog(@"3");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"Press next button on lock screen");
            [slide next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            NSLog(@"Press previous button on lock screen");
            [slide previous];
            break;
        default:
            break;
    }
}

- (void) connectWithAccessCode:(NSString *) code
{
    slide = [[AXQSlide alloc] initWithToken:code andUrl:@"" whenCompletion:^(NSDictionary * slideInfo) {
        NSLog(@"Data change");
        
        if ([slideInfo objectForKey:@"connection" ] != nil) {
            if (self.browserConnectStatus == offline) {
                self.browserConnectStatus = online;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.connectivityIndicator setBackgroundColor:[UIColor colorWithRed:81/255.0f green:192/255.0f blue:212/255.0f alpha:0.9f]];
                    [self.connectivityIndicator setText:@"Connected"];
                    
                    //Let user know
                    UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"Browser connection is restored." message:@"Great, you can continue to control slide now." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [a show];
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.accessCodeLabel setText:[NSString stringWithFormat:@"Token: %@", code]];
            
            [slideTitle setText:slideInfo[@"title"]];
            [slideJumper setMaximumValue:[(NSString* )slideInfo[@"quantity"] floatValue]];
            [slideJumper setValue:[(NSString* )slideInfo[@"currentSlideNumber"] floatValue]];
            [self setTitle:[NSString stringWithFormat:@"%.0f/%@\n ", round(self.slideJumper.value), slide.quantityOfSlide]];            
        });
        
        WTURLImageViewPreset *p = [[WTURLImageViewPreset alloc] init];
        //        p.options.WTURLImageViewOptionShowActivityIndicator = 1;
        p.options = WTURLImageViewOptionShowActivityIndicator;
        [screenshot setURL:[NSURL URLWithString:(NSString *)slideInfo[@"currentSlideUrl"]] withPreset:p];
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        
        if (playingInfoCenter) {
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            
            NSURL *imageURL = [NSURL URLWithString:(NSString *)slideInfo[@"currentSlideUrl"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                if (imageData == nil) {
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageWithData:imageData]];
                    
                    if (nil != slideInfo[@"title"])
                    {
                        [songInfo setObject:slideInfo[@"title"] forKey:MPMediaItemPropertyTitle];
                    }
                    if (nil != slideInfo[@"author"])
                    {
                        [songInfo setObject:slideInfo[@"author"] forKey:MPMediaItemPropertyArtist];
                    }
                    if (nil != slideInfo[@"provider"])
                    {
                        [songInfo setObject:slideInfo[@"provider"] forKey:MPMediaItemPropertyAlbumTitle];
                    }
                    if (nil != slideInfo[@"title"])
                    {
                        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                    }
                   
                    @try {
                        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
                    }
                    @catch (NSException *e) {
                        
                    }
                    
                });
            });
        }
        
    } whenDisconnect: ^ BOOL(NSDictionary * s) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"Browser disconnected. Check browser and bookmarklet" message:@"You cannot control until connection is restored." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
            [a show];
            browserConnectStatus = offline;
            
            [self.connectivityIndicator setBackgroundColor:[UIColor colorWithRed:245/255.0f green:111/255.0f blue:108/255.0f alpha:0.9f]];
            [self.connectivityIndicator setText:@"Disconnected"];
        });
        return false;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //
    }
}

- (IBAction)toggleControlLock:(id)sender {
    self.lockControl = !self.lockControl;
}

- (IBAction)cmdPrevious:(id)sender
{
    (!self.lockControl && browserConnectStatus == online) && [slide previous];
}

- (IBAction)cmdNext:(id)sender
{
    (!self.lockControl && browserConnectStatus == online) && [slide next];
}

- (IBAction)cmdFirst:(id)sender {
    (!self.lockControl && browserConnectStatus == online) && [slide first];
}

- (IBAction)cmdLast:(id)sender {
    (!self.lockControl && browserConnectStatus == online) && [slide last];
}

- (IBAction)slideMove:(id)sender {
    (!self.lockControl && browserConnectStatus == online) && [slide jump:[NSNumber numberWithInt:round(self.slideJumper.value)]];
    
    int pos = round(320/self.slideJumper.maximumValue * self.slideJumper.value);
    [currentSlideNumberIndicator setText:[NSString stringWithFormat:@"%.0f/%@\n ", round(self.slideJumper.value), slide.quantityOfSlide]];
    
    [currentSlideNumberIndicator setCenter:CGPointMake(pos, currentSlideNumberIndicator.center.y)];
    
}

@end
