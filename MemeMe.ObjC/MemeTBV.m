//
//  MemeTBV.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/19/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "MemeTBV.h"
#import "MemeListCell.h"
#import "Meme.h"
#import "ViewMemeVC.h"
#import "CoreDataController.h"

@interface MemeTBV ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MemeTBV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeFetchedResutlsController];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self fetchedResultsController] performFetch:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self tableView] reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.fetchedObjects count];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Meme *tableMeme = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    MemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memeCell" forIndexPath:indexPath];
    
    UIImage *imageWithData = [UIImage imageWithData:tableMeme.imageWithText];
    
    cell.imageView.image = imageWithData;
    [self setTextViews:cell.topText text:tableMeme.topText];
    [self setTextViews:cell.bottomText text:tableMeme.bottomText];
    
    return cell;
}

-(void)setTextViews:(UITextView *)textview text:(NSString *)setText {
    NSAttributedString *textAttributes = [[NSAttributedString alloc]initWithString:setText attributes: @{  NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0], NSStrokeColorAttributeName: [UIColor blackColor], NSForegroundColorAttributeName: [UIColor whiteColor], NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-3.0]}];
    textview.attributedText = textAttributes;
    textview.textAlignment = NSTextAlignmentCenter;
    textview.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textview.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]  isEqual: @"showMemeImage"]) {
        ViewMemeVC *memeVC = (ViewMemeVC *)[segue destinationViewController];
        memeVC.passedMeme = memeToPass;
    }
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    memeToPass = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showMemeImage" sender:self];
}

@end
