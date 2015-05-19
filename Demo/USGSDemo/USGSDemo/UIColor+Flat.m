//
//  UIColor+Flat.m
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/19/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import "UIColor+Flat.h"

@implementation UIColor (Flat)
+ (UIColor*)Carrot {
    // rgb(230, 126, 34)
    return [self ColorWithR:230.0 G:126 B:34];
}

+ (UIColor*)Orange {
    //rgb(243, 156, 18)
    return [self ColorWithR:243.0 G:156.0 B:18.0];
}

+ (UIColor*)Turquoise {
    // rgb(26, 188, 156)
    return [self ColorWithR:26.0 G:188.0 B:156.0];
}

+ (UIColor*)Alizarin {
    // rgb(231, 76, 60)
    return [self ColorWithR:231.0 G:76.0 B:60.0];
}

+ (UIColor*) WetAsphalt {
    // rgb(52, 73, 94)
    return  [self ColorWithR:52.0 G:73.0 B:94.0];
}

+ (UIColor*) ColorWithR:(float)r G:(float)g B:(float)b {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
@end
