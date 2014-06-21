//
//  WaitingPenguin.m
//  PeevedPenguins
//
//  Created by Benjamin Encz on 21/01/14.
//  Copyright (c) 2014 MakeGamesWithUs inc. Free to use for all purposes.
//

#import "WaitingPenguin.h"

@implementation WaitingPenguin

- (void)didLoadFromCCB {
  // generate a random number between 0.0 and 2.0
  float delay = (arc4random() % 2000) / 1000.f;
  // call method to start animation after random delay
  [self performSelector:@selector(startBlinkAndJump) withObject:nil afterDelay:delay];
}

- (void)startBlinkAndJump {
  // the animation manager of each node is stored in the 'userObject' property
  CCAnimationManager *animationManager = self.animationManager;
  // timelines can be referenced and run by name
  [animationManager runAnimationsForSequenceNamed:@"BlinkAndJump"];
}

@end
