//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Benjamin Encz on 16/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCNode* _levelNode;
}

- (void)didLoadFromCCB {
    [_levelNode addChild:[CCBReader load:@"Levels/Level1"]];
}

@end
