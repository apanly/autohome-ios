//
//  ModelCell.h
//  autohome
//
//  Created by vincent on 9/5/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCell : NSObject
@property(strong,nonatomic) NSString *type;
@property(strong,nonatomic) NSString *act;
@property(strong,nonatomic) NSMutableArray *data;

- (id)initWithData:(NSMutableArray *)data  act:(NSString *)act type:(NSString *)type;

+ (id)DataInit:(NSMutableArray *)data  act:(NSString *)act type:(NSString *)type;
@end
