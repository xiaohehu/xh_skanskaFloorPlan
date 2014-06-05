//
//  embDrawPath.m
//  embAnimatedPath
//
//  Created by Evan Buxton on 12/12/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embDrawPath.h"

@implementation embDrawPath

@synthesize delegate;

- (void)baseInit {
	_animationSpeed = 3.0;
	_pathLineWidth = 5.0;
	_pathFillColor = nil;
	_pathStrokeColor = [UIColor clearColor];
	_pathCapImage = nil;
	_animated = YES;
	_isTappable = YES;
	polyPaths = [[NSMutableArray alloc] init];
	arr_shapeLayers = [[NSMutableArray alloc] init];
    arr_tappedArray = [[NSMutableArray alloc] init];
    isTapped = NO;
    isCleared = NO;
    canBeCanceled = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

#pragma mark - DELEGATE MESSAGES
-(void)embDrawPathShouldRemove
{
	[self removeFromSuperview];
}

-(void)pathTappedAtIndex:(int)i
{
	NSLog(@"tapped %i", i);
	if ([delegate respondsToSelector:@selector(embDrawPath:indexOfTapped:)])
		[delegate embDrawPath:self indexOfTapped:i];
}

-(void)didFinishAnimating {
	if ([delegate respondsToSelector:@selector(didFinishAnimating:)])
		return [delegate didFinishAnimating:self];
}

-(void)pathAnimating:(embDrawPath*)animating {
	if ([delegate respondsToSelector:@selector(pathAnimating:)])
		return [delegate pathAnimating:self];
}

-(NSString*)pathString
{
	NSString *myStr = _pathString;
	return myStr;
}

- (void)startAnimationFromIndex:(int)index afterDelay:(CGFloat)afterDelay
{	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.path = [self buildPath].CGPath;
	shapeLayer.strokeColor = [_pathStrokeColor CGColor];
	shapeLayer.fillColor = [_pathFillColor CGColor];
	shapeLayer.lineWidth = _pathLineWidth;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.opacity = 0.0;
	[arr_shapeLayers addObject:shapeLayer];
	
	if (_isTappable) {
		if (canBeCanceled == NO) {
            UITapGestureRecognizer *menuFingerTap = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(mainMenuTapped:)];
            [self addGestureRecognizer:menuFingerTap];
        }
        if (canBeCanceled == YES) {
            UITapGestureRecognizer *menuFingerTap = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(mainMenuTappedWhitCanceled:)];
            [self addGestureRecognizer:menuFingerTap];
        }
	}
	
	[self.layer addSublayer:shapeLayer];
	self.pathLayer = shapeLayer;
	
	if (_pathCapImage) {
		UIImage *tipImage = _pathCapImage;
		CALayer *penLayer = [CALayer layer];
		penLayer.contents = (id)tipImage.CGImage;
		penLayer.anchorPoint = CGPointMake(0.5, 0.5);
		penLayer.frame = CGRectMake(0.0f, 0.0f, tipImage.size.width, tipImage.size.height);
		[_pathLayer addSublayer:penLayer];
		self.penLayer = penLayer;
	}
	
	if (!_animated) {
		shapeLayer.opacity = 1.0;
		return;
	}

	// otherwise start DRAWING!!
	CABasicAnimation *pathOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pathOpacity.duration = 0.33;
	[pathOpacity setBeginTime:CACurrentMediaTime()+afterDelay];
    pathOpacity.fromValue = @(0.0f);
    pathOpacity.toValue = @(1.0f);
	pathOpacity.fillMode = kCAFillModeForwards;
	pathOpacity.removedOnCompletion = NO;
    [self.pathLayer addAnimation:pathOpacity forKey:@"opacity"];
	
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation.delegate=self;
    pathAnimation.duration = _animationSpeed;
	[pathAnimation setBeginTime:CACurrentMediaTime()+afterDelay];
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
	[pathAnimation setValue:@"strokeEnd" forKey:@"id"];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
	
	CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	[penAnimation setBeginTime:CACurrentMediaTime()];
	penAnimation.duration = _animationSpeed;
	[penAnimation setBeginTime:CACurrentMediaTime()+afterDelay];
	penAnimation.path = self.pathLayer.path;
	penAnimation.calculationMode = kCAAnimationCubicPaced;
	penAnimation.rotationMode = kCAAnimationRotateAuto;
	penAnimation.fillMode = kCAFillModeForwards;
	penAnimation.removedOnCompletion = NO;
	penAnimation.delegate = self;
	[self.penLayer addAnimation:penAnimation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([[anim valueForKey:@"id"] isEqual:@"strokeEnd"]) {
        NSLog(@"strokeEnd finished");
		[self didFinishAnimating];
    }
}

