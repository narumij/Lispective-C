//
//  StdlibProcedures.m
//  Lispective_c
//
//  Created by narumij on 11/01/01.
//  Copyright 2011 narumij. All rights reserved.
//

#import "StdlibProcedures.h"

ProcedureBlock mulOperator = ^(NSArray *args){
	id result = nil;
	result = [NSNumber numberWithDouble:[[args objectAtIndex:0] doubleValue] * [[args objectAtIndex:1] doubleValue]];
	return result;
};

ProcedureBlock subOperator = ^(NSArray *args){
	id result = nil;
	result = [NSNumber numberWithDouble:[[args objectAtIndex:0] doubleValue] - [[args objectAtIndex:1] doubleValue]];
	return result;
};

ProcedureBlock zerop = ^(NSArray *args){
	id result = nil;
	result = [NSNumber numberWithBool:[[args objectAtIndex:0] intValue] == 0];
	assert(result);
	return result;
};
