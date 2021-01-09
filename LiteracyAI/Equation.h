//
//  Equation.h
//  LiteracyAI
//
//  Created by Tommy Muir on 04/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Equation : NSObject
@property (nonatomic, strong, readonly) NSString* question;
@property (nonatomic, readonly) unsigned answer;
- (instancetype)initWithQuestion:(NSString*)question;
@end

NS_ASSUME_NONNULL_END
