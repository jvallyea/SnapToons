//
//  ViewController.h
//  Cartoonify
//
//  Created by My MacBook on 9/9/18.
//  Copyright © 2018 JV. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)convertImageToGrayScale:(UIButton *)sender;
- (IBAction)smoothImage:(UIButton *)sender;
- (IBAction)sendSnap:(UIButton *)sender;


@end

