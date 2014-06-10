//
//  embDataViewController.m
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embDataViewController.h"
#import "ebZoomingScrollView.h"
#import "neoHotspotsView.h"
#import "UIColor+Extensions.h"
//#import "motionImageViewController.h"

@interface embDataViewController () <neoHotspotsViewDelegate> {
	int iTotalButtons;
	UIView *uiv_testFitButtonHOlder;
}

@property (nonatomic, strong) neoHotspotsView				*myHotspots;
@property (nonatomic, strong) NSMutableArray				*arr_hotspots;
@property (nonatomic, strong) NSMutableArray				*arr_testFitBtnsName;
@property (nonatomic, strong) NSMutableArray                *arr_testFitBtns;
@property (nonatomic, strong) NSMutableArray                *arr_testFitImgs;
@property (nonatomic, strong) ebZoomingScrollView			*zoomingScroll;
@property (nonatomic, strong) UIImage						*uii_Plan;
@property (nonatomic, strong) UIView						*uiv_PlanDataContainer;
@property (nonatomic, strong) UIImage						*uii_PlanData;
@property (nonatomic, strong) UIImageView					*uiiv_PlanData;

@property (nonatomic, strong) NSMutableArray				*arr_floorplans;
@property (nonatomic, strong) NSDictionary					*dict;
@property (nonatomic, strong) NSMutableArray				*floorplan;
@property (nonatomic, strong) IBOutlet UICollectionView		*cView;
@property (nonatomic, strong) UIButton						*uib_ShellBtn;

@end

@implementation embDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_arr_hotspots = [[NSMutableArray alloc] init];
    _arr_testFitBtns = [[NSMutableArray alloc] init];
	// floor plans
	_arr_floorplans = [[NSMutableArray alloc] init];
	_dict = self.dataObject;
	_floorplan = [_dict valueForKeyPath:@"floorplaninfo.floorplan"];
	[_arr_floorplans addObject:[_floorplan objectAtIndex:0]];
	
    UIImageView *uiiv_bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grfx_floorPlan_bg.jpg"]];
    [self.view insertSubview:uiiv_bgImage atIndex:0];
    
//	[self shellButton];
}

#pragma mark - LAYOUT FLOOR PLAN DATA
-(void)viewWillLayoutSubviews
{
	_uii_Plan = [UIImage imageNamed:_floorplan[0]];
	if (!_zoomingScroll) {
		// NSLog(@"running");
		_zoomingScroll = [[ebZoomingScrollView alloc] initWithFrame:CGRectMake(2, 190, 688, 530) image:_uii_Plan shouldZoom:YES];
		[self.view insertSubview:_zoomingScroll atIndex:1];
		_zoomingScroll.delegate=self;
	}
	
	// plan info data
	NSString *planName = _dict[@"floorplaninfo"][0][@"floorinfo"][0];

	if (!_uiv_PlanDataContainer) {
		if ([planName length] !=0) {
			_uii_PlanData = [UIImage imageNamed:planName];
			
			// plan info container
			CGRect containerFrame = CGRectMake(31, 192, 630, 330);
			
			_uiv_PlanDataContainer = [[UIView alloc] initWithFrame:containerFrame];
			[self.view addSubview:_uiv_PlanDataContainer];
			
			UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height)];
			scroll.contentSize = CGSizeMake(_uii_PlanData.size.width, _uii_PlanData.size.height);
			scroll.showsHorizontalScrollIndicator = YES;
			scroll.scrollEnabled = YES;
			[_uiv_PlanDataContainer addSubview:scroll];
			
			// plan info uiimageview
			CGRect imageViewFrame = CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height);
			_uiiv_PlanData = [[UIImageView alloc] initWithFrame:imageViewFrame];
			_uiiv_PlanData.image = _uii_PlanData;
			[scroll addSubview:_uiiv_PlanData];
		}
	}
	
	/* if you want to add hotspots within floorplaninfo dictionary
	 <key>hotspots</key>
	 <array>
	 <dict>
	 <key>type</key>
	 <string>image</string>
	 <key>background</key>
	 <string>grfx_btn_rendering.png</string>
	 <key>xy</key>
	 <string>100,350</string>
	 <key>angle</key>
	 <string>180</string>
	 <key>caption</key>
	 <string>Night Hero</string>
	 <key>RGB</key>
	 <string></string>
	 <key>fileName</key>
	 <string></string>
	 </dict>
	 </array> */
	
	//check if any hot spots exists
	NSDictionary *hs = _dict[@"floorplaninfo"][0][@"hotspots"];

	if ([hs valueForKey:@"hotspots"] !=nil)
	{
		// NSLog(@"hotspots exist");
		NSArray *hotspots = [_dict valueForKeyPath:@"floorplaninfo.hotspots"];
		for (int i = 0; i < [hotspots count]; i++) {
			NSDictionary *hotspotItem = [[hotspots objectAtIndex:0] objectAtIndex:i];
			//NSLog(@"%@", [hotspotItem valueForKey:@"xy"]);
			
			//Get the position of Hs
			NSString *str_position = [hotspotItem valueForKey:@"xy"];
			NSRange range = [str_position rangeOfString:@","];
			NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
			NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
			
			float hs_x = [str_x floatValue];
			float hs_y = [str_y floatValue];
			_myHotspots = [[neoHotspotsView alloc] initWithFrame:CGRectMake(hs_x, hs_y, 40, 40)];
			_myHotspots.delegate=self;
			[_arr_hotspots addObject:_myHotspots];
			
			//Get the angle of arrow
			NSString *str_angle = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"angle"]];
			if ([str_angle isEqualToString:@""]) {
			}
			else
			{
				float hsAngle = [str_angle floatValue];
				_myHotspots.arwAngle = hsAngle;
			}
			
			//Get the name of BG img name
			NSString *str_bgName = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"background"]];
			_myHotspots.hotspotBgName = str_bgName;
			
			//Get the caption of hotspot
			NSString *str_caption = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"caption"]];
			_myHotspots.str_labelText = str_caption;
			_myHotspots.labelAlignment = CaptionAlignmentBottom;
			
			//Get the type of hotspot
			NSString *str_type = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"type"]];
			_myHotspots.str_typeOfHs = str_type;
			//        NSLog(@"Hotspot No.%i's type is: %@ \n\n",i ,str_type);
			
			//Animation time can be set
			//_myHotspots.timeRotate = 5.0;
			_myHotspots.tagOfHs = i;
			
			[_zoomingScroll.blurView addSubview:_myHotspots];
		}
		
	} else {
		NSLog(@"no hotspots exist");
	}
	
	// testfit buttons
	NSDictionary *tmp = [[NSDictionary alloc] init];
	tmp = [_dict valueForKeyPath:@"floorplaninfo.testfits"][0];
	
	_arr_testFitBtnsName = [[NSMutableArray alloc] init];
	_arr_testFitBtnsName = [tmp objectForKey:@"testfitcaptions"];

    _arr_testFitImgs = [[NSMutableArray alloc] init];
    _arr_testFitImgs = [tmp objectForKey:@"testfitimages"];
    
	[self createTestFitButtons:(int)[_arr_testFitBtnsName count]];
	
	
	
	// load views if you want
	/*
	 <key>views</key>
	 <dict>
	 <key>viewimages</key>
	 <array>
	 <string>625 Feet_W_HIGR4810_Crop.jpg</string>
	 </array>
	 <key>viewcaptions</key>
	 <array>
	 <string>West View - High-Rise - 600&apos;</string>
	 </array>
	 <key>viewlocations</key>
	 <array>
	 <string>490,85</string>
	 </array>
	 <key>viewbgs</key>
	 <array>
	 <string>grfx_avail_view_w.png</string>
	 </array>
	 </dict>
*/
	// views if they exist
