//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Xiyuan Liu on 6/27/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *status;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSUInteger matchNumber;
@end

@implementation CardMatchingGame

- (NSMutableArray *) cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < cardCount; i++)
        {
            Card *card = [deck drawRandomCard];
            if (!card)
            {
                self = nil;
            }
            else
            {
                self.cards[i] = card;
            }
        }
        self.status = @"Game Start!";
        self.matchNumber = 3;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count] ? self.cards[index] : nil);
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
- (void) flipCardAtIndex:(NSUInteger)index
{
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
