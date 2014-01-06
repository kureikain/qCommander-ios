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


//- (void)setTitle:(NSString *)title
//{
////    [super setTitle:title];
//    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
//    if (!titleView) {
//        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
////        titleView.backgroundColor = [UIColor clearColor];
//        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//        titleView.textColor = [UIColor redColor]; // Change to desired color
//        titleView.font = [UIFont fontWithName:@"Roboto Regular" size:35.0f];
//        self.navigationItem.titleView = titleView;
//    }
//    titleView.text = title;
//    [titleView sizeToFit];
//}
@end
