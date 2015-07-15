//
//  RZZoomFromPointAnimationController.h
//  RZTransitions-Demo
//
//  Created by Jameel Khan on 15/07/2015.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZAnimationControllerProtocol.h"

@interface RZZoomFromPointAnimationController : NSObject <RZAnimationControllerProtocol>


@property (nonatomic, readwrite) CGPoint origin; /*in 0-1 ranges*/
@property (nonatomic, strong) UIColor *color;



@end
