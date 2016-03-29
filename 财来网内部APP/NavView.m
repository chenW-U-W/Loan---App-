//
//  NavView.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/30.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "NavView.h"

@implementation NavView


- (IBAction)goBackToprevious:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goBack" object:nil];
}
@end
