//
//  MVMaterialButton.m
//  MVMaterialViewDemo
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "MVMaterialButton.h"

@implementation MVMaterialButton 

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib {
    [self setClipsToBounds:YES];
    [super awakeFromNib];
}

#define initialSize 20

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = [anim valueForKey:@"animationLayer"];
    if (layer) {
        [layer removeAnimationForKey:@"scale"];
        [layer removeFromSuperlayer];
        layer = nil;
        anim = nil;
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    UITouch *aTouch = touch;
    
    CGPoint aPntTapLocation = [aTouch locationInView:self];
    
    CALayer *aLayer = [CALayer layer];
    aLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    aLayer.frame = CGRectMake(0, 0, initialSize, initialSize);
    aLayer.cornerRadius = initialSize / 2;
    aLayer.masksToBounds = YES;
    aLayer.position = aPntTapLocation;
    [self.layer insertSublayer:aLayer below:self.titleLabel.layer];
    
    // Create a basic animation changing the transform.scale value
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // Set the initial and the final values
    [animation
     setToValue:[NSNumber numberWithFloat:(2.5 * MAX(self.frame.size.height,
                                                     self.frame.size.width)) /
                 initialSize]];
    // Set duration
    [animation setDuration:0.6f];
    
    // Set animation to be consistent on completion
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    // Add animation to the view's layer
    
    CAKeyframeAnimation *fade =
    [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fade.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],
                   [NSNumber numberWithFloat:1.0],
                   [NSNumber numberWithFloat:1.0],
                   [NSNumber numberWithFloat:0.5],
                   [NSNumber numberWithFloat:0.0], nil];
    fade.duration = 0.5;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 0.5f;
    animGroup.delegate = self;
    animGroup.animations = [NSArray arrayWithObjects:animation, fade, nil];
    [animGroup setValue:aLayer forKey:@"animationLayer"];
    [aLayer addAnimation:animGroup forKey:@"scale"];
    
    return YES;
}

@end
