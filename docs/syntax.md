---
title: Just programing language
author: Ben Sivan
---

# Just overview

The name just is a combination of the words julia and rust. The idea is to create a programing language with scripting like syntax similiar to julia, and make it easily compiled into an excecutable like rust, and also having borrow checker instead of garbage collector.
As oppose to both of those langauges, just is enspired to be minimalist similiarly to lua.


# Syntax for the Just programing language

## variable assignment
```
num = 5
char = 'c'
name = "John"
price = 10.99
answer = true
```

using 'mutable':
```
mutable num = 5
```

## Functions
```
function name()
    action
end
```

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

