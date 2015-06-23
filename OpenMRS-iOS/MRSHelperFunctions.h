//
//  MRSHelperFunctions.h
//  OpenMRS-iOS
//
//  Created by Yousef Hamza on 6/16/15.
//  Copyright (c) 2015 Erway Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRSHelperFunctions : NSObject

+ (NSArray *)allPropertyNames:(id)forClass;
+ (BOOL)isNull:(id)object;
+ (NSString *) formLabelToJSONLabel:(NSString *) label;
@end