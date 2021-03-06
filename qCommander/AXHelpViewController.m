//
//  AXHelpViewController.m
//  qCommander
//
//  Created by Hoa Diem Nguyet on 1/7/14.
//  Copyright (c) 2014 Hoa Diem Nguyet. All rights reserved.
//

#import "AXHelpViewController.h"

@interface AXHelpViewController ()

@end

@implementation AXHelpViewController

@synthesize pageTitles, pageImages, pageViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //Data model
    pageTitles = @[@"Step 1: Installing Bookmarklet", @"Step 2.1: Connecting", @"Step 2.2: Connecting", @"Step 3: Control", @"Step 4: Control Right On Lockscreen", @"More help"];//, @"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    pageImages = @[@"1.installing_bookmark.png", @"20.activating_bookmark.png", @"21.connecting.png", @"31.control.png", @"41.lockscreen.png", @"100.end.png"];// @"page1", @"page2", @"page3", @"page3", @"page4"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpContainerView"];
    self.pageViewController.dataSource = self;

    HelpPageViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //Color for page indicator
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];

    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:243/255.0f green:123/255.0f blue:29/255.0f alpha:1.0f];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startWalkthrough:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HelpPageViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HelpPageViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (HelpPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    HelpPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpPageViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (BOOL)startWalkthrough:(id)sender {
    HelpPageViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    return TRUE;
}

@end
