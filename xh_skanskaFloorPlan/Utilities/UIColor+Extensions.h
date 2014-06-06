//
//  UIColor+Extensions.h
//  650mad
//
//  Created by Evan Buxton on 9/27/12.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;
+ (UIColor *)skLightBlue;
+ (UIColor *)skDarkBlue;
+ (UIColor *)skThemeBlue;
+ (UIColor *)skDarkYellow;
+ (UIColor *)skLightYellow;
+ (UIColor *)skDarkGreen;
+ (UIColor *)skLightGreen;
+ (UIColor *)skDarkGray;
+ (UIColor *)skLightGray;
+ (UIColor *)skCarPath;
+ (UIColor *)skRailPath;
+ (UIColor *)skFootPath;
@end
