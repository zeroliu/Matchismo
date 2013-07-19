//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 6/25/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "SuperCardView.h"
#import "PlayingCardCollectionCell.h"

@interface CardGameViewController()
@end

@implementation CardGameViewController

#pragma mark - setter and getter


//- (GameResult *) gameResult
//{
//    if (!_gameResult) _gameResult = [[GameResult alloc] initWithGameName:@"Matchismo"];
//    return _gameResult;
//}

#pragma mark - override method
//- (void) updateUI
//{
//    [super updateUI];
//    
//}

-(NSUInteger) startingCardCount
{
    return 20;
}

-(NSUInteger) toMatchCardCount
{
    return 2;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionCell class]])
    {
        SuperCardView *playingCardView = ((PlayingCardCollectionCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}
@end