//	NSDictionary *vws = _dict[@"floorplaninfo"][0][@"views"];
//	if ([vws count] != 0) {
//		// NSLog(@"views exist");
//		NSArray *views = [_dict valueForKeyPath:@"floorplaninfo.views"];
//
//		// get view locations
//		NSMutableArray *viewLocs = [[NSMutableArray alloc] init];
//		NSMutableArray *viewBGs = [[NSMutableArray alloc] init];
//		NSMutableArray *_arr_viewsBtns = [[NSMutableArray alloc] init];
//		
//		// get viewBGs for buttons (if any)
//		for (NSDictionary *dict in views) { // iterate through the array
//			NSMutableArray *viewbgs = [dict valueForKeyPath:@"viewbgs"];
//			if ([viewbgs count] > 0) {
//				for (int i=0; i<[viewbgs count]; i++) {
//					[viewBGs addObject:viewbgs[i]];
//				}
//			}
//		}
//		
//		//get view button locations
//		for (NSDictionary *dict in views) { // iterate through the array
//			NSMutableArray *viewXY = [dict valueForKeyPath:@"viewlocations"];
//			if ([viewXY count] > 0) {
//				for (int i=0; i<[viewXY count]; i++) {
//					[viewLocs addObject:viewXY[i]];
//				}
//			}
//		}
//		
//		for (int j=0;j<[viewLocs count];j++){ //cols
//			UIButton *firstButton;
//			firstButton = [UIButton buttonWithType: UIButtonTypeCustom];
//			firstButton.tag=j;
//			
//			NSArray *strings = [viewLocs[j] componentsSeparatedByString:@","];
//			NSString* firstString = [strings objectAtIndex:0];
//			NSString* secondString = [strings objectAtIndex:1];
//			
//			firstButton.frame=CGRectMake([firstString floatValue], [secondString floatValue], 44.0f, 44.0f);
//			[firstButton addTarget:self action:@selector(tappedViewAtIndex:) forControlEvents: UIControlEventTouchDown];
//			UIImage* image = [UIImage imageNamed:viewBGs[j]];
//			[firstButton setBackgroundImage:image forState:UIControlStateNormal];
//			[self.view addSubview:firstButton];
//			[_arr_viewsBtns addObject:firstButton];
//		}
//	}
}

