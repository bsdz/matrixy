#Discussion about using namespaces in Matrixy

# Introduction #

"Standard" M doesn't have support for namespacing. We would like to add it to Matrixy for a variety of reasons:

# To keep our list of functions clean, especially functions that are part of our "standard library" but aren't included with other M implementations by default
# To interoperate with other environments in the Parrot platform, including using functions written in other programming languages.

# Basic Namespace/Function Handling #

## Like Perl (sort of) ##

This is going to be a little Perlish. Has the benefit that the "::" symbol isn't used elsewhere in M, so we are free to steal it for our purposes:

```
use("Other::Namespace");    % import another namespace so all symbols in it are
                            % visible in the "main" namespace by default

namespace::function();      % Call a function in a second namespace without importing
                            % Function must support Matrixy calling conventions

```

## More M Idiomatic ##

```
addnamespace("Other.Namespace");
namespace.function()        % Interesting, but we're going to run into parser
                            % ambiguities determining if this is a namespaced
                            % function or a member of a struct
```

## With the @ Symbol ##

```
namespace@function()        % Alternative: The @ symbol makes it clear that we're
                            % referencing the function relative to the namespace
x = @namespace@function()   % Function handle to a function in namespace
```

# Alternate Calling Conventions #

If we want to call functions that don't subscribe to our calling conventions, we could do either:

## Call directly ##

Use some kind of delimiter syntax to let it know that the call doesn't follow our normal dispatch:

```
Parrot.func();
```

or use a symbol to mark a function as using a plain convention:

```
~func();
```

## Call indirectly ##

Instead of calling a non-native M function directly, use a wrapper function to handle calls:

```
callexternfunction(namespace, funcname, args);
```

We could have special functions for various special calling targets:

```
callinternalfunction(funcname, args);  % ["_Matrixy";"builtins"]
callperl6function(funcname, args);
callpirfunction(funcname, args);
```