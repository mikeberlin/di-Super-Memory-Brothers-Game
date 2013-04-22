//
//  PlayingCard.h
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/17/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayingCard : NSObject

@property (nonatomic) NSString *Value;
@property (nonatomic) NSString *ImagePath;

@property (nonatomic) BOOL IsFaceUp;
@property (nonatomic) BOOL WasPlayed;

- (id)initValue:(NSString *)value withImagePath:(NSString *)imgPath;

+ (NSDictionary *)Cards;

@end