#pragma mark - Test Fit Buttons
-(void)createTestFitButtons:(int)index
{
	iTotalButtons=index;
	
	uiv_testFitButtonHOlder = [[UIView alloc] initWithFrame:CGRectMake(0.0, 110, 370, 60.0)];
	[uiv_testFitButtonHOlder setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:uiv_testFitButtonHOlder];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]};
    CGSize pre_size = CGSizeZero;
    CGFloat pre_X = 0.0;
    CGFloat space = 10;
    
	for (int j=0;j<iTotalButtons;j++){ //cols
        NSString *str_btnTitile = [_arr_testFitBtnsName objectAtIndex:j];
        CGSize str_size =[str_btnTitile sizeWithAttributes:attributes];
        
		UIButton *uib_testFitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        uib_testFitBtn.frame = CGRectMake((pre_size.width + space + 11.0 + pre_X), 0.0, str_size.width + space, 60.0);
        [uib_testFitBtn setTitle:str_btnTitile forState:UIControlStateNormal];
        [uib_testFitBtn setTitle:str_btnTitile forState:UIControlStateSelected];
        [uib_testFitBtn setTitleColor:[UIColor skDarkGray] forState:UIControlStateSelected];
        [uib_testFitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        uib_testFitBtn.tag = j;
        [uib_testFitBtn addTarget:self action:@selector(testFitBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (uib_testFitBtn.selected)
            [uib_testFitBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        
        else
            [uib_testFitBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        
        if (j == 0) {
            uib_testFitBtn.selected = YES;
        }
        else {
            UIView *uiv_divideBar = [[UIView alloc] initWithFrame:CGRectMake(pre_X + pre_size.width + space + 5, 0.0, 1.0, uiv_testFitButtonHOlder.frame.size.height)];
            uiv_divideBar.backgroundColor = [UIColor whiteColor];
            [uiv_testFitButtonHOlder addSubview: uiv_divideBar];
        }
            
        uib_testFitBtn.backgroundColor = [UIColor clearColor];
        [uiv_testFitButtonHOlder addSubview: uib_testFitBtn];
        pre_size = str_size;
        pre_X = uib_testFitBtn.frame.origin.x;
        [_arr_testFitBtns addObject: uib_testFitBtn];
	}
}


#pragma mark Test Fit Toggle
-(void)testFitBtnTapped:(id)sender {
    for (UIButton *tmp in _arr_testFitBtns) {
        tmp.selected = NO;
    }
    
    UIButton *tmpBtn = sender;
    tmpBtn.selected = !tmpBtn.selected;
    
    NSString *str_imgName = [_arr_testFitImgs objectAtIndex:tmpBtn.tag];
    
    [UIView animateWithDuration:0.33 animations:^{
        _zoomingScroll.blurView.alpha = 0.0;
    } completion:^(BOOL finished){
        _zoomingScroll.blurView.image = [UIImage imageNamed:str_imgName];
        [UIView animateWithDuration:0.33 animations:^{
            _zoomingScroll.blurView.alpha = 1.0;
        }];
    }];
}

#pragma mark - Hotspot Visibility
-(void)setHotSpotVisibility:(BOOL)visibility
{
	for (neoHotspotsView *hs in [_zoomingScroll.blurView subviews]) {
		if (visibility==NO) {
			[hs setAlpha:0.0];
		} else {
			[hs setAlpha:1.0];
		}
	}
}

#pragma mark - Button Utilities
-(void)resetTestFitButtonsOnly
{
	for (UIView *tmp in [uiv_testFitButtonHOlder subviews]) {
		if ([tmp isKindOfClass:[UIButton class]]) {
			// NSLog(@"CLEAR BUTTONS");
			[(UIButton*)tmp setSelected:NO];
			[(UIButton*)tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[tmp setBackgroundColor:[UIColor clearColor]];
		}
	}
}

-(void)setBackgroundOfButton:(id)sender selected:(BOOL)selected
{
	UIButton* button = (UIButton*)sender;
	
	if (selected == YES) {
		NSLog(@"fill = YES");
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setSelected:YES];
	} else {
		NSLog(@"fill = NO");
		[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[button setSelected:NO];

	}
}

#pragma mark - View Action When Tapped
-(void)tappedViewAtIndex:(id)sender
{
	NSString *fileType = [NSString stringWithFormat:@"At index %li",(long)[sender tag]];
	
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"View Tapped!"
													  message:fileType
													 delegate:nil
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
	[message show];
}


#pragma mark - Hotspot Tapped Delegate Method
-(void)neoHotspotsView:(neoHotspotsView *)hotspot didSelectItemAtIndex:(NSInteger)index

{
//	NSLog(@"gf");
//    neoHotspotsView *tmp = _arr_hotspots[index];
//	NSString *fileType = [NSString stringWithFormat:@"Hotspot index is %i and is a type of %@",tmp.tagOfHs, tmp.str_typeOfHs];
//	
//	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hotspot Tapped!"
//                                                      message:fileType
//                                                     delegate:nil
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//    [message show];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"handleHotspot"
     object:self];
}


#pragma mark - BOILERPLATE
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	// otherwise plan stays zoomed in
	// when you scroll to new page
	[_zoomingScroll resetScroll];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
