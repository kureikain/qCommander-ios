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
//
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    nowPlayingCenter = [MPNowPlayingInfoCenter defaultCenter];
//    
//    NSMutableDictionary * slideInfo = [[NSMutableDictionary alloc] init];
//    [slideInfo setObject:@"sas" forKey:MPMediaItemPropertyTitle];
//    [slideInfo setObject:@"NCC" forKey:MPMediaItemPropertyAlbumTitle];
//
//    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"app_icon_960x640"]];
//    [slideInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
//    
////  @{MPMediaItemPropertyTitle: @"test"};
//    [nowPlayingCenter setNowPlayingInfo: slideInfo] ;
    
    
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

    audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.howjsay.com/mp3/you.mp3?1388406111462.52"]];
    
    
    [audioPlayer setShouldAutoplay:NO];
    [audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    audioPlayer.view.hidden = YES;
    [audioPlayer setRepeatMode:MPMovieRepeatModeOne];
    [audioPlayer prepareToPlay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [audioPlayer play];
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"app_icon_960x640.png"]];
        [songInfo setObject:@"Audio Title" forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
//    [audioPlayer pause];
//    (!self.lockControl) && [slide next];
}

@end
