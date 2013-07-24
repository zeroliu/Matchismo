//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 6/25/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCardCollectionCell.h"

@interface PlayingCardGameViewController()
@end

@implementation PlayingCardGameViewController

#pragma mark - setter and getter


//- (GameResult *) gameResult
//{
//    if (!_gameResult) _gameResult = [[GameResult alloc] initWithGameName:@"Matchismo"];
//    return _gameResult;
//}

#pragma mark - override method
- (NSString *)cellID
{
    return @"PlayingCard";
}

- (NSUInteger)startingCardCount
{
    return 22;
}

- (NSUInteger)toMatchCardCount
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
        PlayingCardView *playingCardView = ((PlayingCardCollectionCell *)cell).playingCardView;
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

- (void)updateSelectedCardsCollection:(NSArray *)cardViewsCollection usingCards:(NSArray *)cards
{
    [super updateSelectedCardsCollection:cardViewsCollection usingCards:cards];
    
    for (UIView *cardView in cardViewsCollection)
    {
        if ([cardView isKindOfClass:[PlayingCardView class]])
        {
            PlayingCardView *playingCardView = (PlayingCardView *)cardView;
            int viewIndex = [cardViewsCollection indexOfObject:playingCardView];
            Card *card = nil;
            if (viewIndex <= (int)[cards count] - 1)
            {
                card = [cards objectAtIndex:viewIndex];
            }
            if (card && [card isKindOfClass:[PlayingCard class]])
            {
                PlayingCard *playingCard = (PlayingCard *)card;
                playingCardView.rank = playingCard.rank;
                playingCardView.suit = playingCard.suit;
                playingCardView.faceUp = YES;
            }
            else
            {
                playingCardView.rank = 0;
                playingCardView.suit = @"";
                playingCardView.faceUp = YES;
            }
        }
    }
}
@end
