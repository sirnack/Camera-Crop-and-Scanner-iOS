//
//  ViewController.h
//  camscanlibrary
//
//  Created by Prachaya Pan-in on 9/21/2558 BE.
//  Copyright © 2558 Prachaya Pan-in. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cameraBut;
@property (weak, nonatomic) IBOutlet UIButton *pickerBut;

@property (strong ,nonatomic) UIImagePickerController *invokeCamera;
- (IBAction)cameraAction:(id)sender;
- (IBAction)pickerAction:(id)sender;

@end
