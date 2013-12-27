//
//  AXQSlider.h
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/20/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import <Foundation/Foundation.h>


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

+ (AXQSlide *) initWithUrl:(NSString *) url andToken:(NSString *) code;
@end
