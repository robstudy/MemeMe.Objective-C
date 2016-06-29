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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;


@end

@implementation MemeEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTextFields:_topTextField text:@"TOP"];
    [self setTextFields:_bottomTextField text:@"BOTTOM"];
    _cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    _memeImage.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self subscribeToKeyboardNotification];
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


- (IBAction)pickImageFromAlbum:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate Controls

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _memeImage.image = image;
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

#pragma mark - Share Image

- (IBAction)shareImage:(id)sender {
    fullMemeImage = [self generateMemeImage];
    
    NSArray *holdFullImage = [[NSArray alloc] initWithObjects:fullMemeImage, nil];
    
    UIActivityViewController *shareImageVC = [[UIActivityViewController alloc] initWithActivityItems:holdFullImage applicationActivities:nil];
    
    if ([shareImageVC respondsToSelector:@selector(popoverPresentationController)]) {
        shareImageVC.popoverPresentationController.sourceView = _memeImage;
    }
    
    [self presentViewController:shareImageVC animated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    
    fullMemeImage = [self generateMemeImage];
    NSData *data = UIImagePNGRepresentation(fullMemeImage);
    NSData *data2 = UIImagePNGRepresentation(_memeImage.image);
    
    Meme *newMeme = [[Meme alloc] initWithContext:[self sharedContext]
                                      memeTopText:_topTextField.text
                                   memeBottomText:_bottomTextField.text
                                        memeImage:data2
                                memeImageWithText:data];

    NSLog(@"Saved new meme %@",newMeme);
}


-(UIImage *)generateMemeImage {
    //Hide Tool Bars when gernating image
    _bottomToolBar.hidden = YES;
    
    //Remove First Responder From TextFields
    [_topTextField resignFirstResponder];
    [_bottomTextField resignFirstResponder];
    
    _memeImage.contentMode = UIViewContentModeScaleAspectFill;
    
    //Render View to an image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:true];
    UIImage *memeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Unhide ToolBars
    _bottomToolBar.hidden = NO;
    
    return memeImage;
}

-(NSManagedObjectContext *)sharedContext {
    CoreDataController *sharedStore = [CoreDataController sharedStore];
    return sharedStore.managedObjectContext;
}

@end
