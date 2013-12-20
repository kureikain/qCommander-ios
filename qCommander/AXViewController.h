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

@property (strong) Firebase * firebase;
@property (strong) ZBarReaderViewController *reader;

@property (weak, nonatomic) IBOutlet UILabel *tokenLbl;

- (IBAction)cmdNext:(id)sender;

- (IBAction)cmdPrev:(id)sender;
- (IBAction)scanToken:(id)sender;

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info;


/*
 Prepare some data when navigating with segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

/*
 Handle for keyboard
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