-(void)animationDidStart:(CAAnimation *)anim {
	[self pathAnimating:self];
}

-(void)highlightFromParent:(int)index
{
	
	[polyPaths enumerateObjectsUsingBlock:^(UIBezierPath *obj, NSUInteger idx, BOOL *stop) {
		// clear already highlighted
		for (int i=0; i<[arr_shapeLayers count]; i++) {
			CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
			myShapeLayer = arr_shapeLayers[idx];
			myShapeLayer.path = obj.CGPath;
//			myShapeLayer.fillColor = [[UIColor clearColor] CGColor];
			myShapeLayer.opacity = 0.5;
            if (myShapeLayer.fillColor == [[UIColor whiteColor] CGColor]) {
                myShapeLayer.fillColor = [[UIColor clearColor] CGColor];
            }
		}
	}];
	
	CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
	myShapeLayer = arr_shapeLayers[index];
	UIBezierPath*patth = polyPaths[index];
	myShapeLayer.path = patth.CGPath;
	myShapeLayer.fillColor = [[UIColor whiteColor] CGColor];
	myShapeLayer.opacity = 0.5;
}

-(void)highlightFromParent:(int)index andTappedArray:(NSMutableArray *)tappedArray
{
	[polyPaths enumerateObjectsUsingBlock:^(UIBezierPath *obj, NSUInteger idx, BOOL *stop) {
		// clear already highlighted
		for (int i=0; i<[arr_shapeLayers count]; i++) {
            
            CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
			myShapeLayer = arr_shapeLayers[idx];
			myShapeLayer.path = obj.CGPath;
            myShapeLayer.opacity = 0.5;
            myShapeLayer.fillColor = [[UIColor clearColor] CGColor];
            
            for (int j = 0; j < [tappedArray count]; j++) {
                int index = [tappedArray[j] intValue];
                if ((int)idx == index) {
                    myShapeLayer.fillColor = [[UIColor redColor] CGColor];
//                    NSLog(@"all the items in array is %i", index);
                }
            }
		}
	}];
	
	CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
	myShapeLayer = arr_shapeLayers[index];
	UIBezierPath*patth = polyPaths[index];
	myShapeLayer.path = patth.CGPath;
	myShapeLayer.fillColor = [[UIColor whiteColor] CGColor];
	myShapeLayer.opacity = 0.5;
}

-(void)clearHighlightedPart
{
    //CLEAR ALL!!!
    [polyPaths enumerateObjectsUsingBlock:^(UIBezierPath *obj, NSUInteger idx, BOOL *stop) {
		// clear already highlighted
		for (int i=0; i<[arr_shapeLayers count]; i++) {
			CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
			myShapeLayer = arr_shapeLayers[idx];
			myShapeLayer.path = obj.CGPath;
			myShapeLayer.fillColor = [[UIColor clearColor] CGColor];
			myShapeLayer.opacity = 0.5;
		}
	}];
    for (int j = 0 ; j < [arr_tappedArray count]; j++) {
        CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
        int index = [arr_tappedArray[j] intValue];
        myShapeLayer = arr_shapeLayers[index];
        UIBezierPath *obj = polyPaths[index];
        myShapeLayer.path = obj.CGPath;
        myShapeLayer.fillColor = [[UIColor redColor] CGColor];
        myShapeLayer.opacity = 0.5;
    }
//    [arr_tappedArray removeAllObjects];
//    isTapped = NO;
    
}

