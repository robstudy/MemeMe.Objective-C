//
//  MemeEditorVC.h
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/21/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemeEditorVC : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    UIImage *fullMemeImage;
}

-(void)setTextFields:(UITextField *)textfield
                     text:(NSString *)defaultText;
-(void)keyboardWillShow:(NSNotification *)notification;
-(void)keyboardWillHide:(NSNotification *)notification;
-(CGFloat)getKeyboardHeight:(NSNotification *)notification;
-(void)subscribeToKeyboardNotification;
-(void)unsubscribeFromKeyboardNotifications;
-(UIImage *)generateMemeImage;

@end
