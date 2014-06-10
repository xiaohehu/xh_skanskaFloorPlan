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
#import "UIColor+Extensions.h"

@interface ViewController () <UIPageViewControllerDelegate, dotsViewDelegate>

@property (strong, nonatomic)           UIImageView             *uiiv_bgImg;
@property (strong, nonatomic)           UIImageView             *uiiv_bldingImg;
@property (strong, nonatomic)           UIView                  *uiv_floorIndicator;

@property (strong, nonatomic)           NSMutableArray          *arr_bldingBtnArray;
@property (strong, nonatomic)           NSMutableArray          *arr_dotViewArray;

@property (readonly, strong, nonatomic) embModelController		*modelController;
@property (readonly, strong, nonatomic) NSArray					*arr_pageData;
@property (strong, nonatomic)           UIPageViewController	*pageViewController;
@property (nonatomic, readwrite)        NSInteger               currentPage;

@property (nonatomic, strong)           UIButton                *uib_upArrowBtn;
@property (nonatomic, strong)           UIButton                *uib_downArrwoBtn;
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
    [self initVC];
}

-(void)initVC {
    //Init Arrays & Views
    _arr_bldingBtnArray = [[NSMutableArray alloc] init];
    _arr_dotViewArray = [[NSMutableArray alloc] init];
    //Set Background image
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view setFrame:CGRectMake(0.0, 0.0, 1024, 768)];
    _uiiv_bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grfx_floorPlan_bg.jpg"]];
    _uiiv_bgImg.frame = self.view.bounds;
    [self.view addSubview: _uiiv_bgImg];
    
    //Add white building image
    _uiiv_bldingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grfx_floorplan_blding.png"]];
    _uiiv_bldingImg.frame = CGRectMake(93, 57, _uiiv_bldingImg.frame.size.width, _uiiv_bldingImg.frame.size.height);
    _uiiv_bldingImg.userInteractionEnabled = YES;
    [self.view addSubview: _uiiv_bldingImg];
    
    //Set Floor Indicator
    _uiv_floorIndicator = [[UIView alloc] init];
    _uiv_floorIndicator.alpha = 0.6;
    _uiv_floorIndicator.frame =CGRectZero;
    [_uiiv_bldingImg addSubview: _uiv_floorIndicator];
    _uiv_floorIndicator.hidden = YES;
    
    //Set Arrow Buttons
    _uib_upArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_upArrowBtn.frame = CGRectMake(640, 64, 47, 47);
    [_uib_upArrowBtn setImage:[UIImage imageNamed:@"grfx_flooplan_up.png"] forState:UIControlStateNormal];
    _uib_upArrowBtn.tag = 10;
    [_uib_upArrowBtn addTarget:self action:@selector(arrowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_uib_upArrowBtn atIndex:10];
    _uib_upArrowBtn.hidden = YES;
    
    _uib_downArrwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_downArrwoBtn.frame = CGRectMake(640, 695, 47, 47);
    [_uib_downArrwoBtn setImage:[UIImage imageNamed:@"grfx_flooplan_down.png"] forState:UIControlStateNormal];
    _uib_downArrwoBtn.tag = 11;
    [_uib_downArrwoBtn addTarget:self action:@selector(arrowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_uib_downArrwoBtn atIndex:10];
    _uib_downArrwoBtn.hidden = YES;
    
    //Set colored floor
    for (int i = 0; i < 4; i++) {
        switch (i) {
            case 0: {
                UIButton *uib_bldingFloor = [UIButton buttonWithType:UIButtonTypeCustom];
                uib_bldingFloor.frame = CGRectMake(31, 347, 387, 36);
                uib_bldingFloor.backgroundColor = [UIColor clearColor];
                uib_bldingFloor.tag = i;
                [uib_bldingFloor addTarget:self action:@selector(floorBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                [_uiiv_bldingImg addSubview: uib_bldingFloor];
                [_arr_bldingBtnArray addObject:uib_bldingFloor];
                break;
            }
            case 1: {
                UIButton *uib_bldingFloor = [UIButton buttonWithType:UIButtonTypeCustom];
                uib_bldingFloor.frame = CGRectMake(31, 384, 387, 36);
                uib_bldingFloor.backgroundColor = [UIColor clearColor];
                uib_bldingFloor.tag = i;
                [uib_bldingFloor addTarget:self action:@selector(floorBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                [_uiiv_bldingImg addSubview: uib_bldingFloor];
                [_arr_bldingBtnArray addObject:uib_bldingFloor];
                break;
            }
            case 2: {
                UIButton *uib_bldingFloor = [UIButton buttonWithType:UIButtonTypeCustom];
                uib_bldingFloor.frame = CGRectMake(31, 420, 387, 36);
                uib_bldingFloor.backgroundColor = [UIColor clearColor];
                uib_bldingFloor.tag = i;
                [uib_bldingFloor addTarget:self action:@selector(floorBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                [_uiiv_bldingImg addSubview: uib_bldingFloor];
                [_arr_bldingBtnArray addObject:uib_bldingFloor];
                break;
            }
            case 3: {
                UIButton *uib_bldingFloor = [UIButton buttonWithType:UIButtonTypeCustom];
                uib_bldingFloor.frame = CGRectMake(2, 574, 645, 54);
                uib_bldingFloor.backgroundColor = [UIColor clearColor];
                uib_bldingFloor.tag = i;
                [uib_bldingFloor addTarget:self action:@selector(floorBtnTapped:) forControlEvents:UIControlEventTouchDown];
                [_uiiv_bldingImg addSubview: uib_bldingFloor];
                [_arr_bldingBtnArray addObject:uib_bldingFloor];
                break;
            }
            default:
                break;
        }
    }
    
    _arr_pageData = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"floorplanData" ofType:@"plist"]] copy];
    _modelController = [[embModelController alloc] init];
    
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
        [_arr_dotViewArray addObject:dotView];
        [self.view addSubview: dotView];
    }
}

#pragma mark - Tap Arrow button 
-(void)arrowBtnTapped:(id)sender {
    UIButton *tmpBtn = sender;
    int index = (int)tmpBtn.tag;
    
    if (index == 10){
        _currentPage--;
        embDataViewController *startingViewController = [self.modelController viewControllerAtIndex:_currentPage storyboard:self.storyboard];
        
        NSArray *viewControllers = @[startingViewController];
        
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:nil];
    }
    if (index == 11) {
        _currentPage++;
        embDataViewController *startingViewController = [self.modelController viewControllerAtIndex:_currentPage storyboard:self.storyboard];
        
        NSArray *viewControllers = @[startingViewController];
        
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
    [self setPageIndex];
//    if (_currentPage == 0) {
//        _uib_upArrowBtn.hidden = YES;
//        _uib_downArrwoBtn.hidden = NO;
//    }
//    else if (_currentPage == (_arr_pageData.count - 1)) {
//        _uib_downArrwoBtn.hidden = YES;
//        _uib_upArrowBtn.hidden = NO;
//    }
//    else {
//        _uib_upArrowBtn.hidden = NO;
//        _uib_downArrwoBtn.hidden = NO;
//    }
}

#pragma mark - Dotview's button is tapped & Floor button is tapped

-(void)seletctDotsViewItemAtIndex:(NSInteger)index {
    for (UIButton *tmp in _arr_bldingBtnArray) {
        tmp.userInteractionEnabled = NO;
    }
    for (UIView *tmp in _arr_dotViewArray) {
        tmp.userInteractionEnabled = NO;
    }
    [self handleFloorIndicator:index];
}

-(void)floorBtnTapped:(id)sender {
    for (UIButton *tmp in _arr_bldingBtnArray) {
        tmp.userInteractionEnabled = NO;
    }
    for (UIView *tmp in _arr_dotViewArray) {
        tmp.userInteractionEnabled = NO;
    }
    UIButton *tmpBtn = sender;
    [self handleFloorIndicator:tmpBtn.tag];
}

-(void)tapToBack:(UITapGestureRecognizer *)sender {
    _uib_downArrwoBtn.hidden = YES;
    _uib_upArrowBtn.hidden = YES;
    
    UITapGestureRecognizer *tmpTap = sender;
    [_uiiv_bldingImg removeGestureRecognizer:tmpTap];
    
    for (UIButton *tmpBtn in _arr_bldingBtnArray) {
        tmpBtn.userInteractionEnabled = YES;
    }
    for (UIView *tmp in _arr_dotViewArray) {
        tmp.userInteractionEnabled = YES;
    }
    [UIView animateWithDuration:0.33 animations:^{
        self.pageViewController.view.alpha = 0.0;
    }];
    
    [_pageViewController willMoveToParentViewController:nil];
	[_pageViewController.view removeFromSuperview];
	[_pageViewController removeFromParentViewController];
	_pageViewController = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        _uiiv_bgImg.hidden = NO;
        _uiiv_bldingImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
        _uiiv_bldingImg.frame = CGRectMake(93, 57, _uiiv_bldingImg.frame.size.width, _uiiv_bldingImg.frame.size.height);
    } completion:^(BOOL finished){
        for (UIView *tmpDotView in _arr_dotViewArray) {
            tmpDotView.alpha = 1.0;
        }
    }];
}

-(void)handleFloorIndicator:(NSInteger)index {
    
    UIButton *tmpBtn = [_arr_bldingBtnArray objectAtIndex:index];
    if (_uiv_floorIndicator.hidden) {
        _uiv_floorIndicator.hidden = NO;
        _uiv_floorIndicator.frame = tmpBtn.frame;
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_floorIndicator.alpha = 0.6;
            _uiv_floorIndicator.backgroundColor = [UIColor skDarkYellow];
        }
                         completion:^(BOOL finished){
                             [self initPageView:index];
                             [self scaleAndMovePageVC];
                             for (UIView *tmpDotView in _arr_dotViewArray) {
                                 tmpDotView.alpha = 0.0;
                             }
                         }];
        _currentPage = index;
    }
    else {
        if (index == _currentPage) {
            [UIView animateWithDuration:0.33 animations:^{
                _uiv_floorIndicator.alpha = 0.0;}
                             completion:^(BOOL finished){
                                 _uiv_floorIndicator.hidden = YES;
                             }];
            for (UIButton *tmpBtn in _arr_bldingBtnArray) {
                tmpBtn.userInteractionEnabled = YES;
            }
            for (UIView *tmp in _arr_dotViewArray) {
                tmp.userInteractionEnabled = YES;
            }
            return;
        }
        else {
            [UIView animateWithDuration:0.33 animations:^{
                _uiv_floorIndicator.frame = tmpBtn.frame;
                _uiv_floorIndicator.backgroundColor = [UIColor skDarkYellow];
            }
                             completion:^(BOOL finished){
                                 [self initPageView:index];
                                 [self scaleAndMovePageVC];
                                 for (UIView *tmpDotView in _arr_dotViewArray) {
                                     tmpDotView.alpha = 0.0;
                                 }
                             }];
            _currentPage = index;
        }
    }
}