-(void)mainMenuTapped:(UIGestureRecognizer*)recognizer
{
	CGPoint touchPoint = [recognizer locationInView: self];
	
	[polyPaths enumerateObjectsUsingBlock:^(UIBezierPath *obj, NSUInteger idx, BOOL *stop) {
		if( [obj containsPoint:touchPoint] ){
			[self pathTappedAtIndex:(int)idx];
			CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
			myShapeLayer = arr_shapeLayers[idx];
			myShapeLayer.path = obj.CGPath;
			myShapeLayer.fillColor = [[UIColor redColor] CGColor];
			myShapeLayer.opacity = 0.5;
			return;
		}
	}];
}
-(void)mainMenuTappedWhitCanceled:(UIGestureRecognizer*)recognizer
{
	CGPoint touchPoint = [recognizer locationInView: self];
	
	[polyPaths enumerateObjectsUsingBlock:^(UIBezierPath *obj, NSUInteger idx, BOOL *stop) {
		if( [obj containsPoint:touchPoint] ){
			[self pathTappedAtIndex:(int)idx];
            [self clearTapped:(int)idx];
            if (isCleared == NO) {
                [self hilitedTapped:(int)idx];
            }
            
        }
	}];
}
-(void)hilitedTapped:(int)idx
{
    CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
    myShapeLayer = arr_shapeLayers[idx];
    UIBezierPath *obj = polyPaths[idx];
    myShapeLayer.path = obj.CGPath;
    

            [arr_tappedArray addObject:[NSNumber numberWithInteger:idx]];
            myShapeLayer.fillColor = [[UIColor redColor] CGColor];
            myShapeLayer.opacity = 0.5;
//            NSLog(@"First tapped!!");
}
-(void)clearTapped:(int)idx
{
    isCleared = NO;
    
    CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
    myShapeLayer = arr_shapeLayers[idx];
    UIBezierPath *obj = polyPaths[idx];
    myShapeLayer.path = obj.CGPath;
    if (isTapped == YES)
    {
//        NSLog(@"The tapped array is %@", arr_tappedArray);
        for (int i = 0; i < [arr_tappedArray count]; i++)
        {
            int index = [arr_tappedArray[i] intValue];
            
            if (idx == index)
            {
                [arr_tappedArray removeObjectAtIndex:i];
                myShapeLayer.fillColor = [[UIColor clearColor] CGColor];
                myShapeLayer.opacity = 0.5;
//                NSLog(@"Tapped before!!!");
                if ([arr_tappedArray count] == 0)
                {
                    isTapped = NO;
                }
                isCleared = YES;
            }
        }
    }
    else
    {
        [arr_tappedArray addObject:[NSNumber numberWithInteger:idx]];
        myShapeLayer.fillColor = [[UIColor redColor] CGColor];
        myShapeLayer.opacity = 0.5;
        isTapped = YES;
//        NSLog(@"should add the obj %@", arr_tappedArray);
        isCleared = YES;
    }
}
#pragma mark - utility
- (UIBezierPath *)buildPath {
    NSArray *coords = [_pathString componentsSeparatedByString:@","];
    UIBezierPath *path = nil;
    if(!path){
        path = [UIBezierPath bezierPath];
        for(NSUInteger i=0;i<coords.count;i++){
            if(i == 1){
                [path moveToPoint:CGPointMake([coords[0] floatValue],[coords[1] floatValue])];
            }else if(i > 1 && i % 2 != 0){
                [path addLineToPoint:CGPointMake([coords[(i-1)] floatValue],[coords[i] floatValue])];
            }
        }
        [path closePath];
    }
	[polyPaths addObject:path];
    return path;
}

	/*
	 USAGE FROM VIEWCONTROLLER
	 
	 #import "YOURViewController.h"
	 #import "embDrawPath.h"
	 
	 @interface YOURViewController () <embDrawPathDelegate>
	 @property (nonatomic, strong) embDrawPath*		embPath;
	 @property (nonatomic, strong) NSMutableArray*	pathsArray;
	 @end
	 
	 @implementation YOURViewController
	 
	 - (void)viewDidLoad
	 {
		 [super viewDidLoad];
		 NSString *path = [[NSBundle mainBundle] pathForResource:@"starMap" ofType:@"plist"];
		 NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
		 
		 NSArray *arr_OfDelays = [[NSArray alloc] initWithObjects:
		 [NSNumber numberWithFloat:1.0f],
		 [NSNumber numberWithFloat:4.0f],
		 nil];
		 
		 _embPath = [[embDrawPath alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
		 _embPath.delegate=self;
		 [self.view insertSubview:_embPath atIndex:0];
	 
		 for (int i=0; i<array.count; i++) {
			 _embPath.pathString = array[i];
			 _embPath.animationSpeed = 5.0f;
			 _embPath.pathStrokeColor = [UIColor blackColor];
			 _embPath.pathCapImage = [UIImage imageNamed:@"arrow.png"];
			 [_pathsArray addObject:_embPath]; // for removal later
			 CGFloat ii = [[arr_OfDelays objectAtIndex:i] floatValue];
			 [_embPath startAnimationFromIndex:i afterDelay:ii];
		 }
	 }

	 */

@end
