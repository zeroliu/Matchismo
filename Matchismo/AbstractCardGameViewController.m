//
//  AbstractCardGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "AbstractCardGameViewController.h"
#import "CardGame.h"
#import "GameResult.h"
#import "Deck.h"

@interface AbstractCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) CardGame *game;
@property (nonatomic) NSUInteger flipCount;
@end

@implementation AbstractCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - setter and getter
- (void) setFlipCount:(NSUInteger)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (CardGame *) game
{
    if (!_game) _game = [[CardGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]
                                               cardsToMatch:self.toMatchCardCount];
    return _game;
}

#pragma mark - event handler
- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath != nil)
    {
        int index = indexPath.item;
        [self.game flipCardAtIndex:index];
        [self updateStatus];
        self.flipCount ++;
        [self updateUI];
        self.gameResult.score = self.game.score;
    }
}

- (IBAction)deal:(UIButton *)sender
{
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
    self.statusLabel.text = @"";
    self.gameResult = nil;
}

#pragma mark - to be overridden methods
- (Deck *)createDeck { return nil; } //abstract

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    //abstract
}

- (void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
}

- (void) updateStatus
{
    NSString *title = @"";
    //No match happened
    if ([self.game.cardsFlipped count])
    {
        if ([self.game.cardsFlipped count] < self.game.cardsToMatch)
        {
            title = [NSString stringWithFormat:@"Flipped %@", [[self.game.cardsFlipped lastObject] description]];
        }
        else
        {
            if (self.game.scoreChanged > 0)
            {
                title = [NSString stringWithFormat:@"Matched %@ for %d points", [self.game.cardsFlipped componentsJoinedByString:@" & "], self.game.scoreChanged];
            }
            else
            {
                title = [NSString stringWithFormat:@"%@ don't match! %d points penalty", [self.game.cardsFlipped componentsJoinedByString:@" & "], self.game.scoreChanged];
            }
        }
    }
    self.statusLabel.text = title;
}

#pragma mark - special initializer
- (void)setup
{
    // Initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

@end
