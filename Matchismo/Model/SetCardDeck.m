//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"
@implementation SetCardDeck

- (id)init
{
    self = [super init];
    if (self)
    {
        for (NSString *symbol in [SetCard validSymbol])
        {
            for (NSString *shading in [SetCard validShading])
            {
                for (NSString *color in [SetCard validColor])
                {
                    for (int number = 1; number <= [SetCard maxNumber]; number ++)
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}
@end
