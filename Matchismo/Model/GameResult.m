//
//  GameResult.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/7/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (nonatomic, readwrite) NSDate *start;
@property (nonatomic, readwrite) NSDate *end;
@property (nonatomic, readwrite) NSTimeInterval duration;
@property (nonatomic, readwrite) NSString *gameName;
@end

@implementation GameResult

#define ALL_RESULT_KEY @"gameResult_all"
#define START_KEY @"start_key"
#define END_KEY @"end_key"
#define SCORE_KEY @"score_key"
#define GAME_KEY @"game_key"

#pragma mark - class methods
+ (NSArray *)allGameResults
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSDictionary *plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULT_KEY] allValues])
    {
        GameResult *result = [[GameResult alloc] initWithPropertyList:plist];
        [results addObject:result];
    }
    return results;
}

#pragma mark - initializer
- (id)initWithGameName:(NSString *)gameName
{
    self = [super init];
    if (self)
    {
        _gameName = gameName;
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (id)initWithPropertyList:(id)plist
{
    self = [super init];
    if (self)
    {
        if ([plist isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _gameName = resultDictionary[GAME_KEY];
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if (!_start || !_end) self = nil;
        }
    }
    return self;
}

#pragma mark - setter and getter
- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

#pragma mark - private methods
- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULT_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{
             START_KEY: self.start,
             END_KEY: self.end,
             SCORE_KEY: @(self.score),
             GAME_KEY: self.gameName
             };
}

#pragma mark - sorting
- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult
{
    if (self.score > otherResult.score)
    {
        return NSOrderedAscending;
    }
    else if (self.score < otherResult.score)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult
{
    return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult
{
    if (self.duration > otherResult.duration)
    {
        return NSOrderedAscending;
    }
    else if (self.duration < otherResult.duration)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedSame;
    }
}
@end
