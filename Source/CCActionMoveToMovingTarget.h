//
//  CCActionMoveToMovingTarget.h
//  PeevedPenguins
//
//  Created by Benjamin Encz on 22/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCActionInterval.h"

@class CCActionMoveToMovingTarget;

@protocol CCActionMoveToMovingTargetDelegate

- (CGPoint)targetPointForActionMovingTarget:(CCActionMoveToMovingTarget *)actionMovingTarget;

@end

@interface CCActionMoveToMovingTarget : CCAction

@property (nonatomic, assign) id<CCActionMoveToMovingTargetDelegate> delegate;

+(id) actionWithSpeed: (CGFloat) s position: (CGPoint) p;
-(id) initWithSpeed: (CGFloat) s position: (CGPoint) p;

@end
