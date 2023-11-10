the language is called 'just' which mainly represents it's minimalist ideals, but also came from the combinations of the names julia and rust. 
a bit of background and disclaimers, I'm not by any mean a compiler guy and I don't have the skill set to hack the way I want the language from scratch. I explored multiple angles for this project and decided that at least as a proof of concept the best strategy for me is to go the typescript way on the lua programming language in the sense that I'm writing a translation program that converts the just code to lua and from there uses all the lua interpreter and eco system downstream. 

in what sense is that language resembles it's inspirational predecessors?
is terms of syntax it is mostly inspired from julia, which is pretty similiar to lua but with some syntax tweeks.
it is having all the benefits of lua because the end product is a proper lua program which means embbedability, portability and tiny over head for the programmer.
from rust it is firstly takes immutability by default, but I inspire to implement borrow checker of some sort in the future.

syntax sugar ahead!
- local by default, instead of writing 'local' before most variable assignment, unless you add 'global' it is 'local'.
- immutability by default, any variable assignment is <const> unless defined 'mutable'. also global variable can not by mutable.
- changing multiline comment and string notation, in the lua compile the core team desided to combine the multiline-string and multiline-comment in a single function. here are the implications:
single line comment is common and beatifull with doble dash '--'.
single line string can be notated wtih single and double qoutes.
multi line comment became --[[ ]] and multiline string [[ ]] which breaks my brain because the comment is not simetric and the string doesn't resemble any other commmon notation like qoute sings. 
I changed multiline comment to --> <-- which still preserve the double dash sign and also gives it simetry and oriabtation.
similiar to julia and many other languages I changed the multiline strings to trilplet of double qoutes """ """.
changing nigation sign from tilda ~ to bang sign !
removing redundent keywords from loops and conditionals like 'do' and 'then' at the end of the statement.
writing base library of utilities like length function instead of #.
slice function that excepts both table and strings.
copy function that can create a copy of variable or any complex table instead of unpack manualy.
empty function that creats the empty representation of any type similiar to the 'go' implementation 
using function that enables global loading of function from a module (which is just a table of names as keys and functions as values).

conclusion:
nothing in this work is aims towords making the lua language more preforment, flexeble etc.
it is all just utilities and syntax sugar to help it be more palatable for begginers and  me :)

happy coding

help me write an article about my new programming language.
keep it in the spirit of my writing. fill free to correct grammer and spelling.
keep it modest and short.
restructure as needed for clarity