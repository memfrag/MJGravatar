//
//  Copyright (c) 2013 Martin Johannesson
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//  (MIT License)
//

#if !__has_feature(objc_arc)
#error ARC must be enabled!
#endif

#import "MJGravatar.h"
#import <CommonCrypto/CommonDigest.h>

@interface MJGravatar ()

@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, strong) NSURL *url;

@end

@implementation MJGravatar

+ (id)gravatarWithEmailAddress:(NSString *)address {
    return [[MJGravatar alloc] initWithEmailAddress:address];
}

- (id)initWithEmailAddress:(NSString *)address
{
    self = [super init];
    if (self) {
        _address = [address copy];
        _url = [self avatarURL:address];
    }
    return self;
}

- (NSURL *)avatarURL:(NSString *)address {
    NSString *hash = [self hashAddress:address];
    NSURL *baseURL = [NSURL URLWithString:@"http://www.gravatar.com/avatar/"];
    NSURL *avatarURL = [NSURL URLWithString:hash
                              relativeToURL:baseURL];
    return avatarURL;
}

// 1px to 2048px (default 80px)
- (NSURL *)urlWithImageSize:(NSUInteger)size {
    NSString *baseURL = [_url absoluteString];
    NSString *urlString = [NSString stringWithFormat:@"%@?s=%u", baseURL, size];
    NSURL *avatarURL = [NSURL URLWithString:urlString];
    return avatarURL;
}

- (NSString *)hashAddress:(NSString *)address {
    
    NSString *trimmed = [address stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *hashable = [trimmed lowercaseString];
    NSData *addressData = [hashable dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char md5[16];
    CC_MD5(addressData.bytes, addressData.length, md5);
    NSString *format = @"%02x%02x%02x%02x%02x%02x%02x%02x"
                        "%02x%02x%02x%02x%02x%02x%02x%02x";
    return [NSString stringWithFormat:format, md5[0], md5[1], md5[2], md5[3],
                                              md5[4], md5[5], md5[6], md5[7],
                                              md5[8], md5[9], md5[10], md5[11],
                                              md5[12], md5[13],
                                              md5[14], md5[15]];
}

@end
