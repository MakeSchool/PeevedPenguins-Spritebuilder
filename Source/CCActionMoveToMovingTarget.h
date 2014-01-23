//
//  CCActionMoveToMovingTarget.h
//  PeevedPenguins
//
//  Created by Benjamin Encz on 22/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCActionInterval.h"

@interface CCActionMoveToMovingTarget : CCAction

typedef CGPoint(^PositionUpdateBlock)(void);

+ (id) actionWithSpeed: (CGFloat) s position: (CGPoint) p positionUpdateBlock:(PositionUpdateBlock) block;
+ (id) actionWithSpeed: (CGFloat)s targetNode:(CCNode *)t;

- (id) initWithSpeed: (CGFloat)s position: (CGPoint)p positionUpdateBlock:(PositionUpdateBlock) block;
- (id) initWithSpeed: (CGFloat)s targetNode:(CCNode *)t;

@end