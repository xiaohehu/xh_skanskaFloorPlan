//
//  embModelController.h
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class embDataViewController;

@interface embModelController : NSObject <UIPageViewControllerDataSource>

- (embDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(embDataViewController *)viewController;

@end
