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
            , lockControl;

@synthesize slide
            , slideTitle
            , screenshot;

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
    self.lockControl = !(self.lockControl);
}

- (IBAction)cmdPrevious:(id)sender
{
    !self.lockControl && [slide previous];
}
- (IBAction)cmdNext:(id)sender
{
    !self.lockControl && [slide next];
}

@end
