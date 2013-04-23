//
//  CardGame.h
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/17/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

@interface CardGame : NSObject

@property (strong, nonatomic) NSArray *PlayingCards; // PlayingCard
@property (nonatomic) BOOL GameWon;
@property (nonatomic) NSUInteger NumberOfGuesses;
@property (nonatomic) NSUInteger NumberOfMatches;

@property (strong, nonatomic) NSTimer *PollingTimer;
@property (strong, nonatomic) NSDateFormatter *DateFormatter;
@property (strong, nonatomic) NSDate *StartTimer;

+ (NSMutableArray *)LoadHighScores;

- (id)init;
- (BOOL)flipCardAtIndex:(NSUInteger)index;
- (PlayingCard *)cardAtIndex:(NSUInteger)index;
- (double)lengthOfPollingTimer;

- (BOOL)isHighScore:(NSTimeInterval)playersTime;
- (void)savePlayersTimeToHighScores:(NSTimeInterval)playersTime withName:(NSString *)playersName;
- (NSString *)getTimerTimeString;
- (NSTimeInterval)getTimerTimeInterval;

@end