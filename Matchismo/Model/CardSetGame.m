//
//  CardSetGame.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "CardSetGame.h"

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

@interface CardGame()
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *status;
@property (nonatomic, readwrite, getter = hasGameStarted) BOOL gameStarted;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@interface CardSetGame()
@end

@implementation CardSetGame

- (void) flipCardAtIndex:(NSUInteger)index
{
    self.gameStarted = YES;
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            BOOL matchHappened = NO;
            NSMutableArray *otherCardList = [[NSMutableArray alloc] initWithCapacity:2];
            
            for (Card *otherCard in self.cards)
            {
                if (!otherCard.isUnplayable && otherCard.isFaceUp)
                {
                    [otherCardList addObject:otherCard];
                    if ([otherCardList count] == 2)
                    {
                        int matchScore = [card match:otherCardList];
                        if (matchScore)
                        {
                            //Match successful
                            for (Card *matchedCard in otherCardList)
                            {
                                matchedCard.unplayable = YES;
                            }
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.status = @"match successful!";
                        }
                        else
                        {
                            //Mismatch
                            for (Card *mismatchedCard in otherCardList)
                            {
                                mismatchedCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            self.status = @"mismatch!";
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

@end
