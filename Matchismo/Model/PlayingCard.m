//
//  PlayingCard.m
//  Matchismo
//
//  Created by Xiyuan Liu on 6/25/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit; // because we provide setter and getter

#pragma mark - class method

+ (NSArray *) validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♠",@"♣",@"♥",@"♦"];
    return validSuits;
}

+ (NSArray *) rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}

+ (NSUInteger) maxRank
{
    return [self rankStrings].count - 1;
}

#pragma mark - setter and getter

- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void) setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *) suit
{
    return _suit ? _suit : @"?";
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

#pragma mark - public method
- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit])
        {
            score = 1;
        }
        else if (otherCard.rank == self.rank)
        {
            score = 4;
        }
    }
    else if ([otherCards count] == 2)
    {
        int matchingType = 0; //1 suit match, 2 rank match
        for (PlayingCard *card in otherCards)
        {
            if ((matchingType == 0 || matchingType == 1) && [card.suit isEqualToString:self.suit])
            {
                matchingType = 1;
            }
            else if ((matchingType == 0 || matchingType == 2) && card.rank == self.rank)
            {
                matchingType = 2;
            }
            else
            {
                matchingType = 0;
                break;
            }
        }

        if (matchingType == 1)
        {
            score = 2;
        }
        else if (matchingType == 2)
        {
            score = 8;
        }
    }
    
    return score;
}

@end
