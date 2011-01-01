//
//  Lispective_c.mm
//  Lispective_c
//
//  Created by narumij on 11/01/01.
//  Copyright 2011 narumij. All rights reserved.
//
#import <Foundation/Foundation.h>

extern "C" {
#import "Env.h"
#import "Procedure.h"
#import "Reader.h"
}

#include <iostream>
#include <string>
using namespace std;

NSString *RawInput( NSString *prompt )
{
	cout << [prompt UTF8String];
	string ss;
	std::getline(std::cin, ss);
	return [NSString stringWithUTF8String:ss.c_str()];
}

void Print( id val )
{
	cout << "=> " << [[val description] UTF8String] << endl;
}

void Repl( NSString *prompt )
{
	Env *env = [Env defaultEnv];
	while (1) {
		id val = Eval(Read(RawInput(prompt)), env);
		if ( val )
			Print( val );
	}
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

#if 0
//	NSString *program = @"(begin (define r 3) (* 3.141592653 (* r r)))";
//	NSString *program = @"(begin (define square (lambda (r) (* r r))) (square 3))";
	NSString *program = @"(begin (define fact (lambda (n) (if (zerop n) 1 (* n (fact (- n 1)))))) (fact 5))";
	Env *env = [Env defaultEnv];
	NSLog(@"\n%@",Eval(Read(program),env));
#else	
	Repl(@"Lispective.c>");
#endif
    [pool drain];
    return 0;
}


