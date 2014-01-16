//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Benjamin Encz on 16/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCNode *_levelNode;
    CCNode *_catapultArm;
    CCNode *_catapult;
    CCPhysicsNode *_physicsNode;
    
    CCPhysicsJoint *_catapultJoint;
    CCPhysicsJoint *_pullbackSpring;
    CCPhysicsJoint *_mouseSpring;

    CCPhysicsJoint *_penguinCatapultJoint;

    CCNode *_pullbackNode;
    CCNode *_mouseJointNode;
    
    CCNode *_contentNode;
    
    CCNode *_currentPenguin;
}

- (void)didLoadFromCCB {
    _physicsNode.debugDraw = TRUE;
    [_levelNode addChild:[CCBReader load:@"Levels/Level1"]];
    
    _pullbackNode.physicsBody.collisionMask = @[];
    _mouseJointNode.physicsBody.collisionMask = @[];
    
    // set up some joints
//    catapultJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_catapultArm.physicsBody bodyB:_catapult.physicsBody anchorA:ccp(_catapultArm.contentSize.width/2, 0) anchorB:ccp(_catapult.contentSize.width/2, 0.7 * _catapult.contentSize.height) restLength:0.01f stiffness:2000 damping:200];
    
    _catapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_catapultArm.physicsBody bodyB:_catapult.physicsBody anchorA:_catapultArm.anchorPointInPoints];
    
    _pullbackSpring = [CCPhysicsJoint connectedSpringJointWithBodyA:_pullbackNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:60.f stiffness:500.f damping:40.f];
    
    self.userInteractionEnabled = TRUE;
}

- (void)launchPenguin {
    CCNode* penguin = [CCBReader load:@"Penguin"];
    penguin.position = ccpAdd(_catapultArm.position, ccp(40, 115));
    
    [_physicsNode addChild:penguin];
    
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    
    [penguin.physicsBody applyForce:force];
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}

- (void)retry {
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation))
    {
        _mouseJointNode.position = touchLocation;
        _mouseSpring = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:0.f stiffness:2000.f damping:150.f];
        
        _currentPenguin = [CCBReader load:@"Penguin"];
        _currentPenguin.position = ccpAdd(_catapultArm.position, ccp(34, 138));
        [_physicsNode addChild:_currentPenguin];
        
        _currentPenguin.physicsBody.allowsRotation = FALSE;
        
        CCActionFollow *follow = [CCActionFollow actionWithTarget:_currentPenguin worldBoundary:self.boundingBox];
        [_contentNode runAction:follow];
        
        _penguinCatapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_catapultArm.physicsBody bodyB:_currentPenguin.physicsBody anchorA:ccp(34, 138)];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    _mouseJointNode.position = touchLocation;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self releaseCatapult];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self releaseCatapult];
}

- (void)releaseCatapult {
    if (_mouseSpring != nil)
    {
        _currentPenguin.physicsBody.allowsRotation = TRUE;
        
        [_penguinCatapultJoint invalidate];
        _penguinCatapultJoint = nil;
        
        [_mouseSpring invalidate];
        _mouseSpring = nil;
    }
}

@end
