//
//  CardGame.h
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
@interface CardGame : NSObject

//Designated initializer
- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck cardsToMatch:(NSUInteger)cardsToMatch;
- (Card *)cardAtIndex:(NSUInteger)index;

- (void)flipCardAtIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;
- (NSArray *)dealCardsWithNumber:(NSUInteger)cardNum; //return indicates if there are more cards in the deck

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) BOOL gameStarted;
@property (nonatomic, readonly) NSUInteger cardsToMatch;
@property (nonatomic, strong) NSMutableArray *cardsFlipped;
@property (nonatomic) int scoreChanged;
@property (nonatomic) int cardsInPlay;
@end
