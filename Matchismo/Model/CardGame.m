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
@property (nonatomic, readwrite) NSString *status;
@property (nonatomic, readwrite, getter = hasGameStarted) BOOL gameStarted;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardGame

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
        _status = @"Game Start!";
        _gameStarted = NO;
        for (int i = 0; i < cardCount; i++)
        {
            Card *card = [deck drawRandomCard];
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

- (void) flipCardAtIndex:(NSUInteger)index
{
    NSLog(@"Implement this method in subclass");
}


@end
