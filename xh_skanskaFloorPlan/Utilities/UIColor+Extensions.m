//
//  UIColor+Extensions.m
//  650mad
//
//  Created by Evan Buxton on 9/27/12.
//
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

#pragma mark
#pragma mark description

+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    return [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor *)skLightBlue {
	return [UIColor colorWithRed: 45.0f/255.0f green: 175.0f/255.0f blue: 228.0f/255.0f alpha: 1];
}

+ (UIColor *)skDarkBlue {
	return [UIColor colorWithRed: 25.0f/255.0f green: 161.0f/255.0f blue: 219.0f/255.0f alpha: 1];
}

+ (UIColor *)skThemeBlue {
	return [UIColor colorWithRed:0.0f/255.0f green:86.0f/255.0f blue:119.0f/255.0f alpha:1.0];
}

+ (UIColor *)skLightYellow {
	return [UIColor colorWithRed:247.0f/255.0f green:195.0f/255.0f blue:87.0f/255.0f alpha:1.0];
}

+ (UIColor *)skDarkYellow {
	return [UIColor colorWithRed:241.0f/255.0f green:189.0f/255.0f blue:71.0f/255.0f alpha:1.0];
}

+ (UIColor *)skDarkGreen {
	return [UIColor colorWithRed:79.0f/255.0f green:159.0f/255.0f blue:69.0f/255.0f alpha:1.0];
}

+ (UIColor *)skLightGreen {
	return [UIColor colorWithRed:138.0f/255.0f green:193.0f/255.0f blue:116.0f/255.0f alpha:1.0];
}

+ (UIColor *)skDarkGray {
	return [UIColor colorWithRed:98.0/255.0 green: 102.0/255.0 blue: 106.0/255.0 alpha:1.0];
}

+ (UIColor *)skLightGray {
	return [UIColor colorWithRed:43.0f/255.0f green:56.0f/255.0f blue:140.0f/255.0f alpha:1.0];
}

+ (UIColor *)skCarPath {
	return [UIColor colorWithRed: 42.0/255.0 green: 64.0/255.0 blue: 255.0/255.0 alpha: 1.0];
}

+ (UIColor *)skRailPath {
	return [UIColor colorWithRed: 43.0/255.0 green: 56.0/255.0 blue: 143.0/255.0 alpha: 1.0];
}

+ (UIColor *)skFootPath {
	return [UIColor colorWithRed: 255.0/255.0 green: 142.0/255.0 blue: 20.0/255.0 alpha: 1.0];
}

+ (UIColor *)randomColor {
    return [self colorWithRed:((float)rand() / RAND_MAX)
                        green:((float)rand() / RAND_MAX)
                         blue:((float)rand() / RAND_MAX)
                        alpha:1.0f];
}

// use self.view.backgroundColor = highlight? [UIColor paleYellowColor] : [UIColor whitecolor];

@end
