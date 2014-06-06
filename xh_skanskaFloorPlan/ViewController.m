//
//  ViewController.m
//  xh_skanskaFloorPlan
//
//  Created by Xiaohe Hu on 6/5/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "embDataViewController.h"
#import "embModelController.h"
#import "neoHotspotsView.h"
#import "xh_dotsView.h"

@interface ViewController () <UIPageViewControllerDelegate, dotsViewDelegate>

@property (readonly, strong, nonatomic) embModelController		*modelController;
@property (strong, nonatomic)		UIPageViewController	*pageViewController;

@end

@implementation ViewController
@synthesize modelController = _modelController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_pageViewController willMoveToParentViewController:nil];
	[_pageViewController.view removeFromSuperview];
	[_pageViewController removeFromParentViewController];
	_pageViewController = nil;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.view setFrame:CGRectMake(0.0, 0.0, 1024, 768)];
    UIImageView *uiiv_bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"floor_plan_bg.jpg"]];
    uiiv_bgImg.frame = self.view.bounds;
    [self.view addSubview: uiiv_bgImg];
    
    [self initDotsView];
}

-(void)initDotsView {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSArray *totalData = [[NSArray alloc] initWithContentsOfFile:path];
    for (int i = 0; i < totalData.count; i++) {
        NSDictionary *dotsData = [totalData objectAtIndex:i];
        xh_dotsView *dotView = [[xh_dotsView alloc] init];
        [dotView setDict_data:dotsData];
        dotView.tag = i;
        dotView.delegate = self;
        
        [self.view addSubview: dotView];
    }
}

-(void)seletctDotsViewItemAtIndex:(NSInteger)index {
    NSLog(@"Should load floor page view");
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    self.pageViewController.delegate = self;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews =YES;
    self.pageViewController.view.frame = CGRectMake(0, 0, 1024, 768);
    [self.pageViewController didMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self.pageViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    [self loadPage:0];
    
    
}

-(void)loadPage:(int)page {
    self.pageViewController.dataSource = self.modelController;
    [self.view addSubview: self.pageViewController.view];
//    [self setPageContainerData:page];
}


- (embModelController *)modelController
{
	// Return the model controller object, creating it if necessary.
	// In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[embModelController alloc] init];
    }
    return _modelController;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
