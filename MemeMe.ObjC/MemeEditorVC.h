//
//  MemeEditorVC.h
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/21/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemeEditorVC : UIViewController <UITextFieldDelegate>
-(void)setTextFields:(UITextField *)textfield
                     text:(NSString *)defaultText;
@end
