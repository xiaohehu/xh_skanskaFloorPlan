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
//#import "motionImageViewController.h"

@interface embDataViewController () <neoHotspotsViewDelegate> {
	int iTotalButtons;
	UIView *uiv_testFitButtonHOlder;
}

@property (nonatomic, strong) neoHotspotsView				*myHotspots;
@property (nonatomic, strong) NSMutableArray				*arr_hotspots;
@property (nonatomic, strong) NSMutableArray				*arr_testFitBtns;
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
	
	_arr_testFitBtns = [[NSMutableArray alloc] init];
	_arr_testFitBtns = [tmp objectForKey:@"testfitcaptions"];

	[self createTestFitButtons:(int)[_arr_testFitBtns count]];
	
	
	
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

#pragma mark - Shell Button
-(void)shellButton
{
	_uib_ShellBtn = [UIButton buttonWithType: UIButtonTypeCustom];
	
	_uib_ShellBtn.frame=CGRectMake(685, 125.5, 60, 44.5);
	
	[_uib_ShellBtn setBackgroundColor:[UIColor clearColor]];
	_uib_ShellBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	

    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
	_uib_ShellBtn.titleEdgeInsets = titleInsets;
	[_uib_ShellBtn setTitle:@"Shell" forState:UIControlStateNormal];
	
	[_uib_ShellBtn addTarget:self action:@selector(loadShellFloorPlan) forControlEvents: UIControlEventTouchDown];
	_uib_ShellBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
	[_uib_ShellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *buttonDefImage;
	UIImage *buttonSelImage;
	
	buttonDefImage = [[UIImage imageNamed:@"str_def.png"]
						resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f)];
	buttonSelImage = [[UIImage imageNamed:@"str_sel.png"]
						resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f)];
	
	[_uib_ShellBtn setBackgroundImage:buttonDefImage forState:UIControlStateNormal];
	[_uib_ShellBtn setBackgroundImage:buttonSelImage forState:UIControlStateHighlighted];
	[_uib_ShellBtn setBackgroundImage:buttonSelImage forState:UIControlStateSelected];
	
	_uib_ShellBtn.alpha=1.0;
	[self.view addSubview:_uib_ShellBtn];
	_uib_ShellBtn.selected=YES;
}



