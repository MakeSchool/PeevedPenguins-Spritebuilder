//
//  WaitingPenguin.m
//  PeevedPenguins
//
//  Created by Benjamin Encz on 21/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WaitingPenguin.h"

@implementation WaitingPenguin

- (void)didLoadFromCCB
{
    float delay = (arc4random() % 2000) / 1000.f;
    
    [self performSelector:@selector(startBlinkAndJump) withObject:nil afterDelay:delay];
}

- (void)startBlinkAndJump
{
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"BlinkAndJump"];
}

@end
