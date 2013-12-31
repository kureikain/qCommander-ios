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
  
    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/f9e54behd4ndrza/empty_sound.mp3?dl=1&token_hash=aAAGKYWFuGt9FsddDMysEmLpAmLxSlNmTHg9MBQkmv-xEca"]];
    
    [audioPlayer setShouldAutoplay:NO];
    [audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    audioPlayer.view.hidden = YES;
    [audioPlayer setRepeatMode:MPMovieRepeatModeOne];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
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
    [self.accessCodeLabel setText:code];
    slide = [[AXQSlide alloc] initWithToken:code andUrl:@"" whenCompletion:^(NSDictionary * slideInfo) {
        NSLog(@"Data change");
        [slideTitle setText:slideInfo[@"title"]];
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
                    if (nil != slideInfo[@"title"])
                    {
                        [songInfo setObject:slideInfo[@"author"] forKey:MPMediaItemPropertyArtist];
                    }
                    if (nil != slideInfo[@"title"])
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
        
    }];
    
    [self refreshScreenshot];
}

- (void) refreshScreenshot
{
    [slide loadScreenshotWithCallback: ^(NSString *url ) {
        WTURLImageViewPreset *p = [[WTURLImageViewPreset alloc] init];
//        p.options.WTURLImageViewOptionShowActivityIndicator = 1;
        p.options = WTURLImageViewOptionShowActivityIndicator;
        [screenshot setURL:[NSURL URLWithString:url] withPreset:p];
    }];
    
}

- (IBAction)toggleControlLock:(id)sender {
    self.lockControl = !self.lockControl;
}

- (IBAction)cmdPrevious:(id)sender
{
    (!self.lockControl) && [slide previous];
}

- (IBAction)cmdNext:(id)sender
{
    (!self.lockControl) && [slide next];
}

@end
