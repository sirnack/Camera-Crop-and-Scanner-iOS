//
//  UIImageView+ContentFrame.m
//  MMCamScanner

#import "UIImageView+ContentFrame.h"


@implementation UIImageView (UIImageView_ContentFrame)

- (CGRect) contentFrame
{
    CGSize imageSize = self.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(0.5f*(CGRectGetWidth(self.bounds)-scaledImageSize.width), 0.5f*(CGRectGetHeight(self.bounds)-scaledImageSize.height), scaledImageSize.width, scaledImageSize.height);
    return imageFrame;
}

- (CGSize) contentSize
{
    CGSize imageSize = self.image.size;
   
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
    CGSize finalSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
     NSLog(@"%f %f %f",imageSize.width,imageSize.height,imageScale);
    
    return finalSize;
}

- (CGFloat) contentScale
{
    CGSize imageSize = self.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
    return imageScale;
}




@end