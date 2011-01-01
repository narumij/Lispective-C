//
//  Env.m
//  Lispective_c
//
//  Created by narumij on 11/01/01.
//  Copyright 2011 narumij. All rights reserved.
//

#import "Env.h"
#import "StdlibProcedures.h"

@interface Env()
@property(nonatomic,retain) NSMutableDictionary *dict;
@end


@implementation Env
@synthesize outer,dict;
- (id) init
{
	self = [super init];
	if (self != nil) {
		self.dict = [NSMutableDictionary dictionary];
	}
	return self;
}
+(Env*)envWithParams:(NSArray *)params args:(NSArray *)args outer:(Env*)outer_
{
	Env *newEnv = [Env new];
	newEnv.outer = outer_;
	for(int i = 0; i < [params count] && i < [args count]; ++i )
		[newEnv.dict setValue:[args objectAtIndex:i] forKey:[params objectAtIndex:i]];
	return [newEnv autorelease];
}
+(Env*)defaultEnv
{
	Env *newEnv = [Env new];
	[newEnv setAtom:mulOperator forSymbol:@"*"];
	[newEnv setAtom:subOperator forSymbol:@"-"];
	[newEnv setAtom:zerop forSymbol:@"zerop"];
	return [newEnv autorelease];
}
-(Env*)find:(NSString *)symbol
{
	if ( [[dict allKeys] containsObject:symbol] )
		return self;
	return [outer find:symbol];
}
-(id)atomForSymbol:(NSString *)symbol
{
	return [dict valueForKey:symbol];
}
-(void)setAtom:(id)atom forSymbol:(NSString *)symbol
{
	[dict setValue:atom forKey:symbol];
}
@end

