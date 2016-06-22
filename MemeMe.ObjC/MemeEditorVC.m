//
//  MemeEditorVC.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/21/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "MemeEditorVC.h"

@interface MemeEditorVC ()
@property (weak, nonatomic) IBOutlet UITextField *topTextField;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;
@end

@implementation MemeEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTextFields:_topTextField text:@"TOP"];
    [self setTextFields:_bottomTextField text:@"BOTTOM"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
