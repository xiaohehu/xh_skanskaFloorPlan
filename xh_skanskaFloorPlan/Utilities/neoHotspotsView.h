//
//  neoHotspotsView.h
//  neoHotspots
//
//  Created by Xiaohe Hu on 9/26/13.
//  Copyright (c) 2013 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import "KSLabel.h"
@class neoHotspotsView;

@protocol neoHotspotsViewDelegate
typedef enum {
    CaptionAlignmentTop,
    
    CaptionAlignmentBottom,
    
    CaptionAlignmentLeft,
    
    CaptionAlignmentRight,
    
    CaptionAlignmentTopLeft,
    
    CaptionAlignmentTopRight,
    
    CaptionAlignmentBottomLeft,
    
    CaptionAlignmentBottomRight
    
} HotspotCaptionAlignment;

@optional
- (void)neoHotspotsView:(neoHotspotsView *)hotspot didSelectItemAtIndex:(NSInteger)index;

@end
@interface neoHotspotsView : UIView <UIGestureRecognizerDelegate>
{
    UIImageView     *uiiv_hsImgView;
    UIImageView     *uiiv_arwImgView;
    NSString        *hotspotBgName;
    UIColor         *bgColor;
    KSLabel         *uil_caption;
    NSString        *str_labelText;
    NSString        *str_typeOfHs;
    
    int             tagOfHs;
    
    float           arwAngle;
    float           timeRotate;
    
    BOOL            timeIsSet;
    BOOL            withArw;

}
@property (nonatomic, assign) id                delegate;

@property (nonatomic, strong) UIImageView       *uiiv_hsImgView;
@property (nonatomic, strong) UIImageView       *uiiv_arwImgView;
@property (nonatomic, strong) NSString          *hotspotBgName;
@property (nonatomic, strong) UIColor           *bgColor;
@property (nonatomic, strong) KSLabel           *uil_caption;
@property (nonatomic ,strong) NSString          *str_labelText;
@property (nonatomic, strong) NSString          *str_typeOfHs;

@property (nonatomic, readwrite) float          arwAngle;
@property (nonatomic, readwrite) float          timeRotate;
@property (nonatomic, readwrite) int            tagOfHs;
@property (nonatomic, readwrite) int            withCaption;

@property (nonatomic, assign) HotspotCaptionAlignment labelAlignment;

- (void)hotspotWithTagTapped:(UIGestureRecognizer*)recognizer;

@end
