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
@interface ViewController () <UIPageViewControllerDelegate>

@property (strong, nonatomic)			UIPageViewController	*pageViewController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *uiiv_bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"floor_plan_bg.jpg"]];
    uiiv_bgImg.frame = self.view.bounds;
    [self.view addSubview: uiiv_bgImg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
