//
//  MemeCollectionVC.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/19/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "MemeCollectionVC.h"
#import "Meme.h"
#import "ViewMemeVC.h"
#import "CoreDataController.h"

@interface MemeCollectionVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation MemeCollectionVC

static NSString * const reuseIdentifier = @"memeCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self initializeFetchedResutlsController];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //Floy Layout
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    float dimension = self.view.frame.size.width/3.0;
    self.flowLayout.itemSize = CGSizeMake(dimension, dimension);
}

-(void)viewWillAppear:(BOOL)animated {
    [self.fetchedResultsController performFetch:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionViewLayout invalidateLayout];
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier]  isEqual: @"showMemeImage"]) {
        ViewMemeVC *memeVC = (ViewMemeVC *)[segue destinationViewController];
        memeVC.passedMeme = memeToPass;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Meme *memeObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    UIImage *memeImage = [UIImage imageWithData:memeObject.imageWithText];
    UIImageView *memeImageView = [[UIImageView alloc] initWithImage:memeImage];
    
    cell.backgroundView = memeImageView;
    
    return cell;
}

#pragma mark - Fetched Results controller

-(void)initializeFetchedResutlsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meme"];
    NSSortDescriptor *topTextSort = [NSSortDescriptor sortDescriptorWithKey:@"topText" ascending:YES];
    
    [request setSortDescriptors:@[topTextSort]];
    
    NSManagedObjectContext *moc =[self sharedContext];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

-(NSManagedObjectContext *)sharedContext {
    CoreDataController *sharedStore = [CoreDataController sharedStore];
    return sharedStore.managedObjectContext;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    memeToPass = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showMemeImage" sender:self];
}




@end
