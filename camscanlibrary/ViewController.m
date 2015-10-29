//
//  ViewController.m
//  camscanlibrary
//
//  Created by Prachaya Pan-in on 9/21/2558 BE.
//  Copyright © 2558 Prachaya Pan-in. All rights reserved.
//


#import "ViewController.h"
#import "MMCameraPickerController.h"
#import "CropViewController.h"
#define backgroundHex @"F2F6F7"
#import "UIColor+HexRepresentation.h"
#import "UIImage+fixOrientation.h"
#import <TesseractOCR/TesseractOCR.h>
#import "UploadManager.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
@interface ViewController ()<MMCameraDelegate,MMCropDelegate,G8TesseractDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F2F6F7"];
    NSArray *imgArr=@[@"sample.jpg",@"Camera.png",@"Crop.png",@"Done.png",@"Gallery.png"];
    for (int i=0; i<imgArr.count; i++) {
        NSLog(@"URL COUNT:",i);
    }
}

-(void)setUI{
    self.cameraBut.layer.cornerRadius = self.cameraBut.frame.size.width / 2;
    self.cameraBut.clipsToBounds=YES;
    [self.cameraBut setImage:[UIImage renderImage:@"Camera"] forState:UIControlStateNormal];
    
    
    self.pickerBut.layer.cornerRadius = self.pickerBut.frame.size.width / 2;
    self.pickerBut.clipsToBounds=YES;
    [self.pickerBut setImage:[UIImage renderImage:@"Gallery"] forState:UIControlStateNormal];
}

#pragma mark Document Directory

- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
-(NSURL *)applicationDocumentsDirectory{
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [paths lastObject];
}

// OCR
-(void)OCR:(UIImage *)image{
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];
    
    operation.tesseract.language = @"eng";
    operation.tesseract.image = [image g8_blackAndWhite];
    operation.tesseract.delegate=self;
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        NSLog(@" OCR TEXT%@", [recognizedTesseract recognizedText]);
    };
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark OCR delegate
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract{
    
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract{
    return NO;
}


// ปุ่มเลือกภาพจากอัลบั้ม
- (IBAction)pickerAction:(id)sender{
    _invokeCamera = [[UIImagePickerController alloc] init];
    _invokeCamera.delegate = self;
    _invokeCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _invokeCamera.allowsEditing = NO;
    _invokeCamera.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    
    [self presentViewController:_invokeCamera animated:NO completion:nil];
}

// ปุ่มถ่ายรูป
- (IBAction)cameraAction:(id)sender {
    MMCameraPickerController *cameraPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
    cameraPicker.camdelegate=self;
    
    [self presentViewController:cameraPicker animated:NO completion:nil];
    
    
    
}


#pragma mark Picker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_invokeCamera dismissViewControllerAnimated:NO completion:nil];
    [_invokeCamera removeFromParentViewController];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_invokeCamera dismissViewControllerAnimated:NO completion:nil];
    [_invokeCamera removeFromParentViewController];
    
    CropViewController *crop=[self.storyboard instantiateViewControllerWithIdentifier:@"crop"];
    crop.cropdelegate=self;
    crop.adjustedImage=[info objectForKey:UIImagePickerControllerOriginalImage];

    [self presentViewController:crop animated:NO completion:nil];

//    id controller = [[NSClassFromString(@"CropViewController") alloc] initWithNibName:@"CropViewController" bundle:nil];
//    [controller performSelector:@selector(setCropdelegate:) withObject:self];
//    [controller performSelector:@selector(setAdjustedImage:) withObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
//    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark Camera Delegate
-(void)didFinishCaptureImage:(UIImage *)capturedImage withMMCam:(MMCameraPickerController*)cropcam{
    
////NSOperationqueue
//    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
//        // dfjdfkalsdf kjaskdj foekfjd f
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            // show loading.
//        }];
//        
//        NSLog(@"background thread.");
//        
//        // hide loading.
//    }];
    
    [cropcam closeWithCompletion:^{
        NSLog(@"dismissed");
    
        if(capturedImage!=nil){
            CropViewController *crop=[self.storyboard instantiateViewControllerWithIdentifier:@"crop"];
            crop.cropdelegate=self;
            crop.adjustedImage=capturedImage;
            
            [self presentViewController:crop animated:NO completion:nil];
            
//            id controller = [[NSClassFromString(@"CropViewController") alloc] initWithNibName:@"CropViewController" bundle:nil];
//            [controller performSelector:@selector(setCropdelegate:) withObject:self];
//            [controller performSelector:@selector(setAdjustedImage:) withObject:capturedImage];
//            [self presentViewController:controller animated:YES completion:nil];
 
        }
    }];
    
    
}
-(void)authorizationStatus:(BOOL)status{
    
}


#pragma mark crop delegate
-(void)didFinishCropping:(UIImage *)finalCropImage from:(CropViewController *)cropObj{
    [cropObj closeWithCompletion:^{
    }];
    
    NSLog(@"Size of Image %lu",(unsigned long)UIImageJPEGRepresentation(finalCropImage, 0.5).length);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
