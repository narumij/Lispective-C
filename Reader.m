//
//  Reader.m
//  Lispective_c
//
//  Created by narumij on 11/01/01.
//  Copyright 2011 narumij. All rights reserved.
//

#import "Reader.h"

NSArray *Tokenize(NSString* s)
{
	NSArray *anArray = [[[s stringByReplacingOccurrencesOfString:@"(" withString:@" ( "]
						 stringByReplacingOccurrencesOfString:@")" withString:@" ) "]
						componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSMutableArray *tokens = [NSMutableArray array];
	for (NSString *token in anArray) {
		if ( ![token isEqualToString:@""] )
			[tokens addObject:token];
	}
	return [NSArray arrayWithArray:tokens];
}

id IntAtom( NSString *token )
{
	if ( [token isEqualToString:@"0"] )
		return [NSNumber numberWithInt:0];
	
	for( int i = 0; i < [token length]; ++i )
		if ( [token characterAtIndex:i] < '0' || '9' < [token characterAtIndex:i] )
			return nil;
	
	return [NSNumber numberWithInt:[token intValue]];
}

id DoubleAtom( NSString *token )
{
	NSNumberFormatter *numFormatter = [[NSNumberFormatter new] autorelease];
	return [numFormatter numberFromString:token];
}

id atom(NSString *token)
{
	id intAtom = IntAtom(token);
	if ( intAtom )
	{
//		NSLog(@"intAtom -> %@ %s",intAtom,[intAtom objCType]);
		return intAtom;
	}
	NSNumber *num = DoubleAtom(token);
	if ( num )
	{
//		NSLog(@"num -> %@ %s",num,[num objCType]);
		return num;
	}
//	NSLog(@"symbol -> %@",token);
	return token;
}

id ReadFrom( NSArray **tokens )
{
	if ( [*tokens count] == 0 )
	{
        NSLog(@"unexpected EOF while reading");
		return nil;
	}
	NSString *token = nil;
	token = [*tokens objectAtIndex:0];
	*tokens = [*tokens subarrayWithRange:NSMakeRange(1, [*tokens count] - 1)];
	if ( [token isEqualToString:@"("] )
	{
		NSArray *L = [NSArray array];
		while ( ![[*tokens objectAtIndex:0] isEqualToString:@")"] )
		{
			id anAtom = ReadFrom(tokens);
			if ( anAtom )
				L = [L arrayByAddingObject:anAtom];
		}
		*tokens = [*tokens subarrayWithRange:NSMakeRange(1, [*tokens count] - 1)];
		return L;
	}
	else if ( [token isEqualToString:@")"] )
	{
		NSLog(@"unexpected )");
		return nil;
	}
	else
		return atom(token);
}

id Read( NSString *program )
{
	NSArray *tokens = Tokenize(program);
	return ReadFrom(&tokens);
}
