//
//  Procedure.m
//  Lispective_c
//
//  Created by narumij on 11/01/01.
//  Copyright 2011 narumij. All rights reserved.
//

#import "Procedure.h"
#import "Env.h"

#if 0
#define NSLOG( ... ) NSLog( __VA_ARGS__ )
#else
#define NSLOG( ... ) 
#endif

BOOL IsSymbol( id atom )
{
	return [atom isKindOfClass:[NSString class]];
}

BOOL IsList( id atom )
{
	return [atom isKindOfClass:[NSArray class]];
}

BOOL BoolEval( id atom )
{
	if ( [atom isKindOfClass:[NSNumber class]] )
		return [atom boolValue];
	return atom != nil;
}

id Eval( id x, Env *env )
{
	NSLOG(@"eval %@",x);
	if ( IsSymbol(x) )
	{
		id atom = [[env find:x] atomForSymbol:x];
		NSLOG(@"symbolp %@",atom);
		return atom;
	}
	
	if ( !IsList(x) )
	{
		NSLOG(@"!listp %@",[x class]);
		return x;
	}
	
	id first = [x objectAtIndex:0];

	if ( [first isEqual:@"quote"] )
	{
		NSLOG(@"quote");
		id exp = [x objectAtIndex:1];
		return exp;
	}
	
	if ( [first isEqual:@"if"] )
	{
		NSLOG(@"if");
		id test = [x objectAtIndex:1];
		id conseq = [x objectAtIndex:2];
		id alt = [x objectAtIndex:3];
		return Eval( BoolEval( Eval(test,env) ) ? conseq : alt, env );
	}
	
	if ( [first isEqual:@"set!"] )
	{
		id var = [x objectAtIndex:1];
		id exp = [x objectAtIndex:2];
		NSLOG(@"var : %@ - exp : %@",var,exp);
		id result = Eval(exp,env);
		NSLOG(@"set! %@ %@",var,result);
		[[env find:var] setAtom:result forSymbol:var];
		NSLOG(@"env[%@] = %@",var,[[env find:var] atomForSymbol:var]);
		return nil;
	}
	
	if ( [first isEqual:@"define"] )
	{
		id var = [x objectAtIndex:1];
		id exp = [x objectAtIndex:2];
//		NSLOG(@"var : %@ - exp : %@",var,exp);
		id result = Eval(exp,env);
		NSLOG(@"define %@ %@",var,result);
		[env setAtom:result forSymbol:var];
		NSLOG(@"env[%@] = %@",var,[env atomForSymbol:var]);
		return nil;
	}

	if ( [first isEqual:@"lambda"] )
	{
		NSLOG(@"lambda");
		id var = [x objectAtIndex:1];
		id exp = [x objectAtIndex:2];
		return Lambda(exp, env, var);
	}

	if ( [first isEqual:@"begin"] )
	{
		NSLOG(@"begin");
		id val = nil;
		NSArray *exps = [x subarrayWithRange:NSMakeRange(1, [x count] - 1)];
		for( id exp in exps )
			val = Eval(exp,env);
		return val;
	}
	NSLOG(@"main");

	NSMutableArray *exps = [NSMutableArray array];
	for( id exp in x )
		[exps addObject:Eval(exp,env)];
	ProcedureBlock proc = [exps objectAtIndex:0];
	[exps removeObjectAtIndex:0];
	return proc(exps);
}

ProcedureBlock Lambda(id exp, Env *env, NSArray* vars )
{
	NSLOG(@"LAMBDA -> %@",exp);
	ProcedureBlock aBlock;
	aBlock = ^(NSArray *args){
		return Eval( exp, [Env envWithParams:vars args:args outer:env]);
	};
	return [[aBlock copy] autorelease];
}





