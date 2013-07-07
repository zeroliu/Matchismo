//
//  SetCard.h
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "Card.h"


@interface SetCard : Card


@property (nonatomic) NSInteger number;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic, strong) NSString *color;

+ (NSArray *) validSymbol;
+ (NSArray *) validShading;
+ (NSArray *) validColor;
+ (NSInteger) maxNumber;
@end
