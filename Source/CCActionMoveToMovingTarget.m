//
//  CCActionMoveToMovingTarget.m
//  PeevedPenguins
//
//  Created by Benjamin Encz on 22/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCActionMoveToMovingTarget.h"

@implementation CCActionMoveToMovingTarget {
    CGFloat _speed;
    CGPoint _endPosition;
    CGPoint _previousPos;
    CGPoint _positionDelta;
    CGPoint _startPos;
    BOOL _done;
}

+(id) actionWithSpeed: (CGFloat) s position: (CGPoint) p
{
	return [[self alloc] initWithSpeed:s position:p ];
}

-(id) initWithSpeed: (CGFloat) s position: (CGPoint) p
{
	if( (self=[super init]) ) {
		_endPosition = p;
        _speed = s;
    }
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithSpeed:_speed position: _endPosition];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	_positionDelta = ccpSub( _endPosition, [(CCNode*)_target position] );
}


- (void)step:(CCTime)dt
{
    CGPoint endPosition = [self.delegate targetPointForActionMovingTarget:self];
    _positionDelta = ccpSub(endPosition, [(CCNode*)_target position]);
    
    CCLOG(@"position x:%f y:%f   ;;;; Target position: x:%f y:%f", [(CCNode*)_target position].x, [(CCNode*)_target position].y, endPosition.x, endPosition.y);
    
    
    CCNode *node = (CCNode*)_target;
    
	CGPoint currentPos = [node position];
    CGPoint normalizedDiff = ccpNormalize(_positionDelta);
    CGPoint moveBy = ccpMult(normalizedDiff, (dt * _speed));
    
    CGPoint newPos =  ccpAdd(currentPos, moveBy);
    
    // if moveBy > diff, set position to target position
    CGFloat moveByLength = ccpLength(moveBy);
    CGFloat distanceTargetLength = ccpLength(_positionDelta);
    
    if (moveByLength > distanceTargetLength) {
        _done = YES;
        newPos = endPosition;
    }
	[_target setPosition: newPos];
}

- (BOOL) isDone
{
	return _done;
}


@end