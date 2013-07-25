//
//  AbstractCardGameViewController.h
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGame.h"
@interface AbstractCardGameViewController : UIViewController <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (nonatomic) NSUInteger startingCardCount; //abstract
@property (nonatomic) NSUInteger toMatchCardCount; //abstract
@property (nonatomic) NSString *cellID;//abstract
- (Deck *) createDeck; //abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)isAnimated; //abstract
- (void)updateSelectedCardsCollection:(NSArray *)cardViewsCollection usingCards:(NSArray *)cards; //abstract
- (BOOL)willRemoveCard; //abstract
@end
