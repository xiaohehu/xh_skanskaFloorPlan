//
//  xh_dotsView.m
//  xh_skanskaFloorPlan
//
//  Created by Xiaohe Hu on 6/6/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xh_dotsView.h"
#import "UIColor+Extensions.h"
#define kBigDotSize  18.0
#define kRadius 4.0
#define kSpace 7.0
#define kTopViewSize 62

@interface xh_dotsView ()
@property (nonatomic, strong)   UIView          *uiv_bigDot;
@property (nonatomic, strong)   UITextView      *uitv_textView;
@property (nonatomic, strong)   UIView          *uiv_topView;
@property (nonatomic, strong)   UIButton        *uib_topButton;
@end

@implementation xh_dotsView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _dict_data = [[NSDictionary alloc] init];
        _uiv_topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kTopViewSize, kTopViewSize)];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setDict_data:(NSDictionary *)dict_data {
    _dict_data = dict_data;
    [self loadData];
}
-(void)loadData {
    NSLog(@"Load the Data");
    
    //Get X,Y postion
    NSString *str_position = [[NSString alloc] initWithString:[_dict_data objectForKey:@"xy"]];
    NSRange range = [str_position rangeOfString:@","];
    NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
    NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
    x_Value = [str_x floatValue];
    y_Value = [str_y floatValue];
            
    //Get num of dots
    NSNumber *dotsNum = [[NSNumber alloc] init];
    dotsNum = [_dict_data objectForKey:@"num"];
            numOfDots = [dotsNum intValue];
    
    [self initItems];
}

-(void)initItems {
    self.frame = CGRectMake(x_Value, y_Value, kBigDotSize, kBigDotSize);
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(x_Value, y_Value, numOfDots * (kSpace + kRadius*2) + kBigDotSize, kBigDotSize);
    
    //Create big dot at bottom
    _uiv_bigDot = [[UIView alloc] init];
    _uiv_bigDot.backgroundColor = [UIColor skThemeBlue];
    _uiv_bigDot.frame = CGRectMake(0, 0, kBigDotSize, kBigDotSize);
    CGPoint savedCenter = _uiv_bigDot.center;
    _uiv_bigDot.layer.cornerRadius = kBigDotSize/2.0;
    _uiv_bigDot.center = savedCenter;
    [self addSubview: _uiv_bigDot];
    
    CGSize dotSize = CGSizeMake(kRadius*2, kRadius*2);
    for (int i = 0; i < numOfDots; i++) {
        UIView *uiv_smallDots = [[UIView alloc] init];
        uiv_smallDots.backgroundColor = [UIColor skThemeBlue];
        
        uiv_smallDots.frame = CGRectMake(savedCenter.x + kBigDotSize/2 + kSpace + (kSpace + dotSize.height)*i, savedCenter.y - kRadius , dotSize.width, dotSize.height);
        CGPoint smallCenter = uiv_smallDots.center;
        uiv_smallDots.layer.cornerRadius = kRadius;
        uiv_smallDots.layer.shouldRasterize = YES;
        uiv_smallDots.center = smallCenter;
        [self addSubview:uiv_smallDots];
    }
    
    [self initTopView];
}

-(void)initTopView {
    CGRect frame = _uiv_topView.frame;
    frame.origin.x = kSpace + numOfDots * (kSpace + 2*kRadius) + kBigDotSize;
    frame.origin.y = -(kTopViewSize - self.frame.size.height)/2;
    _uiv_topView.frame = frame;
    _uiv_topView.backgroundColor= [UIColor clearColor];
    CGPoint savedCenter = _uiv_topView.center;
    _uiv_topView.layer.cornerRadius = kTopViewSize/2.0;
    _uiv_topView.center = savedCenter;
    _uiv_topView.layer.borderWidth = 3.0;
    _uiv_topView.layer.borderColor = [UIColor skThemeBlue].CGColor;
    
    UILabel *uil_floor = [[UILabel alloc] initWithFrame:_uiv_topView.bounds];
    NSString *textContent = [[NSString alloc] initWithString:[_dict_data objectForKey:@"text"]];
    [uil_floor setText: textContent];
    [uil_floor setTextAlignment:NSTextAlignmentCenter];
    uil_floor.numberOfLines = 0;
    [uil_floor setLineBreakMode:NSLineBreakByWordWrapping];
    [uil_floor setTextColor:[UIColor skThemeBlue]];
    [_uiv_topView addSubview: uil_floor];
    
    _uib_topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_topButton.frame = _uiv_topView.frame;
    _uib_topButton.backgroundColor = [UIColor clearColor];
    _uib_topButton.tag = self.tag;
    [_uib_topButton addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _uiv_topView];
    
    [self insertSubview:_uib_topButton aboveSubview:_uiv_topView];
}

-(void)topButtonTapped:(id)sender {
    UIButton *tmp = sender;
    [self seletctDotsViewItemAtIndex:tmp.tag];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(_uib_topButton.frame, point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

-(void)seletctDotsViewItemAtIndex:(NSInteger)index {
    [self.delegate seletctDotsViewItemAtIndex:index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
