//
//  AXQSlider.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/20/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#include <stdlib.h>
#import <CommonCrypto/CommonDigest.h>

#define BACKEND_DATA_HOST @"https://qcommander.firebaseio-demo.com/"

//typedef void (^ UpdateScreenshotBlock)(id, int);
typedef void (^ UpdateScreenshotBlock)(NSString *);

@interface AXQSlide : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSNumber *currentSlide;
@property (nonatomic, strong) NSNumber *quantityOfSlide;

/*
 Jump to a specified page
 */
- (BOOL) jump:(int) number;
- (BOOL) next;
- (BOOL) previous;
- (BOOL) begin;
- (BOOL) end;

- (BOOL) getConnectionStatus;
- (BOOL) connect;

/*
 Load screenshot, execute callbac once done
 */
- (BOOL) loadScreenshotWithCallback:(UpdateScreenshotBlock) updateBlock;

/*
 Get firebase back-end data key
 */
- (NSString *) dataKey:(NSString *)key;

- (AXQSlide *) initWithToken:(NSString *) code andUrl:(NSString *) aUrl;
@end
