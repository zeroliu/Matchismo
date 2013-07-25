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
@property (weak, nonatomic) IBOutlet UILabel *scoreUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *selectedCardsCollection;
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) CardGame *game;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (nonatomic) NSUInteger flipCount;
@end

#define ENABLED_DEAL_BUTTON_ALPHA 1.0
#define DISABLED_DEAL_BUTTON_ALPHA 0.5

@implementation AbstractCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //sort selected card view by their tags in ascending order
    NSSortDescriptor *tagDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    self.selectedCardsCollection = [self.selectedCardsCollection sortedArrayUsingDescriptors:@[tagDescriptor]];
    [self updateUI:-1];
}

#pragma mark - setter and getter
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
        NSUInteger index = indexPath.item;
        [self.game flipCardAtIndex:index];
        self.flipCount ++;
        [self updateUI:index];
        
        self.gameResult.score = self.game.score;
    }
}

- (IBAction)restart:(UIButton *)sender
{
    self.game = nil;
    self.flipCount = 0;
    [self.cardCollectionView reloadData];
    [self updateUI:-1];
    self.gameResult = nil;
    self.dealButton.enabled = YES;
    self.dealButton.alpha = ENABLED_DEAL_BUTTON_ALPHA;
}

#define DEFAULT_DEAL_CARDS_NUM 3
- (IBAction)dealCards:(UIButton *)sender
{
    NSArray *addedCardsIndexes = [self.game dealCardsWithNumber:DEFAULT_DEAL_CARDS_NUM];
    NSMutableArray *addedCardsIndexPaths = [[NSMutableArray alloc] initWithCapacity:[addedCardsIndexes count]];
    for (NSNumber *cardIndex in addedCardsIndexes)
    {
        [addedCardsIndexPaths addObject:[NSIndexPath indexPathForItem:[cardIndex unsignedIntegerValue] inSection:0]];
    }
    
    if ([addedCardsIndexPaths count] > 0)
    {
        [self.cardCollectionView performBatchUpdates:^{
            [self.cardCollectionView insertItemsAtIndexPaths:addedCardsIndexPaths];
        } completion:^(BOOL finished) {
            [self.cardCollectionView scrollToItemAtIndexPath:[addedCardsIndexPaths lastObject] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }];
    }
    else
    {
        //run out of cards
        self.dealButton.enabled = NO;
        self.dealButton.alpha = DISABLED_DEAL_BUTTON_ALPHA;
    }
}

#pragma mark - to be overridden methods
- (Deck *)createDeck { return nil; } //abstract

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)isAnimated
{
    //abstract
}

- (void)updateSelectedCardsCollection:(NSArray *)cardViewsCollection usingCards:(NSArray *)cards
{
    NSAssert(([cards count] <= [cardViewsCollection count]), @"There are more flipped card than card view, cannot handle this case");
    //abstract
}

- (void)updateUI:(NSUInteger)index
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.game.score];
    [self updateScoreChangeUI];
    [self updateSelectedCardsCollection:self.selectedCardsCollection usingCards:(NSArray *)self.game.cardsFlipped];
    //Update cards
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        if (card.isUnplayable && [self willRemoveCard])
        {
            [self.game removeCardAtIndex:indexPath.item];
            [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        [self updateCell:cell usingCard:card animated:(indexPath.item == index)];
    }
}

- (void)removeCardAtIndexPath:(NSIndexPath *)indexPath fromCardsCollectionView:(UICollectionView *)cardCollectionView
{
    //abstract
}

- (BOOL)willRemoveCard
{
    return NO;
}

#pragma mark - UI update methods

- (void) updateScoreChangeUI
{
    if (self.game.scoreChanged != 0)
    {
        if (self.game.scoreChanged > 0)
        {
            self.scoreUpdateLabel.text = [NSString stringWithFormat:@"+%d", self.game.scoreChanged];
            self.scoreUpdateLabel.textColor = [UIColor greenColor];
        }
        else
        {
            self.scoreUpdateLabel.text = [NSString stringWithFormat:@"%d", self.game.scoreChanged];
            self.scoreUpdateLabel.textColor = [UIColor redColor];
        }
        self.scoreUpdateLabel.alpha = 1.0;
    }
    else
    {
        self.scoreUpdateLabel.alpha = 0;
    }
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
    //TODO: Change the value while deleting cards or dealing more cards
    return self.game.cardsInPlay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellID forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animated:NO];
    return cell;
}

@end
