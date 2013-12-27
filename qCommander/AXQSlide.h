//
//  AXQSlider.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/20/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BACKEND_DATA_HOST @"https://qcommander.firebaseio-demo.com/"

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
 Get firebase back-end data key
 */
- (NSString *) dataKey:(NSString *)key;

+ (AXQSlide *) initWithUrl:(NSString *) url andToken:(NSString *) code;
@end
