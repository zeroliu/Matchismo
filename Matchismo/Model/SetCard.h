//
//  SetCard.h
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

+ (NSArray *) validSymbol;
+ (NSArray *) validShading;
+ (NSArray *) validColor;
+ (NSInteger) maxNumber;
@end