#pragma mark - Test Fit Buttons
-(void)createTestFitButtons:(int)index
{
	iTotalButtons=index;
	
	uiv_testFitButtonHOlder = [[UIView alloc] initWithFrame:CGRectZero];
	[uiv_testFitButtonHOlder setBackgroundColor:[UIColor redColor]];
	[self.view addSubview:uiv_testFitButtonHOlder];
	
	CGFloat viewWidth = 0;
	CGSize	stringsize;
	CGFloat	padding = -5.5;

	for (int j=0;j<iTotalButtons;j++){ //cols
		
		UIButton *firstButton;
		firstButton = [UIButton buttonWithType: UIButtonTypeCustom];
		firstButton.tag=j;
		
		NSString *tmp = _arr_testFitBtns[j];
        NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        
        if ([[vComp objectAtIndex:0] intValue] >= 7) {
            // iOS-7 code[current] or greater
            stringsize = [tmp sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        } else if ([[vComp objectAtIndex:0] intValue] == 6) {
            // iOS-6 code
            stringsize = [tmp sizeWithFont:[UIFont systemFontOfSize:13.0f]];
        }
 		
		if (j==0) {
			firstButton.frame=CGRectMake(padding, 0, stringsize.width+25, 44.5);
		} else {
			firstButton.frame=CGRectMake(viewWidth+padding, 0, stringsize.width+25, 44.5); // -10 ///////////////////////////
		}
		
		viewWidth += firstButton.frame.size.width+padding; // 7 ///////////////////////////
		
		[firstButton setBackgroundColor:[UIColor clearColor]];
		firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
		firstButton.titleEdgeInsets = titleInsets;
		[firstButton setTitle:_arr_testFitBtns[j] forState:UIControlStateNormal];
		
		[firstButton addTarget:self action:@selector(switchShellToTestFit:) forControlEvents: UIControlEventTouchDown];
		firstButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
		[firstButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		
		UIImage *buttonDefImage;
		UIImage *buttonSelImage;

		if ([_arr_testFitBtns count]==1) { // one button only t,l,b,r
			buttonDefImage = [[UIImage imageNamed:@"str_def.png"]
						   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.5f, 0.0f, 1.0f)];
			buttonSelImage = [[UIImage imageNamed:@"str_sel.png"]
							  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f)];
			
		} else if ([_arr_testFitBtns count]==2) {
			
			if (j==0) {
				buttonDefImage = [[UIImage imageNamed:@"left_def.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.75f, 0.0f, 6.0f)];
				buttonSelImage = [[UIImage imageNamed:@"left_sel.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.75f, 0.0f, 6.0f)];
			} else {

				buttonDefImage = [[UIImage imageNamed:@"right_def.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 1.75f)];
				buttonSelImage = [[UIImage imageNamed:@"right_sel.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 1.75f)];
			}
			
		} else if ([_arr_testFitBtns count]==3) {
			NSLog(@"3");
			if (j==0) {
				buttonDefImage = [[UIImage imageNamed:@"left_def.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.75f, 0.0f, 6.0f)];
				buttonSelImage = [[UIImage imageNamed:@"left_sel.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.75f, 0.0f, 6.0f)];
			} else if (j==1) {
				buttonDefImage = [[UIImage imageNamed:@"mid_def.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 7.0f)];
				buttonSelImage = [[UIImage imageNamed:@"mid_sel.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
			} else {
				buttonDefImage = [[UIImage imageNamed:@"right_def.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 1.75f)];
				buttonSelImage = [[UIImage imageNamed:@"right_sel.png"]
								  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 1.75f)];

			}
			
		} else {
			buttonDefImage = [[UIImage imageNamed:@"str_sel.png"]
						   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
		}
		
		[firstButton setBackgroundImage:buttonDefImage forState:UIControlStateNormal];
		[firstButton setBackgroundImage:buttonSelImage forState:UIControlStateHighlighted];
		[firstButton setBackgroundImage:buttonSelImage forState:UIControlStateSelected];
        
		CGRect frm = uiv_testFitButtonHOlder.frame;
		frm.size.width = viewWidth+padding;
		frm.size.height = 44.5;

		uiv_testFitButtonHOlder.frame = frm;
		frm.origin.x = 680 - uiv_testFitButtonHOlder.frame.size.width; // right edge
		frm.origin.y = 170 - uiv_testFitButtonHOlder.frame.size.height; // bottom edge

		uiv_testFitButtonHOlder.frame = frm;

		[uiv_testFitButtonHOlder addSubview:firstButton];
	}
}


#pragma mark Test Fit Toggle
-(IBAction)switchShellToTestFit:(id)sender
{
	// NSLog(@"switchShellToTestFit");
	NSDictionary *tmp = [[NSDictionary alloc] init];
	tmp = [_dict valueForKeyPath:@"floorplaninfo.testfits"][0];
	NSMutableArray *arr_testFits = [[NSMutableArray alloc] init];
	arr_testFits = [tmp objectForKey:@"testfitimages"];
	
	UIButton *resultButton = (UIButton *)sender;

	//Toggle on implementation.
	if (resultButton.selected == NO) {
		
		for (UIButton*btn in uiv_testFitButtonHOlder.subviews) {
			if (btn != resultButton) {
				[btn setSelected:NO];
				[btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		}
		
		// NSLog(@"toggle on");
		//[self clearAllButtons];
		resultButton.selected = YES;
		self.zoomingScroll.blurView.image = [UIImage imageNamed:arr_testFits[[sender tag]]];
		[self setBackgroundOfButton:sender selected:YES];
		[self setHotSpotVisibility:NO];
		_uib_ShellBtn.selected=NO;
		[_uib_ShellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	}
	
	//Toggle off implementation.
	else {
		NSLog(@"toggle off");
		resultButton.selected = NO;
		[self setHotSpotVisibility:YES];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self loadShellFloorPlan];
		});
		[self setBackgroundOfButton:sender selected:NO];
		_uib_ShellBtn.selected=YES;
	}
	
	// update plan data
	NSMutableArray *arr_testFitsInfo = [[NSMutableArray alloc] init];
	arr_testFitsInfo = [tmp objectForKey:@"testfitinfo"];
	
	if ([arr_testFitsInfo[0] length] !=0) {
		self.uii_PlanData = [UIImage imageNamed:arr_testFitsInfo[[sender tag]]];
		self.uiiv_PlanData.image = _uii_PlanData;
	}
	
}

#pragma mark - Shell Plan
-(void)loadShellFloorPlan
{
	NSLog(@"loadShellFloorPlan");
	self.zoomingScroll.blurView.image = [UIImage imageNamed:_floorplan[0]];
	
	NSString *planName = _dict[@"floorplaninfo"][0][@"floorinfo"][0];
	NSLog(@"%@", planName);
	self.uii_PlanData = [UIImage imageNamed:_dict[@"floorplaninfo"][0][@"floorinfo"][0]];
	[self.uiiv_PlanData setImage:_uii_PlanData];
	[_uib_ShellBtn setSelected:YES];
	[_uib_ShellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	[self resetTestFitButtonsOnly];
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
