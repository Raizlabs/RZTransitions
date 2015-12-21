//
//  RZAnimationControllerProtocol.h
//  RZTransitions
//
//  Created by Haidery on 21/12/15.
//  Copyright 2014 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