#pragma mark - Set up page view

-(void)initPageView:(NSInteger)index {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self.modelController;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews =YES;
    self.pageViewController.view.frame = CGRectMake(0, 0, 1024, 768);
    [self.pageViewController didMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    self.pageViewController.view.alpha = 0.0;
    [self.pageViewController.view setBackgroundColor:[UIColor clearColor]];
    
    
    [self loadPage:index];
}

-(void)loadPage:(int)page {
//    if (page == 0) {
//        _uib_downArrwoBtn.hidden = NO;
//        _uib_upArrowBtn.hidden = YES;
//    }
//    else if (page == (_arr_pageData.count - 1)) {
//        _uib_upArrowBtn.hidden = NO;
//        _uib_downArrwoBtn.hidden = YES;
//    }
//    else {
//        _uib_downArrwoBtn.hidden = NO;
//        _uib_upArrowBtn.hidden = NO;
//    }
    
    
//    [self.view addSubview: self.pageViewController.view];
    
    embDataViewController *startingViewController = [self.modelController viewControllerAtIndex:page storyboard:self.storyboard];
	
	NSArray *viewControllers = @[startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
}

#pragma mark - scale building image

- (void)scaleAndMovePageVC
{
    for (UIButton *tmpBtn in _arr_bldingBtnArray) {
        tmpBtn.userInteractionEnabled = NO;
    }
    
    UITapGestureRecognizer *tapToBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBack:)];
    tapToBack.numberOfTapsRequired = 1;
    [_uiiv_bldingImg addGestureRecognizer:tapToBack];
    _uiiv_bgImg.hidden = YES;
    
    [UIView animateWithDuration:1.0 animations:^{
        _uiiv_bldingImg.transform = CGAffineTransformMakeScale(0.44, 0.44);
        _uiiv_bldingImg.frame = CGRectMake(21.0, 384.0, _uiiv_bldingImg.frame.size.width, _uiiv_bldingImg.frame.size.height);
        self.pageViewController.view.center = CGPointMake(844,430);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            self.pageViewController.view.alpha = 1.0;}];
        
        for (UIView *tmpDotView in _arr_dotViewArray) {
            tmpDotView.alpha = 0.0;
        }
        
        if (_currentPage == 0) {
            _uib_downArrwoBtn.hidden = NO;
            _uib_upArrowBtn.hidden = YES;
        }
        else if (_currentPage == (_arr_pageData.count - 1)) {
            _uib_upArrowBtn.hidden = NO;
            _uib_downArrwoBtn.hidden = YES;
        }
        else {
            _uib_downArrwoBtn.hidden = NO;
            _uib_upArrowBtn.hidden = NO;
        }

        
    }];
}

#pragma mark - PageViewController
#pragma mark update page index
- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // If the page did not turn
    if (!completed)
    {
        // You do nothing because whatever page you thought you were on
        // before the gesture started is still the correct page
		NSLog(@"same page");
        return;
    }
    // This is where you would know the page number changed and handle it appropriately
    NSLog(@"new page");
    [self setPageIndex];
}

#pragma mark set page index
-(void)setPageIndex
{
    embDataViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    int index = (int)[self.modelController indexOfViewController:theCurrentViewController];
    _currentPage = index;
    if (_currentPage == 0) {
        _uib_downArrwoBtn.hidden = NO;
        _uib_upArrowBtn.hidden = YES;
    }
    else if (_currentPage == (_arr_pageData.count - 1)) {
        _uib_upArrowBtn.hidden = NO;
        _uib_downArrwoBtn.hidden = YES;
    }
    else {
        _uib_downArrwoBtn.hidden = NO;
        _uib_upArrowBtn.hidden = NO;
    }
    UIButton *tmpBtn;
    for (UIButton *tmp in _arr_bldingBtnArray) {
        if (tmp.tag == index) {
            tmpBtn = tmp;
        }
    }
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_floorIndicator.frame = tmpBtn.frame;
    }];
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
