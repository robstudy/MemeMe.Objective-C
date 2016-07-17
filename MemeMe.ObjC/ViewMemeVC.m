//
//  ViewMemeVC.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 7/2/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "ViewMemeVC.h"
#import "MemeEditorVC.h"
#import "CoreDataController.h"

@interface ViewMemeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *memeImage;

@end

@implementation ViewMemeVC

//@synthesize passedMeme;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    _memeImage.image = [UIImage imageWithData:_passedMeme.imageWithText];
    self.navigationController.delegate = self;
    self.navigationController.toolbarHidden= NO;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:51.0f/255.0f
                                                                     green:153.0f/255.0f
                                                                      blue:204.0f/255.0f
                                                                     alpha:1.0f];;
}

- (IBAction)editMeme:(id)sender {
    [self performSegueWithIdentifier:@"callMemeEditor" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]  isEqual: @"callMemeEditor"]) {
        MemeEditorVC *memeEditorVC = (MemeEditorVC *)[segue destinationViewController];
        memeEditorVC.passedMeme = self.passedMeme;
        memeEditorVC.calledFromViewMemeVC = YES;
    }
}

#pragma mark - IBActions

- (IBAction)shareImage:(id)sender {
    UIImage *fullMemeImage = [UIImage imageWithData:self.passedMeme.imageWithText];
    
    NSArray *holdFullImage = [[NSArray alloc] initWithObjects:fullMemeImage, nil];
    
    UIActivityViewController *shareImageVC = [[UIActivityViewController alloc] initWithActivityItems:holdFullImage applicationActivities:nil];
    
    if ([shareImageVC respondsToSelector:@selector(popoverPresentationController)]) {
        shareImageVC.popoverPresentationController.sourceView = _memeImage;
    }
    
    [self presentViewController:shareImageVC animated:YES completion:nil];
}

-(IBAction)delete:(id)sender {
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.sharedContext deleteObject:_passedMeme];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        return;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *confirmDelete = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Would you like to delete meme?" preferredStyle:UIAlertControllerStyleAlert];
        [confirmDelete addAction:confirm];
        [confirmDelete addAction:cancel];
        [self presentViewController:confirmDelete animated:YES completion:nil];
    });
}

-(NSManagedObjectContext *)sharedContext {
    CoreDataController *sharedStore = [CoreDataController sharedStore];
    return sharedStore.managedObjectContext;
}

@end
