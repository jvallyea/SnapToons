//
//  ViewController.m
//  Cartoonify
//
//  Created by My MacBook on 9/9/18.
//  Copyright © 2018 JV. All rights reserved.
//

#import "ViewController.h"
//@import SCSDKCoreKit;
//@import SCSDKCreativeKit;

//@class SCSDKSnapPhoto;
//@class SCSDKSnapPhotoContent;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)convertImageToGrayScale:(UIButton *)sender {
    UIImage *image = self.imageView.image;
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);

    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);

    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);

    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];

    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);

    // Return the new grayscale image
    self.imageView.image = newImage;
 
}

- (IBAction)smoothImage:(UIButton *)sender {
//
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//
//    visualEffectView.frame = self.imageView.bounds;
//    [self.imageView addSubview:visualEffectView];
//
//    CIContext *context_ = [CIContext contextWithOptions:nil];
//
//    UIImage *defaultImage_=self.imageView.image;
//
//    CIImage *inputImage = [CIImage imageWithCGImage:[defaultImage_ CGImage]];
//
//    //Apply CIBloom that makes soft edges and adds glow to image
//    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
//    [filter setValue:inputImage forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithDouble:6.0] forKey:@"inputRadius"];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//
//    CGImageRef cgImage = [context_ createCGImage:result fromRect:[result extent]];
//    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
//    CGImageRelease(cgImage);
//
//    self.imageView.image = resultImage;
    
    // load image
    UIImage *image      = self.imageView.image;
    CGImageRef imageRef = image.CGImage;
    NSData *data        = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(imageRef)));
    char *pixels        = (char *)[data bytes];
    
    // this is where you manipulate the individual pixels
    // assumes a 4 byte pixel consisting of rgb and alpha
    // for PNGs without transparency use i+=3 and remove int a
    for(int i = 0; i < [data length]; i += 4)
    {
        int r = i;
        int g = i+1;
        int b = i+2;
        int a = i+3;
        
        pixels[r]   = 0; // eg. remove red
        pixels[g]   = pixels[g];
        pixels[b]   = pixels[b];
        pixels[a]   = pixels[a];
    }
    
    // create a new image from the modified pixel data
    size_t width                    = CGImageGetWidth(imageRef);
    size_t height                   = CGImageGetHeight(imageRef);
    size_t bitsPerComponent         = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel             = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow              = CGImageGetBytesPerRow(imageRef);

    CGColorSpaceRef colorspace      = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo         = CGImageGetBitmapInfo(imageRef);
    CGDataProviderRef provider      = CGDataProviderCreateWithData(NULL, pixels, [data length], NULL);

    CGImageRef newImageRef = CGImageCreate (
                                            width,
                                            height,
                                            bitsPerComponent,
                                            bitsPerPixel,
                                            bytesPerRow,
                                            colorspace,
                                            bitmapInfo,
                                            provider,
                                            NULL,
                                            false,
                                            kCGRenderingIntentDefault
                                            );
    // the modified image
    UIImage *newImage   = [UIImage imageWithCGImage:newImageRef];
    self.imageView.image = newImage;
    // cleanup
//    free(pixels);
//    CGImageRelease(imageRef);
//    CGColorSpaceRelease(colorspace);
//    CGDataProviderRelease(provider);
//    CGImageRelease(newImageRef);
}


- (IBAction)sendSnap:(UIButton *)sender {
    //UIImage *snapImage = self.imageView.image;
    //SCSDKSnapPhoto *photo = [[SCSDKSnapPhoto alloc] initWithImage:snapImage];
    //SCSDKSnapPhotoContent *photoContent = [[SCSDKSnapPhotoContent alloc] initWithSnapPhoto:photo];

   }





- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
