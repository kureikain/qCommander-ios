//
//  UIViewController+BackButton.m
//  Prototype
//
//  Created by Meng To on 4/29/13.
//  Copyright (c) 2013 Meng To. All rights reserved.
//

#import "UIViewController+BackButton.h"

@implementation UIViewController (BackButton)

- (IBAction)backButton:(UIStoryboardSegue *)sender
{
    NSLog(@"Self = %@",self);
    if ([self isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
