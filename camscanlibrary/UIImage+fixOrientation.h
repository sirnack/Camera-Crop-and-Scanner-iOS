//
//  UIImage+fixOrientation.h
//  MMCamScanner//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;
+(UIImage*)renderImage:(NSString *)imagName;
+(UIImage *) scaleAndRotateImage:(UIImage *)image;
@end