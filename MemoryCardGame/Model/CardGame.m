//
//  CardGame.m
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/17/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import "CardGame.h"
#import "PlayingCard.h"

#define NUM_CARDS_IN_GAME 12
#define kPollingInterval 1.0
#define HIGHSCORE_NAME_KEY @"Name"
#define HIGHSCORE_TIME_KEY @"Time"

@implementation CardGame

#pragma mark - Constructors

-(id)init
{
    self = [super init];
    
    if (self) {
        self.playingCards = [self shuffleUpAndDeal];
        self.NumberOfGuesses = 0;
        self.GameWon = NO;
        self.StartTimer = [NSDate date];

        self.DateFormatter = [[NSDateFormatter alloc] init];
        [self.DateFormatter setDateFormat:@"mm:ss"];
    }

    return self;
}

#pragma mark - Public Messages

+ (NSMutableArray *)LoadHighScores
{
    return [NSMutableArray arrayWithContentsOfFile:[self getHighScoresPropertyListPath]];
}

+ (void)SaveHighScores:(NSArray *)highScores
{
    [highScores writeToFile:[self getHighScoresPropertyListPath] atomically:YES];
}

+ (NSString *)getHighScoresPropertyListPath
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) lastObject];
    NSString *plistDocsPath = [rootPath stringByAppendingPathComponent:@"HighScores.plist"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:plistDocsPath])
    {
        NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"HighScores" ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:plistBundlePath toPath:plistDocsPath error:Nil];
    }

    return plistDocsPath;
}

- (PlayingCard *)cardAtIndex:(NSUInteger)index
{
    return (index < self.PlayingCards.count) ? [self.PlayingCards objectAtIndex:index] : nil;
}

- (BOOL)flipCardAtIndex:(NSUInteger)index
{
    BOOL matchMade = NO;
    int numPlayedCards = 0;
    PlayingCard *card = [self cardAtIndex:index];

    if (!card.WasPlayed) {
        if (!card.IsFaceUp) {

            for (PlayingCard *otherCard in self.PlayingCards) {

                if (otherCard.IsFaceUp && !otherCard.WasPlayed) {

                    if (card.Value == otherCard.Value) {
                        card.WasPlayed = YES;
                        otherCard.WasPlayed = YES;
                        matchMade = YES;
                    }
                    else {
                        otherCard.IsFaceUp = NO;
                        self.GameWon = NO;
                    }
                }
		
                if (otherCard.WasPlayed) numPlayedCards++;
            }
        }
        card.IsFaceUp = YES;
    }

    if (numPlayedCards == [self.PlayingCards count]) self.GameWon = YES;
    return matchMade;
}

- (BOOL)isHighScore:(NSTimeInterval)playersTime
{
    BOOL isHighScore = NO;
    NSLog(@"TimeInterval %f", playersTime);
    
    for (NSDictionary *highScore in [CardGame LoadHighScores]) {
        NSTimeInterval tiHighScore = [[NSString stringWithFormat:@"%@", [highScore objectForKey:@"Time"]] doubleValue];

        isHighScore = (playersTime < tiHighScore);
        if (isHighScore) break;
    }

    return isHighScore;
}

- (void)savePlayersTimeToHighScores:(NSTimeInterval)playersTime withName:(NSString *)playersName
{
    NSMutableDictionary *playerScore = [[NSMutableDictionary alloc] init];
    [playerScore setValue:playersName forKey:HIGHSCORE_NAME_KEY];
    [playerScore setValue:[NSNumber numberWithDouble:playersTime] forKey:HIGHSCORE_TIME_KEY];

    NSMutableArray *highScores = [CardGame LoadHighScores];
    [highScores addObject:playerScore];

    NSLog(@"Array of Dictionaries: %@", highScores);

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:HIGHSCORE_TIME_KEY ascending:YES];

    //NSMutableArray *sortedHighScores = [[highScores sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];

    //NSLog(@"Sorted Array of Dictionaries: %@", sortedHighScores);

    //highScores = [NSMutableArray arrayWithArray:sortedHighScores];

    [CardGame SaveHighScores:highScores];
}

- (NSString *)getTimerTimeString
{
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[self getTimerTimeInterval]];
    return [self.DateFormatter stringFromDate:timerDate];
}

- (NSTimeInterval)getTimerTimeInterval
{
    NSDate *currentTime = [NSDate date];
    return [currentTime timeIntervalSinceDate:self.StartTimer];
}

- (double)lengthOfPollingTimer
{
    return kPollingInterval;
}

#pragma mark - Private Messages

-(NSArray *)shuffleUpAndDeal
{
    // add the available card to the deck twice to make sure there's always a matching card
    NSMutableArray *cardsInDeck = [[NSMutableArray alloc] init];
    for (NSString *card in [PlayingCard Cards]) {
        [cardsInDeck addObject:[[PlayingCard alloc] initValue:card withImagePath:[[PlayingCard Cards] objectForKey:card]]];
        [cardsInDeck addObject:[[PlayingCard alloc] initValue:card withImagePath:[[PlayingCard Cards] objectForKey:card]]];
    }

    // shuffle up the array to mix up the cards
    NSUInteger count = [cardsInDeck count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [cardsInDeck exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

    return cardsInDeck;
}

@end