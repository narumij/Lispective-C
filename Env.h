//
//  Env.h
//  Lispective_c
//
//  Created by narumij on 11/01/01.
//  Copyright 2011 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Env : NSObject
{
	NSMutableDictionary *dict;
	Env *outer;
}
@property(nonatomic,retain) Env *outer;
+(Env*)envWithParams:(NSArray *)params args:(NSArray *)args outer:(Env*)outer_;
+(Env*)defaultEnv;
-(Env*)find:(NSString *)symbol;
-(id)atomForSymbol:(NSString *)symbol;
-(void)setAtom:(id)atom forSymbol:(NSString *)symbol;
@end
