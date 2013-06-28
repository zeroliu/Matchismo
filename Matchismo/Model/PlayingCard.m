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
    
    return score;
}

@end