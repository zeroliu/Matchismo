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
@property (nonatomic) NSUInteger startingCardCount; //abstract
@property (nonatomic) NSUInteger toMatchCardCount; //abstract

- (Deck *) createDeck; //abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; //abstract



@end
