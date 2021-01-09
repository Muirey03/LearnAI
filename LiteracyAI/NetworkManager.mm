//
//  NetworkManager.m
//  LiteracyAI
//
//  Created by Tommy Muir on 24/11/2020.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#include "BinaryHelper.h"
#include "UIImage+Pixels.h"
#include "NeuralNet.hpp"

@interface NetworkManager ()
- (NeuralNet*)newNetwork:(NSString*)weightsPath;
@end

@implementation NetworkManager

+(NSString*)lettersWeightsPath
{
    return [[NSBundle mainBundle] pathForResource:@"lettersWeights" ofType:@"weights"];
}

+(NSString*)numbersWeightsPath
{
    return [[NSBundle mainBundle] pathForResource:@"numbersWeights" ofType:@"weights"];
}

+(instancetype)sharedInstance
{
    static NetworkManager* instance = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        instance = [NetworkManager new];
    });
    return instance;
}

-(instancetype)init
{
    if ((self = [super init]))
    {
        _lettersNet = [self newNetwork:[NetworkManager lettersWeightsPath]];
        _numbersNet = [self newNetwork:[NetworkManager numbersWeightsPath]];
    }
    return self;
}

- (NeuralNet*)newNetwork:(NSString*)weightsPath
{
    std::vector<unsigned int> architecture;
    std::vector<Eigen::MatrixXf> weights;
    loadWeights(weightsPath.UTF8String, weights, architecture);
    return new NeuralNet(architecture, &weights);
}

-(Eigen::VectorXf)vectorFromImage:(UIImage*)img
{
    //find far edge pixels:
    CGSize size = img.size;
    __block NSUInteger minX = size.width - 1;
    __block NSUInteger minY = size.height - 1;
    __block NSUInteger maxX = 0, maxY = 0;
    [img iteratePixels:^(NSUInteger x, NSUInteger y, uint8_t pixel){
        if (pixel < 0xff)
        {
            if (x < minX) minX = x;
            if (y < minY) minY = y;
            if (x > maxX) maxX = x;
            if (y > maxY) maxY = y;
        }
        return YES;
    }];

    //crop image:
    CGFloat croppedWidth = maxX - minX;
    CGFloat croppedHeight = maxY - minY;
    CGRect croppedRect = CGRectMake(minX, minY, croppedWidth, croppedHeight);
    UIGraphicsBeginImageContextWithOptions(croppedRect.size, YES, 1.);
    [img drawInRect:CGRectMake(-croppedRect.origin.x, -croppedRect.origin.y, size.width, size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //render in 28x28 grid, with margin:
    CGSize finalSize = CGSizeMake(28., 28.);
    UIGraphicsBeginImageContextWithOptions(finalSize, YES, 1.);
    //fill white background:
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, finalSize.width, finalSize.height));
    //render smaller version in context:
    const CGFloat margin = 1;
    CGFloat largestLength = MAX(croppedWidth, croppedHeight);
    CGFloat innerSize = finalSize.width - 2 * margin;
    CGSize scaledSize = CGSizeMake(croppedWidth / largestLength * innerSize, croppedHeight / largestLength * innerSize);
    CGFloat startX = (finalSize.width - scaledSize.width) / 2;
    CGFloat startY = (finalSize.height - scaledSize.height) / 2;
    CGRect renderFrame = CGRectMake(startX, startY, scaledSize.width, scaledSize.height);
    [img drawInRect:renderFrame];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    __block Eigen::VectorXf vec = Eigen::VectorXf::Zero(finalSize.width * finalSize.height);
    [img iteratePixels:^(NSUInteger x, NSUInteger y, uint8_t pixel){
        unsigned i = x * finalSize.width + y;
        vec[i] = 0xff - pixel;
        return YES;
    }];
    return vec;
}

-(char)evaluateLetter:(UIImage*)img
{
    Eigen::VectorXf x = [self vectorFromImage:img];
    Eigen::VectorXf h = _lettersNet->go(x);
    unsigned guess = NeuralNet::findLargest(h);
    
    const char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return alphabet[guess];
}

-(unsigned)evaluateNumber:(UIImage*)img
{
    Eigen::VectorXf x = [self vectorFromImage:img];
    Eigen::VectorXf h = _numbersNet->go(x);
    return NeuralNet::findLargest(h);
}

-(void)dealloc
{
    delete _lettersNet;
    delete _numbersNet;
}
@end
