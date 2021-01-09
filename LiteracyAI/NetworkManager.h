//
//  NetworkManager.h
//  LiteracyAI
//
//  Created by Tommy Muir on 24/11/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct NeuralNet;

@interface NetworkManager : NSObject
@property (nonatomic, assign) struct NeuralNet* lettersNet;
@property (nonatomic, assign) struct NeuralNet* numbersNet;
+(instancetype)sharedInstance;
-(char)evaluateLetter:(UIImage*)img;
-(unsigned)evaluateNumber:(UIImage*)img;
@end

NS_ASSUME_NONNULL_END
