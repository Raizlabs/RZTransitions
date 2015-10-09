//
//  RZZoomFromPointAnimationController.m
//  RZTransitions-Demo
//
//  Created by Jameel Khan on 15/07/2015.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "RZZoomFromPointAnimationController.h"

#define kRZPushTransitionTime 0.35

#define kRZCoverViewMinSize 5





@implementation RZZoomFromPointAnimationController


@synthesize isPositiveAnimation = _isPositiveAnimation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    
    
    
    //we are presenting
    if (self.isPositiveAnimation)
    {
    
        //this is the cover view that comes on top of all
        UIView *coverView= [[UIView alloc] initWithFrame:CGRectMake(container.bounds.size.width*self.origin.x-kRZCoverViewMinSize/2,
                                                                    container.bounds.size.height*self.origin.y-kRZCoverViewMinSize/2,
                                                                    kRZCoverViewMinSize, kRZCoverViewMinSize)];
        coverView.layer.cornerRadius=kRZCoverViewMinSize/2;
        coverView.clipsToBounds= YES;
        coverView.backgroundColor= self.color;
        
        
        //insert the coverview on top
        [container insertSubview:coverView aboveSubview:fromViewController.view];
        
        
        //animate the cover view
        [UIView animateWithDuration:kRZPushTransitionTime animations:^{
           
            coverView.transform = CGAffineTransformMakeScale(1000,1000);

            
        } completion:^(BOOL finished) {
            
            
            //insert the target view under this cover view
            [container insertSubview:toViewController.view belowSubview:coverView];
            
            //this makes sure our contraints are reset and updated
            toViewController.view.frame= container.bounds;
            
            [toViewController viewWillAppear:YES];
            
            
            //now remove the coverView via fad
            [UIView animateWithDuration:0.2 animations:^{
                
                coverView.alpha=0.0;
                
            } completion:^(BOOL finished) {
               
                
                [coverView removeFromSuperview];
                
                //transition completed
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
            
            
            
        }];
        
        
    }
    
    
    
    //dismiss
    else
    {

        //this is the cover view that comes on top of all
        UIView *coverView= [[UIView alloc] initWithFrame:CGRectMake(container.bounds.size.width*self.origin.x-kRZCoverViewMinSize/2,
                                                                    container.bounds.size.height*self.origin.y-kRZCoverViewMinSize/2,
                                                                    kRZCoverViewMinSize, kRZCoverViewMinSize)];
        coverView.layer.cornerRadius=kRZCoverViewMinSize/2;
        coverView.clipsToBounds= YES;
        coverView.backgroundColor= self.color;
        coverView.transform = CGAffineTransformMakeScale(1000,1000);
        coverView.alpha=0.0;
        
        
        //add to main container
        [container insertSubview:coverView aboveSubview:fromViewController.view];
        
        
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             coverView.alpha=1.0;
                             
                             
                         }
                         completion:^(BOOL finished) {
                             
                             
                             
                             //insert the target view
                             [container insertSubview:toViewController.view belowSubview:coverView];
                             [toViewController viewWillAppear:YES];
                             
                             [UIView animateWithDuration:kRZPushTransitionTime animations:^{
                                 
                                 coverView.transform = CGAffineTransformMakeScale(1,1);
                                 
                             } completion:^(BOOL finished) {
                                 [coverView removeFromSuperview];
                                 
                                 //this makes sure our contraints are reset and updated
                                 toViewController.view.frame= container.bounds;
                                 
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                                 
                             }];
                             
                             
                         }];
        
        
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZPushTransitionTime;
}

@end
