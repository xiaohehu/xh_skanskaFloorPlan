//
//  xh_dotsView.h
//  xh_skanskaFloorPlan
//
//  Created by Xiaohe Hu on 6/6/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol dotsViewDataSource;
@protocol dotsViewDelegate;

@interface xh_dotsView : UIView
{
    CGRect      viewFrame;
    float       x_Value;
    float       y_Value;
    int         numOfDots;
    BOOL        directionUP;
}
@property (nonatomic, strong) id<dotsViewDelegate>      delegate;
@property (nonatomic, strong) NSDictionary              *dict_data;
@end

@protocol dotsViewDelegate <NSObject>

-(void)seletctDotsViewItemAtIndex:(NSInteger)index;

@end