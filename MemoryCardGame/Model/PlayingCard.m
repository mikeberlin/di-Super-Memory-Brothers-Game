//
//  PlayingCard.m
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/17/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

#pragma mark - Constructors

- (id)initValue:(NSString *)value withImagePath:(NSString *)imgPath
{
    self = [super init];
    
    if (self) {
        self.Value = value;
        self.ImagePath = imgPath;
        self.IsFaceUp = NO;
        self.WasPlayed = NO;
    }

    return self;
}

#pragma mark - Public Properties

+ (NSDictionary *)Cards {
    return @{
                 @"1Up" : @"1up.png",
                 @"Mushroom" : @"Mushroom.png",
                 @"Flower" : @"Flower.png",
                 @"Star" : @"Star.png",
                 @"Koopa" : @"Koopa.png",
                 @"Coin" : @"Coin.png"
             };
}

@end