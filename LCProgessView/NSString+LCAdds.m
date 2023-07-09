//
//  NSString+LCAdds.m
//  LCProgessView
//
//  Created by 陆兴凯 on 2023/7/9.
//

#import "NSString+LCAdds.h"

@implementation NSString (LCAdds)

- (BOOL)lc_isValidString {
    if ([self isEqualToString:@"null"] || [self isEqualToString:@"NULL"] || [self isEqualToString:@"nil"] || [self isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

@end
