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

@synthesize connectivityIndicator, accessCodeLabel;
@synthesize slide;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connectWithAccessCode:(NSString *) code
{
    slide = [[AXQSlide alloc] initWithToken:code andUrl:@""];
    [self.accessCodeLabel setText:code];
}

- (IBAction)cmdPrevious:(id)sender
{
    [slide previous];
}
- (IBAction)cmdNext:(id)sender
{
    [slide next];
}


@end
