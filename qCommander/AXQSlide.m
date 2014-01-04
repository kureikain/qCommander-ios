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

- (BOOL) loadScreenshotWithCallback:(UpdateScreenshotBlock) updateBlock;
{
    Firebase* currentSlideRef = [[Firebase alloc] initWithUrl: [self dataKey:@"info/currentSlideUrl"]];
    
    [currentSlideRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value == [NSNull null]) {
            NSLog(@"Not data yet");
        } else {
            NSLog(@"Screenshot URL %@", (NSString *)snapshot.value);
            @try {
                updateBlock((NSString *)snapshot.value);
            }
            @catch (NSException* e) {
                NSLog(@"Warning: Cannot load Screenshot");
            }
//            NSString* firstName = snapshot.value[@"name"][@"first"];
//            NSString* lastName = snapshot.value[@"name"][@"last"];
//            NSLog(@"User julie's full name is: %@ %@", firstName, lastName);
        }
    }];
    return TRUE;
}

- (BOOL) jump:(int) number
{
    Firebase* nameRef = [[Firebase alloc] initWithUrl:[self genCmdUri]];
    [nameRef setValue:@{@"cmd": @"jump", @"number": @"1"}];
    return TRUE;
}

- (BOOL) next
{
    Firebase* nameRef = [[Firebase alloc] initWithUrl:[self genCmdUri]];
    [nameRef setValue:@{@"cmd": @"next"}];
    return TRUE;
}


- (BOOL) previous
{
    Firebase* nameRef = [[Firebase alloc] initWithUrl:[self genCmdUri]];
    [nameRef setValue:@{@"cmd": @"previous"}];
    return TRUE;
}

- (BOOL) first
{
    Firebase* nameRef = [[Firebase alloc] initWithUrl:[self genCmdUri]];
    [nameRef setValue:@{@"cmd": @"first"}];
    return TRUE;
}

- (BOOL) last
{
    Firebase* nameRef = [[Firebase alloc] initWithUrl:[self genCmdUri]];
    [nameRef setValue:@{@"cmd": @"last"}];
    return TRUE;
}

/*
 Generate key name for a command(dataset)
 */
- (NSString *) genCmdUri
{
    int a = arc4random_uniform(9000000);
    const char *cStr = [[NSString stringWithFormat:@"%d", a] UTF8String];//[self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    
    NSString *hash;
    hash = [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
    return [self dataKey:[NSString stringWithFormat:@"qc/%@",hash]];
}

/*
 Generate firbase url for a data set
 - key is whatever follow firebaseurl/<token>/<what-ever-after>
 */
- (NSString *) dataKey:(NSString *)key
{
    //firebase_host/token/qc/name
    return [NSString stringWithFormat:@"%@%@/%@", BACKEND_DATA_HOST, self.token, key];
}

- (AXQSlide *) initWithToken:(NSString *) code andUrl:(NSString *) aUrl
{
    self = [super init];
    [self setToken:code];
    [self setUrl:aUrl];
    [self handshake];
    return self;
}

- (BOOL) handshake
{
    Firebase* nameRef = [[Firebase alloc] initWithUrl:[self genCmdUri]];
    UIDevice * d = [UIDevice currentDevice];
    [nameRef setValue:@{@"cmd": @"handshake", @"from": [[d identifierForVendor] UUIDString], @"name":[d name]}];
    return TRUE;
}

- (BOOL) finishWithBlock:(FinishLoadSlide) completionBlock
{
    Firebase* slideRef = [[Firebase alloc] initWithUrl: [self dataKey:@"info"]];
    [slideRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value == [NSNull null]) {
            NSLog(@"Not data yet");
        } else {
            NSLog(@"Screenshot URL %@", (NSString *)snapshot.value);
            @try {
                completionBlock((NSDictionary *)snapshot.value);
            }
            @catch (NSException* e) {
                NSLog(@"Warning: Cannot load Screenshot");
            }
            //            NSString* firstName = snapshot.value[@"name"][@"first"];
            //            NSString* lastName = snapshot.value[@"name"][@"last"];
            //            NSLog(@"User julie's full name is: %@ %@", firstName, lastName);
        }
    }];
    return TRUE;
}

- (AXQSlide *) initWithToken:(NSString *) code andUrl:(NSString *) aUrl whenCompletion:(FinishLoadSlide) completionBlock
{
    self = [self initWithToken:code andUrl:@""];
    if (self == nil) {
        
    }
    [self finishWithBlock:completionBlock];
    return self;
}

- (AXQSlide * ) runWhenDisconnect:(BOOL()) block
{
    block();
    return self;
}

@end
