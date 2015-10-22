//
//  ModelCell.m
//  autohome
//
//  Created by vincent on 9/5/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "ModelCell.h"

@implementation ModelCell

+ (id)DataInit:(NSMutableArray *)data  act:(NSString *)act type:(NSString *)type{
    
    return [[ModelCell alloc] initWithData:data act:act type:type];
    
}


- (id)initWithData:(NSMutableArray *)data  act:(NSString *)act type:(NSString *)type
{
    self.data = data;
    self.act = act;
    self.type = type;
    
    return self;
}
@end
