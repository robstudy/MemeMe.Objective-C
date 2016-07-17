//
//  MemeEditorVC.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/21/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "MemeEditorVC.h"
#import "CoreDataController.h"
#import "Meme+CoreDataProperties.h"

@interface MemeEditorVC ()

@property (weak, nonatomic) IBOutlet UIImageView *memeImage;
@property (weak, nonatomic) IBOutlet UITextField *topTextField;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property CGFloat imageWidth;
@property CGFloat imageHeight;

@end

@implementation MemeEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    if (_calledFromViewMemeVC) {
        [self setTextFields:_topTextField text:_passedMeme.topText];
        [self setTextFields:_bottomTextField text:_passedMeme.bottomText];
        _memeImage.image = [UIImage imageWithData:_passedMeme.image];
    } else {
        [self setTextFields:_topTextField text:@"TOP"];
        [self setTextFields:_bottomTextField text:@"BOTTOM"];
    }
    _cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    _memeImage.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self subscribeToKeyboardNotification];
    [self.view sendSubviewToBack:_memeImage];
    self.navigationController.toolbarHidden= YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unsubscribeFromKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Notifications

-(void)keyboardWillShow:(NSNotification *)notification {
    if (_bottomTextField.isFirstResponder) {
        CGRect frame = self.view.frame;
        frame.origin.y = -[self getKeyboardHeight:notification];
        self.view.frame = frame;
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    frame.origin.y = 0.0f;
    self.view.frame = frame;
}

-(CGFloat)getKeyboardHeight:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardSize = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    return keyboardSize.CGRectValue.size.height;
}

-(void)subscribeToKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)unsubscribeFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - TextFields

-(void)setTextFields:(UITextField *)textfield text:(NSString *)defaultText {
    [textfield setDelegate:self];
    NSAttributedString *textAttributes = [[NSAttributedString alloc]initWithString:defaultText attributes: @{  NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0], NSStrokeColorAttributeName: [UIColor blackColor], NSForegroundColorAttributeName: [UIColor whiteColor], NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-3.0]}];
    textfield.attributedText = textAttributes;
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textfield.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - ImagePicker and Delegate Controls

- (IBAction)pickImageFromAlbum:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.navigationBar.barTintColor = [UIColor colorWithRed:51.0f/255.0f
                                                             green:153.0f/255.0f
                                                              blue:204.0f/255.0f
                                                             alpha:1.0f];
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];

    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _imageWidth = image.size.width;
    _imageHeight = image.size.height;
    _memeImage.image = image;
    fullMemeImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Text Field Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string  isEqual: @"/n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text  isEqual: @"TOP"] || [textField.text  isEqual: @"BOTTOM"]) {
        textField.text = @"";
    }
}

#pragma mark - Save

- (IBAction)save:(id)sender {
    fullMemeImage = [self generateMemeImage];
    NSData *data = UIImagePNGRepresentation(fullMemeImage);
    NSData *data2 = UIImagePNGRepresentation(_memeImage.image);
    
    if (_calledFromViewMemeVC) {
        _passedMeme.topText = _topTextField.text;
        _passedMeme.bottomText = _bottomTextField.text;
        _passedMeme.image = data2;
        _passedMeme.imageWithText = data;
    } else {
    Meme *newMeme = [[Meme alloc] initWithContext:[self sharedContext]
                                      memeTopText:_topTextField.text
                                   memeBottomText:_bottomTextField.text
                                        memeImage:data2
                                memeImageWithText:data];
        NSLog(@"Saved new meme %@",newMeme);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)generateMemeImage {
    //Remove First Responder From TextFields
    [_topTextField resignFirstResponder];
    [_bottomTextField resignFirstResponder];
    
    CGRect rectangle = CGRectMake(0.0, 0.0, _imageWidth , _imageHeight);
    UIGraphicsBeginImageContext(rectangle.size);
    [_memeImage.image drawInRect:rectangle];
    [_topTextField drawViewHierarchyInRect:CGRectMake(0.0, 0.0, rectangle.size.width, rectangle.size.height / 7.0) afterScreenUpdates:YES];
    [_bottomTextField drawViewHierarchyInRect:CGRectMake(0.0, rectangle.size.height -rectangle.size.height / 7.0, rectangle.size.width, rectangle.size.height / 7.0) afterScreenUpdates:YES];
    UIImage *memeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return memeImage;
}

-(NSManagedObjectContext *)sharedContext {
    CoreDataController *sharedStore = [CoreDataController sharedStore];
    return sharedStore.managedObjectContext;
}

@end
