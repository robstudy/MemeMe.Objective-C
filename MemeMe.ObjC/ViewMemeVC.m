//
//  ViewMemeVC.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 7/2/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "ViewMemeVC.h"
#import "CoreDataController.h"

@interface ViewMemeVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIImageView *memeImage;

@end

@implementation ViewMemeVC

//@synthesize passedMeme;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _memeImage.image = [UIImage imageWithData:_passedMeme.imageWithText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
