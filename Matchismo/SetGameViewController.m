//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "CardGame.h"
#import "SetCard.h"
#import "GameResult.h"
#import "SetCardCollectionCell.h"

@implementation SetGameViewController

#define ANIMATION_DURATION 0.2

#pragma mark - setter and getter

//- (GameResult *) gameResult
//{
//    if (!_gameResult) _gameResult = [[GameResult alloc] initWithGameName:@"Set"];
//    return _gameResult;
//}
- (NSString *)cellID
{
    return @"SetCard";
}

- (NSUInteger)startingCardCount
{
    return 12;
}

- (NSUInteger) toMatchCardCount
{
    return 3;
}

- (Deck *) createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)isAnimated
{
    if ([cell isKindOfClass:[SetCardCollectionCell class]])
    {
        SetCardView *setCardView = ((SetCardCollectionCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            //if card is unplayable, remove it
            if (setCard.isUnplayable)
            {
                
            }
            else
            {
                setCardView.faceUp = setCard.isFaceUp;
                setCardView.number = setCard.number;
                setCardView.shading = setCard.shading;
                setCardView.symbol = setCard.symbol;
                setCardView.color = setCard.color;
            }
        }
    }
}

- (void)updateSelectedCardsCollection:(NSArray *)cardViewsCollection usingCards:(NSArray *)cards
{
    [super updateSelectedCardsCollection:cardViewsCollection usingCards:cards];
    
    for (UIView *cardView in cardViewsCollection)
    {
        if ([cardView isKindOfClass:[SetCardView class]])
        {
            SetCardView *setCardView = (SetCardView *)cardView;
            int viewIndex = [cardViewsCollection indexOfObject:setCardView];
            Card *card = nil;
            if (viewIndex <= (int)[cards count] - 1)
            {
                card = [cards objectAtIndex:viewIndex];
            }
            if (card && [card isKindOfClass:[SetCard class]])
            {
                [UIView transitionWithView:setCardView
                                  duration:ANIMATION_DURATION
                                   options:([cards count] == [self toMatchCardCount]) ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionNone
                                animations:^
                {
                    SetCard *setCard = (SetCard *)card;
                    setCardView.number = setCard.number;
                    setCardView.shading = setCard.shading;
                    setCardView.symbol = setCard.symbol;
                    setCardView.color = setCard.color;
                    setCardView.faceUp = NO;
                } completion:NULL];
            }
            else
            {
                setCardView.number = 0;
                setCardView.shading = 0;
                setCardView.symbol = 0;
                setCardView.color = 0;
                setCardView.faceUp = NO;
            }
        }
    }
}

- (BOOL)willRemoveCard
{
    return YES;
}
@end
