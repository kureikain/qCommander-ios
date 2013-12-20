//
//  AXRemoteController.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/15/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum slide slide;
//

@interface AXRemoteController : UIViewController


@property (nonatomic, strong) IBOutlet UILabel *accessCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *connectivityIndicator;
@property (nonatomic, strong) NSString *accessCode;

@property (nonatomic, strong) NSNumber *currentSlide;
//@property (nonatomic, strong) NSNumber *currentSlide;

@end
