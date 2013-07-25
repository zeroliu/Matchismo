//
//  CardGame.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "CardGame.h"

@interface CardGame()
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite, getter = hasGameStarted) BOOL gameStarted;
@property (nonatomic, readwrite) NSUInteger cardsToMatch;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readonly) Deck *deck;
@end

@implementation CardGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)cardsFlipped
{
    if (!_cardsFlipped) _cardsFlipped = [[NSMutableArray alloc] init];
    return _cardsFlipped;
}

- (int)cardsInPlay
{
    return self.cards.count;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck cardsToMatch:(NSUInteger)cardsToMatch
{
    self = [super init];
    
    if (self)
    {
        _gameStarted = NO;
        _cardsToMatch = cardsToMatch;
        _deck = deck;
        for (int i = 0; i < cardCount; i++)
        {
            Card *card = [self.deck drawRandomCard];
            if (!card)
            {
                self = nil;
                break;
            }
            else
            {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count] ? self.cards[index] : nil);
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    if (index >= [self.cards count]) return;
    [self.cards removeObjectAtIndex:index];
}

- (NSArray *)dealCardsWithNumber:(NSUInteger)cardNum
{
    NSMutableArray *addedCardsIndexes = [[NSMutableArray alloc] initWithCapacity:cardNum];
    for (int i = 0; i<cardNum; i++)
    {
        Card *card = [self.deck drawRandomCard];
        if (!card)
        {
            //run out of cards
            break;
        }
        else
        {
            [self.cards addObject:card];
            [addedCardsIndexes addObject:@([self.cards indexOfObject:card])];
        }
    }
    
    return addedCardsIndexes;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
- (void) flipCardAtIndex:(NSUInteger)index
{
    self.gameStarted = YES;
    Card *card = [self cardAtIndex:index];
    
    [self.cardsFlipped removeAllObjects];
    self.scoreChanged = 0;
    
    if (!card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            //Check if flipping this card up creates a match
            NSMutableArray *otherCardList = [[NSMutableArray alloc] initWithCapacity:self.cardsToMatch-1];
            
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [self.cardsFlipped addObject:otherCard];
                    
                    [otherCardList addObject:otherCard];
                    if ([otherCardList count] >= self.cardsToMatch - 1)
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
                            self.scoreChanged = matchScore * MATCH_BONUS;
                        }
                        else
                        {
                            for (Card *misMatchedCard in otherCardList)
                            {
                                misMatchedCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            self.scoreChanged = -MISMATCH_PENALTY;
                        }
                    }
                }
            }
            
            self.score -= FLIP_COST;
            self.scoreChanged -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
        if (card.isFaceUp) [self.cardsFlipped addObject:card];
    }
}


@end
