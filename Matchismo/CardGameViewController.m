//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 6/25/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface AbstractCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@end

@interface CardGameViewController()
@end

@implementation CardGameViewController
@synthesize game = _game;

#pragma mark - setter and getter
- (CardGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


#pragma mark - override method
- (void) updateUI
{
    [super updateUI];
    
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
        [cardButton setImage:[UIImage imageNamed:@"cardBack.png"] forState:UIControlStateNormal];
        [cardButton setImage:[UIImage imageNamed:@"clear.jpg"] forState:UIControlStateSelected];
        [cardButton setImage:[UIImage imageNamed:@"clear.jpg"] forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
   
    
    //Code written in Assignment 1
    //Remove for Assignment 2
//    [self.gameModeSwitch setEnabled: !(self.game.gameStarted)];
//    [self.gameModeSegment setEnabled: !(self.game.gameStarted)];
}

//Code written in Assignment 1
//Remove for Assignment 2

//- (IBAction)modeSwitch:(UISwitch *)sender
//{
//    [self.game turnOnThreeMatchMode:sender.isOn];
//
//    //Unusual code implementation here just to sync 2 control switches
//    self.gameModeSegment.selectedSegmentIndex = (sender.isOn) ? 0 : 1;
//}
//
//- (IBAction)segmentSwitch:(UISegmentedControl *)sender
//{
//    [self.game turnOnThreeMatchMode:((sender.selectedSegmentIndex) == 0)];
//
//    //Unusual code implementation here just to sync 2 control switches
//    [self.gameModeSwitch setOn:((sender.selectedSegmentIndex) == 0) animated:YES];
//}

@end
