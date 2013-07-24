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
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) CardGame *game;
@property (nonatomic) NSUInteger flipCount;
@end

@implementation AbstractCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //sort selected card view by their tags in ascending order
    NSSortDescriptor *tagDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    self.selectedCardsCollection = [self.selectedCardsCollection sortedArrayUsingDescriptors:@[tagDescriptor]];
    [self updateUI];
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
        int index = indexPath.item;
        [self.game flipCardAtIndex:index];
//        [self updateStatus];
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
    self.gameResult = nil;
}

#pragma mark - to be overridden methods
- (Deck *)createDeck { return nil; } //abstract

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    //abstract
}

- (void)updateSelectedCardsCollection:(NSArray *)cardViewsCollection usingCards:(NSArray *)cards
{
    NSAssert(([cards count] <= [cardViewsCollection count]), @"There are more flipped card than card view, cannot handle this case");
    //abstract
}

- (void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.game.score];
    [self updateScoreChangeUI];
    [self updateSelectedCardsCollection:self.selectedCardsCollection usingCards:(NSArray *)self.game.cardsFlipped];
    //Update cards
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
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

//- (void) updateStatus
//{
//    NSString *title = @"";
//    //No match happened
//    if ([self.game.cardsFlipped count])
//    {
//        if ([self.game.cardsFlipped count] < self.game.cardsToMatch)
//        {
//            title = [NSString stringWithFormat:@"Flipped %@", [[self.game.cardsFlipped lastObject] description]];
//        }
//        else
//        {
//            if (self.game.scoreChanged > 0)
//            {
//                title = [NSString stringWithFormat:@"Matched %@ for %d points", [self.game.cardsFlipped componentsJoinedByString:@" & "], self.game.scoreChanged];
//            }
//            else
//            {
//                title = [NSString stringWithFormat:@"%@ don't match! %d points penalty", [self.game.cardsFlipped componentsJoinedByString:@" & "], self.game.scoreChanged];
//            }
//        }
//    }
//}

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellID forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

@end
