{- | A little tutorial to CλaSH
-}
module CLaSH.Tutorial (
  -- * Introduction
  -- $introduction

  -- * MAC Example
  -- $mac_example

  -- * Conclusion
  -- $conclusion

  -- * Errors and their solutions
  -- $errorsandsolutions

  -- * Haskell stuff that the CλaSH compiler does not support
  -- $unsupported
  )
where

{- $introduction
-}

{- $mac_example
-}

{- $conclusion
-}

{- $errorsandsolutions

* __Type error: Couldn't match expected type ‘Signal (a,b)’ with actual type__
  __‘(Signal a, Signal b)’__:

    Signals of product types and product types (to which tuples belong) of
    signals are __isomorphic__, but not (structurally) equal. Use the
    'CLaSH.Signal.Implicit.pack' function to convert from a product type to the
    signal type. So if your code which gives the error looks like:

    @
    ... = f a b (c,d)
    @

    add the 'CLaSH.Signal.Implicit.pack' function like so:

    @
    ... = f a b (pack (c,d))
    @

    Product types supported by 'CLaSH.Signal.Implicit.pack' are:

    * All tuples until and including 8-tuples
    * The 'CLaSH.Sized.Vector.Vec'tor type

    NB: Use 'CLaSH.Signal.Explicit.cpack' when you are using explicitly
    clocked 'CLaSH.Signal.Explicit.CSignal's

* __Type error: Couldn't match expected type ‘(Signal a, Signal b)’ with__
  __ actual type ‘Signal (a,b)’__:

    Product types (to which tuples belong) of signals and signals of product
    types are __isomorphic__, but not (structurally) equal. Use the
    'CLaSH.Signal.Implicit.unpack' function to convert from a signal type to the
    product type. So if your code which gives the error looks like:

    @
    (c,d) = f a b
    @

    add the 'CLaSH.Signal.Implicit.unpack' function like so:

    @
    (c,d) = unpack (f a b)
    @

    Product types supported by 'CLaSH.Signal.Implicit.unpack' are:

    * All tuples until and including 8-tuples
    * The 'CLaSH.Sized.Vector.Vec'tor type

    NB: Use 'CLaSH.Signal.Explicit.cunpack' when you are using explicitly
    clocked 'CLaSH.Signal.Explicit.CSignal's

* __CLaSH.Normalize(94): Expr belonging to bndr: \<FUNCTION\> remains__
  __recursive after normalization__:

    * If you actually wrote a recursive function, rewrite it to a non-recursive
      one :-)

    * You defined a recursively defined value, but left it polymorphic:

    @
    topEntity x y = acc
    where
      acc = register 3 (x*y + acc)
    @

    The above function, works for any number-like type. This means that @acc@ is
    a recursively defined __polymorphic__ value. Adding a monomorphic type
    annotation makes the error go away.

    @
    topEntity :: Signal (Signed 8) -> Signal (Signed 8) -> Signal (Signed 8)
    topEntity x y = acc
    where
      acc = register 3 (x*y + acc)
    @

* __CLaSH.Normalize.Transformations(155): InlineNonRep: \<FUNCTION\> already__
  __inlined 100 times in:\<FUNCTION\>, \<TYPE\>__:

    You left the @topEntity@ function polymorphic or higher-order: use
    @:t topEntity@ to check if the type is indeed polymorphic or higher-order.
    If it is, add a monomorphic type signature, and / or supply higher-order
    arguments.

* __Can't make testbench for: \<LONG_VERBATIM_COMPONENT_DESCRIPTION\>__:

    * Don't worry, it's actually only a warning.

    * The @topEntity@ function does __not__ have exactly 1 argument. If your
      @topEntity@ has no arguments, you're out of luck for now. If it has
      multiple arguments, consider bundling them in a tuple.

-}

{- $unsupported
Here is a list of Haskell features which the CλaSH compiler cannot synthesize
to VHDL (for now):

  [@Recursive functions@]

    Although it seems rather bad that a compiler for a
    functional language does not support recursion, this bug/feature of the
    CλaSH compiler is amortized by the builtin knowledge of all the functions
    listed in "CLaSH.Sized.Vector". And as you saw in this tutorial, the
    higher-order functions of "CLaSH.Sized.Vector" can cope with many of the
    recursive design patterns found in circuit design.

    Also note that although recursive functions are not supported, recursively
    (tying-the-knot) defined values are supported (as long as these values do
    not have a function type). An example that uses recursively defined values
    is the following function that performs one iteration of bubble sort:

    @
    sortVL xs = vmap fst sorted <: (snd (vlast sorted))
     where
       lefts  = vhead xs :> vmap snd (vinit sorted)
       rights = vtail xs
       sorted = vzipWith compareSwapL (lazyV lefts) rights
    @

    Where we can clearly see that 'lefts' and 'sorted' are defined in terms of
    each other.

  [@Recursive datatypes@]

    The CλaSH compiler needs to be able to determine a bit-size for any value
    that will be represented in the eventual circuit. More specifically, we need
    to know the maximum number of bits needed to represent a value. While this
    is trivial for values of the elementary types, sum types, and product types,
    putting a fixed upper bound on recursive types is not (always) feasible.
    The only recursive type that is currently supported by the CλaSH compiler
    is the 'CLaSH.Sized.Vector.Vec'tor type, for which the compiler has
    hard-coded knowledge.

  [@GADT pattern matching@]

    While pattern matching for regular ADTs is supported, pattern matching for
    GADTs is __not__. The 'CLaSH.Sized.Vector.Vec'tor type, which is also a
    GADT, is __no__ exception! You can use the extraction and indexing functions
    of "CLaSH.Sized.Vector" to get access to individual ranges / elements of a
    'CLaSH.Sized.Vector.Vec'tor.
-}