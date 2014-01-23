/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2014 MakeGamesWithUs Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCActionMoveToMovingTarget.h"

@implementation CCActionMoveToMovingTarget {
    // speed of the movement in points/seconds
    CGFloat _speed;
    // variable to determine if this action is completed
    BOOL _done;
    // block that provides target position
    PositionUpdateBlock _positionUpdateBlock;
    // node that shall be followed
    CCNode *_targetNode;
    // defines wether a node should follow the target infinitely; or stop once the target position is reached
    BOOL _followInfinite;
}

#pragma mark - Initializers

+ (id)actionWithSpeed:(CGFloat)speed positionUpdateBlock:(PositionUpdateBlock)block followInfinite:(BOOL)infinite
{
    return [[self alloc] initWithSpeed:speed positionUpdateBlock:block followInfinite:infinite];
}

+ (id)actionWithSpeed:(CGFloat)speed positionUpdateBlock:(PositionUpdateBlock)block
{
    return [[self alloc] initWithSpeed:speed positionUpdateBlock:block];
}

+ (id)actionWithSpeed:(CGFloat)speed targetNode:(CCNode *)targetNode followInfinite:(BOOL)infinite
{
    return [[self alloc] initWithSpeed:speed targetNode:targetNode followInfinite:infinite];
}

+ (id)actionWithSpeed:(CGFloat)speed targetNode:(CCNode *)targetNode
{
    return [[self alloc] initWithSpeed:speed targetNode:targetNode];
}

- (id)initWithSpeed:(CGFloat)speed positionUpdateBlock:(PositionUpdateBlock)block followInfinite:(BOOL)infinite {
    self = [super init];
    
    if (self) {
        _positionUpdateBlock = block;
        _speed = speed;
        _followInfinite = infinite;
    }
    
    return self;
}

- (id)initWithSpeed:(CGFloat)speed positionUpdateBlock:(PositionUpdateBlock)block
{
    return [self initWithSpeed:speed positionUpdateBlock:block followInfinite:NO];
}

- (id)initWithSpeed:(CGFloat)speed targetNode:(CCNode *)targetNode followInfinite:(BOOL)infinite {
    self = [super init];
    
    if (self) {
        _targetNode = targetNode;
        _speed = speed;
        _followInfinite = infinite;
    }
    
    return self;
}

- (id)initWithSpeed:(CGFloat)speed targetNode:(CCNode *)targetNode
{
    return [self initWithSpeed:speed targetNode:targetNode followInfinite:NO];
}

#pragma mark - NSCopying

-(id) copyWithZone: (NSZone*) zone
{
    CCAction *copy = nil;
    
    if (_targetNode) {
        copy = [[[self class] allocWithZone: zone] initWithSpeed:_speed targetNode:_targetNode];
    } else {
        copy = [[[self class] allocWithZone: zone] initWithSpeed:_speed positionUpdateBlock:_positionUpdateBlock];
    }
    
	return copy;
}

#pragma mark - CCAction override

- (void)step:(CCTime)dt
{
    CGPoint endPosition = CGPointZero;
    
    if (_positionUpdateBlock) {
        endPosition = _positionUpdateBlock();
    }  else if (_targetNode) {
        CGPoint worldPos = [_targetNode.parent convertToWorldSpace:_targetNode.position];
        endPosition = [[(CCNode*)_target parent] convertToNodeSpace:worldPos];
    } 
    
    CCLOG(@"position x:%f y:%f   ;;;; Target position: x:%f y:%f", [(CCNode*)_target position].x, [(CCNode*)_target position].y, endPosition.x, endPosition.y);
    
    CGPoint positionDelta = ccpSub(endPosition, [(CCNode*)_target position]);
    
    CCNode *node = (CCNode*)_target;
    
	CGPoint currentPos = [node position];
    CGPoint normalizedDiff = ccpNormalize(positionDelta);
    CGPoint moveBy = ccpMult(normalizedDiff, (dt * _speed));
    
    CGPoint newPos =  ccpAdd(currentPos, moveBy);
    
    // if moveBy > diff, set position to target position
    CGFloat moveByLength = ccpLength(moveBy);
    CGFloat distanceTargetLength = ccpLength(positionDelta);
    
    if (moveByLength > distanceTargetLength) {
        if (!_followInfinite) {
            _done = YES;
        }
        
        newPos = endPosition;
    }
	[_target setPosition: newPos];
}

- (BOOL) isDone
{
	return _done;
}

@end