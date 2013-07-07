//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Xiyuan Liu on 6/27/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardGame()
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *status;
@property (nonatomic, readwrite, getter = hasGameStarted) BOOL gameStarted;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@interface CardMatchingGame()
@property (nonatomic) NSUInteger matchNumber;
@end

@implementation CardMatchingGame

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super initWithCardCount:cardCount usingDeck:deck];
    
    if (self)
    {
        _matchNumber = 2;
    }
    
    return self;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
- (void) flipCardAtIndex:(NSUInteger)index
{
    self.gameStarted = YES;
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            BOOL matchHappened = NO;
            //Check if flipping this card up creates a match
            NSMutableArray *otherCardList = [[NSMutableArray alloc] initWithCapacity:self.matchNumber-1];

            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [otherCardList addObject:otherCard];
                    if ([otherCardList count] >= self.matchNumber - 1)
                    {
                        int matchScore = [card match:otherCardList];
                        if (matchScore)
                        {
                            for (Card *matchedCard in otherCardList)
                            {
                                matchedCard.unplayable = YES;
                            }
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.status = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card.contents, [otherCardList componentsJoinedByString:@" & "], matchScore * MATCH_BONUS];
                        }
                        else
                        {
                            for (Card *misMatchedCard in otherCardList)
                            {
                                misMatchedCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            self.status = [NSString stringWithFormat:@"%@ & %@ don't match! %d points penalty!", card.contents, [otherCardList componentsJoinedByString:@" & "], MISMATCH_PENALTY];
                        }
                        matchHappened = YES;
                    }
                }
            }
            
            if (!matchHappened)
            {
                self.status = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (void) turnOnThreeMatchMode:(BOOL)isOn
{
    self.matchNumber = isOn ? 3 : 2;
}

@end
