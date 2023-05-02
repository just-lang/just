---
title: Just programing language
author: Ben Sivan
---

# Just overview

The name just is a combination of the words julia and rust. The idea is to create a programing language with scripting like syntax similiar to julia, and make it easily compiled into an excecutable like rust, and also having borrow checker instead of garbage collector.
As oppose to both of those langauges, just is enspired to be minimalist similiarly to lua.

- minimalist
- readable
- portable
- memmory efficient

# Syntax for the Just programing language

## variable assignment
```
int num <- 5
string name <- "John"
float price <- 10.99
bool answer <- true
```

'<-' for general assignment (immutable by default)

using 'mutable': 
```
mutable int num <- 5
```

'=' is reserved for arguments and parameters:
```
func(param="foo")
```

'->' is reserved for anonimous functions:
```
apply(x -> x^2, array)
```

## Functions
```
function name(own ; borrow)
    action
end
```
Arguments of a function are own by default and terminated when out of scope.
To pass a variable without terminating it, it can be borrowed by passing after the ';' seperator and must be immutable.  


## Loops
```
for var in iterable
    action
end
```
```
while condition
    action
end
```

## control flow
```
if condition
    action
else if condition
    action
else
    action
end
```

## operators

add: +
substract: -
multiply: *
devide: /
power: ^

