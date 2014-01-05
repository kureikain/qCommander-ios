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
{
    BOOL  _scanningCode;
}
@end

@implementation AXViewController

@synthesize firebase, reader;
@synthesize accessCodeField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpEventHandler];
    [self bootstrapFirebase];
    [self setUpZbar];
	// Do any additional setup after loading the view, typically from a nib.

    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    [self setTitle:@"QSlider"];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:168/255.0f alpha:0.9f];
        self.navigationController.navigationBar.translucent = NO;
//        self.navigationController.navigationController.
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:126 blue:186 alpha:0.9];
    }
}

- (void) setUpEventHandler
{
    [self.accessCodeField setDelegate:self];
    [self.accessCodeField setKeyboardType:UIKeyboardTypeNamePhonePad];
}

- (void) setUpZbar
{
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
    reader.readerView.zoom = 1.0;
//    reader.readerView s

//    if ([ZBarReaderController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    reader.sourceType = UIImagePickerControllerSourceTypeCamera;
//    [reader.scanner setSymbology: ZBAR_I25
//                          config: ZBAR_CFG_ENABLE
//                              to: 0];
    
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
    _scanningCode = FALSE;
    [self presentViewController:reader animated:YES completion:^() {
        _scanningCode = TRUE;
    }];
}


- (void) foundAccesCode: (NSString*) accessCode withURL:(NSString *) url{
    NSLog(@"Process: %@", accessCode);
    [accessCodeField setText:accessCode];
}

# pragma protocol ZBarSDK
- (void) imagePickerController: (UIImagePickerController*)scanner didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    if (_scanningCode) {
        return;
    }
    _scanningCode = TRUE;
    [scanner dismissViewControllerAnimated:YES completion:^() {
        NSLog(@"%@",@"Succesfully to find the image");
    }];
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for (symbol in results) {
        @try {
            NSLog(@"Access Code Is: %@", symbol.data);
            NSData *data = [symbol.data dataUsingEncoding:NSUTF8StringEncoding];
            NSError * jsonParsingError;
            NSDictionary *a = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (nil == jsonParsingError) {
                [self foundAccesCode:(NSString *)[a objectForKey:@"token"] withURL:(NSString *)[a objectForKey:@"url"]];
                break; //Get the 1st one
            }

        }
        @catch (NSException *e) {
            NSLog(@"Error: %@", e);
        }
        @finally {
            
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"connectWithAccessCode"]) {
        AXRemoteController *destViewController = segue.destinationViewController;
        [destViewController connectWithAccessCode:self.accessCodeField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
