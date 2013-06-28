//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Xiyuan Liu on 6/27/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
@interface CardMatchingGame : NSObject

//Designated initializer
- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

- (void) flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *status;

@end
