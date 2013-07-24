//
//  SetCard.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
@synthesize symbol = _symbol;
@synthesize shading = _shading;
@synthesize color = _color;

#define SYMBOL_DIAMOND 1
#define SYMBOL_SQUIGGLE 2
#define SYMBOL_OVAL 3

#define SHADING_SOLID 1
#define SHADING_STRIPED 2
#define SHADING_OPEN 3

#define COLOR_RED 1
#define COLOR_GREEN 2
#define COLOR_PURPLE 3

+ (NSArray *)validShading
{
    static NSArray *validShading = nil;
    if (!validShading) validShading = @[@(SHADING_SOLID), @(SHADING_STRIPED), @(SHADING_OPEN)];
    return validShading;
}

+ (NSArray *)validSymbol
{
    static NSArray *validSymbol = nil;
    if (!validSymbol) validSymbol = @[@(SYMBOL_DIAMOND), @(SYMBOL_SQUIGGLE), @(SYMBOL_OVAL)];
    return validSymbol;
}

+ (NSArray *)validColor
{
    static NSArray *validColor = nil;
    if (!validColor) validColor = @[@(COLOR_RED), @(COLOR_GREEN), @(COLOR_PURPLE)];
    return  validColor;
}

+ (NSInteger)maxNumber
{
    return 3;
}

#pragma mark - setter and getter

- (void)setSymbol:(NSUInteger)symbol
{
    if ([[SetCard validSymbol] containsObject:@(symbol)])
    {
        _symbol = symbol;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber])
    {
        _number = number;
    }
}

- (void)setShading:(NSUInteger)shading
{
    if ([[SetCard validShading] containsObject:@(shading)])
    {
        _shading = shading;
    }
}

- (NSUInteger)shading
{
    return _shading ? _shading : [[[SetCard validShading] lastObject] unsignedIntegerValue];
}

- (void)setColor:(NSUInteger)color
{
    if ([[SetCard validColor] containsObject:@(color)])
    {
        _color = color;
    }
}

- (NSUInteger)color
{
    return _color ? _color : [[[SetCard validColor] lastObject] unsignedIntegerValue];
}

#pragma mark - public method
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    //Only trigger match if compared with two other cards
    if ([otherCards count] == 2)
    {
        SetCard *card1 = [otherCards objectAtIndex:0];
        SetCard *card2 = [otherCards objectAtIndex:1];
        
        //Check number
        if ((card1.number == card2.number && self.number == card1.number)
            ||
            (card1.number != card2.number && self.number != card1.number && self.number != card2.number))
        {
            //Check symbol
            int symbolSetCount = [[NSSet setWithObjects:@(self.symbol), @(card1.symbol), @(card2.symbol), nil] count];
            if (symbolSetCount == 3 || symbolSetCount == 1)
            {
                //Check shading
                int shadingCount = [[NSSet setWithObjects:@(self.shading), @(card1.shading), @(card2.shading), nil] count];
                if (shadingCount == 3 || shadingCount == 1)
                {
                    //Check color
                    int colorCount = [[NSSet setWithObjects:@(self.color), @(card1.color), @(card2.color), nil] count];
                    if (colorCount == 3 || colorCount == 1)
                    {
                        score = 4;
                    }
                }
            }
        }
    }
    
    return score;
}

@end
