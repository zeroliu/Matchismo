//
//  GameResult.h
//  Matchismo
//
//  Created by Xiyuan Liu on 7/7/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject
@property (nonatomic, readonly) NSDate *start;
@property (nonatomic, readonly) NSDate *end;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSString *gameName;
@property (nonatomic) int score;

+ (NSArray *)allGameResults;
//Designated initializer
- (id)initWithGameName:(NSString *)gameName;

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult;
@end
