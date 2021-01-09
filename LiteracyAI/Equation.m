//
//  Equation.m
//  LiteracyAI
//
//  Created by Tommy Muir on 04/01/2021.
//

#import "Equation.h"

@implementation Equation
- (instancetype)initWithQuestion:(NSString*)question {
    if ((self = [self init])) {
        _question = [[question stringByReplacingOccurrencesOfString:@"*" withString:@"x"] stringByReplacingOccurrencesOfString:@"/" withString:@"÷"];
        
        NSExpression* expr = [NSExpression expressionWithFormat:question];
        _answer = (unsigned)[(NSNumber*)[expr expressionValueWithObject:nil context:nil] unsignedIntegerValue];
    }
    return self;
}
@end
