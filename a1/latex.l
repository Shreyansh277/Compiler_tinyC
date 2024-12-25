%{
#include <stdio.h>
extern void count_command(char *cmd);
extern void count_environment(char *env);
extern void count_inline_math();
extern void count_displayed_math();
%}

%%
%.*\n               { /* Ignore comments */ }

\\\[[^$]*\\\]          { count_displayed_math(); }
"$$"[^$]*"$$"          { count_displayed_math(); }

"$"[^$]*"$"         { count_inline_math(); }

\\begin\{([^\}]+)\} { count_environment(yytext + 7); /* Skip '\\begin{' */ }
\\end\{[^\}]+\}     { /* Ignore \end{...} */ }

~                   { count_command("~"); }
\\[a-zA-Z]+         { count_command(yytext); }
\\[^a-zA-Z\n ]      { count_command(yytext); }

.|\n                { /* Ignore other characters */ }

%%

int yywrap() {
    return 1;
}