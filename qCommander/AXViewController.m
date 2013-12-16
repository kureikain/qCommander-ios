//
//  AXViewController.m
//  qCommander
//
//  Created by Hoa Diem Nguyet on 7/11/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import "AXViewController.h"

#import <CommonCrypto/CommonHMAC.h>

@interface AXViewController ()

@end

@implementation AXViewController

@synthesize firebase, reader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self bootstrapFirebase];
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [reader.scanner setSymbology:ZBAR_QRCODE
                          config:ZBAR_CFG_ENABLE
                              to:0];
    reader.readerView.zoom = 1.0;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 get a random string 
 */
- (NSString *) _rndString
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < 20; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

/*
 sha 256 a string
 */
-(NSString*) _sha256:(NSString *)clear{
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    NSLog(@"%@",hash);
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

/**
 * Generate a randome key for firebase token
 */
-(NSString *) _firetoken
{
    return [self _sha256:[self _rndString]];
}

/**
 Create a firebase URI location for command
 */
-(Firebase *) _fireFile
{
    // Create a reference to a Firebase location
    NSString * url = [@"https://qcommander.firebaseIO-demo.com/command_queues/" stringByAppendingFormat:@"%@", [self _firetoken]];
    return firebase = [[Firebase alloc] initWithUrl:url];
}

/**
 Push a command to firebase
 */
-(void) pushCommand:(NSDictionary *)d
{
    Firebase * f = [self _fireFile];
    
    [f setValue:d];
    
    // Read data and react to changes
    [f observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@ -> %@", snapshot.name, snapshot.value);
    }];
}

/*
 Test firebase conf
 */
- (void) bootstrapFirebase
{
    // Write data to Firebase
    NSUInteger interval = [[NSDate date] timeIntervalSince1970];
    NSString * s = [NSString stringWithFormat:@"%d", interval];
    NSDictionary *d = @{@"cmd": @"next", @"t":s};
    [self pushCommand:d];
}

- (IBAction)cmdNext:(id)sender {
    NSUInteger interval = [[NSDate date] timeIntervalSince1970];
    NSString * s = [NSString stringWithFormat:@"%d", interval];
    NSDictionary *d = @{@"cmd": @"next", @"t":s};
    [self pushCommand:d];
}

- (IBAction)cmdPrev:(id)sender {
    NSUInteger interval = [[NSDate date] timeIntervalSince1970];
    NSString * s = [NSString stringWithFormat:@"%d", interval];
    NSDictionary *d = @{@"cmd": @"prev", @"t":s};
    [self pushCommand:d];
}

- (IBAction)scanToken:(id)sender {
    [self presentModalViewController: reader
                            animated: YES];
}

# pragma protocol ZBarSDK
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];

    NSLog(@"%@", results);
    
    
    UIImage *image =    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissModalViewControllerAnimated: YES];
}
@end
