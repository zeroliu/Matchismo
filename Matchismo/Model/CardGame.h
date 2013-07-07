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
- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;
- (Card *)cardAtIndex:(NSUInteger)index;

//Needs to be implemented by its subclass
- (void) flipCardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *status;
@property (nonatomic, readonly) BOOL gameStarted;

@end
