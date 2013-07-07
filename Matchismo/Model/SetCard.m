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

+ (NSArray *)validShading
{
    static NSArray *validShading = nil;
    if (!validShading) validShading = @[@"FULL", @"HALF", @"EMPTY"];
    return validShading;
}

+ (NSArray *)validSymbol
{
    static NSArray *validSymbol = nil;
    if (!validSymbol) validSymbol = @[@"▲",@"●",@"■"];
    return validSymbol;
}

+ (NSArray *)validColor
{
    static NSArray *validColor = nil;
    if (!validColor) validColor = @[@"Red",@"Green",@"Blue"];
    return  validColor;
}

+ (NSInteger)maxNumber
{
    return 3;
}

#pragma mark - setter and getter

- (NSString *)contents
{
    NSString *result = @"";
    for (int i=0; i<self.number; i++)
    {
        result = [result stringByAppendingString:self.symbol];
    }
    return result;
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbol] containsObject:symbol])
    {
        _symbol = symbol;
    }
}

- (NSString *) symbol
{
    return _symbol ? _symbol : @"?";
}

- (void)setNumber:(NSInteger)number
{
    if (number <= [SetCard maxNumber])
    {
        _number = number;
    }
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShading] containsObject:shading])
    {
        _shading = shading;
    }
}

- (NSString *)shading
{
    return _shading ? _shading : [[SetCard validShading] lastObject];
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColor] containsObject:color])
    {
        _color = color;
    }
}

- (NSString *)color
{
    return _color ? _color : [[SetCard validColor] lastObject];
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
            int symbolSetCount = [[NSSet setWithObjects:self.symbol, card1.symbol, card2.symbol, nil] count];
            if (symbolSetCount == 3 || symbolSetCount == 1)
            {
                //Check shading
                int shadingCount = [[NSSet setWithObjects:self.shading, card1.shading, card2.shading, nil] count];
                if (shadingCount == 3 || shadingCount == 1)
                {
                    //Check color
                    int colorCount = [[NSSet setWithObjects:self.color, card1.color, card2.color, nil] count];
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
