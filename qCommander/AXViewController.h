//
//  AXViewController.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 7/11/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "ZBarSDK.h"
#import "MMDrawerController/MMDrawerController.h"
#import "AXRemoteController.h"

@interface AXViewController : UIViewController <ZBarReaderDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *accessCodeField;

// Firebase object
@property (strong) Firebase * firebase;

// Bar Code scanner
@property (strong) ZBarReaderViewController *reader;

@property (weak, nonatomic) IBOutlet UILabel *tokenLbl;

- (IBAction)cmdNext:(id)sender;

- (IBAction)cmdPrev:(id)sender;
- (IBAction)scanToken:(id)sender;

- (void) imagePickerController: (UIImagePickerController*) scanner didFinishPickingMediaWithInfo: (NSDictionary*) info;

/*
 Found access code
 Fill in this value and connect.
 */
- (void) foundAccesCode: (NSString*) accessCode;

/*
 Prepare some data when navigating with segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

/*
 Handle for keyboard
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
