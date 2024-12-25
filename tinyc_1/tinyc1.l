%{
#define Keyword 1
#define Constant 2
#define Identifier 3
#define String_literal 4
#define Punctuator 5
#define Comments 6

%}


keyword auto|unsigned|enum|restrict|break|extern|return|void|case|float|volatile|short|char|for|signed|while|const|goto|sizeof|_Bool|continue|if|else|static|_Complex|default|inline|struct|_Imaginary|do|int|switch|double|long|typedef|register|union


identifier-nondigit [a-zA-Z]
digit [0-9]
non_zero_digit [1-9]

identifier {identifier-nondigit}({identifier-nondigit}|{digit})*

integer_constant ({non_zero_digit}{digit}*)
escape-sequence \\['"\\?abfnrtv]
c-char ([^'\\\\n])|({escape-sequence})
c-char-sequence {c-char}+
character_constant {c-char-sequence}
digit-sequence {digit}+
sign [-+]
exponent-part [eE]{sign}?{digit-sequence}
fractional-constant ({digit-sequence}?\.{digit-sequence})|{digit-sequence}\.
floating-constant  ({fractional-constant}{exponent-part}?)|({digit-sequence}{exponent-part})
constant ({integer_constant})|({floating-constant})|('{c-char-sequence}')

s-char  ([^"\\\n])|\\['"\\?abfnrtv]
s-char-sequence {s-char}+
string-literal \"{s-char}*\"



punctuator "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"\/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"\/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

single_line_comment ("//")[^\n\r]*
multiline_comment  ("/*")([^*]|(\*[^/]))*("*/")
comments {single_line_comment}|{multiline_comment}


%%
{keyword}   {return(Keyword);}


{identifier} {return(Identifier);}


{constant}  {return(Constant);}


{string-literal} {return(String_literal);}


{punctuator} {return(Punctuator);}


{comments}   {return(Comments);}
%%
int yywrap(void)
{
    return 1;
}