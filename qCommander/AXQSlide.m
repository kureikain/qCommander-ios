//
//  AXQSlider.m
//  qCommander
//
//  Created by Hoa Diem Nguyet on 12/20/13.
//  Copyright (c) 2013 Hoa Diem Nguyet. All rights reserved.
//

#import "AXQSlide.h"

@interface AXQSlide ()

@end

@implementation AXQSlide

@synthesize url, token;

- (BOOL) getConnectionStatus
{
    return TRUE;
}

- (BOOL) connect
{
    return TRUE;
}

- (BOOL) jump:(int) number
{
    return TRUE;
}

- (BOOL) next
{
    return TRUE;
}

- (BOOL) previous
{
    Firebase* nameRef = [[Firebase alloc] initWithUrl:@"https://SampleChat.firebaseIO-demo.com/users/fred/name"];

    [nameRef setValue:@{@"first": @"Fred", @"last": @"Swanson"}];
    return TRUE;
}

- (BOOL) begin
{
    return TRUE;
}

- (BOOL) end
{
    return TRUE;
}

- (NSString *) dataKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@%@", BACKEND_DATA_HOST, key];
}

+ (AXQSlide *) initWithUrl:(NSString *) url andCode:(NSString *) code
{
    AXQSlide * instance = [AXQSlide init];
//    instance.
    return instance;
}

+ (AXQSlide *) initWithToken:(NSString *) code
{
    AXQSlide * instance = [AXQSlide init];
    [instance setToken:code];
    return instance;
}
@end
