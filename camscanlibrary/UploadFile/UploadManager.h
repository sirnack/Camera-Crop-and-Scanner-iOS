//
//  UploadManager.h
//  MMCamScanner
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UploadManager : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate>
+(instancetype)shared;
-(NSURLSessionUploadTask *) uploadTaskWithURL:(NSMutableURLRequest*)url withImageData:(NSString *)imgData;
@end
