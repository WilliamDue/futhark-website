-- # Faking nominal types
--
-- Futhark's type system is entirely structural.  If we want to
-- maintain values of the same representation but of different
-- semantic meaning, and wish to avoid mixing them together, then one
-- trick is to use unary sum types:

type temperature = #temperature f32

type height = #height f32

-- This saves us from ever mixing temperatures and heights, at the
-- cost of having to wrap and unwrap the constructor (this is free at
-- runtime, though).
--
-- However, nominal type systems have another advantage: they can hide
-- the definition.  Futhark's module system supports *abstract types*,
-- which can also hide the definition, but then there is no way to
-- actually get your hands on the concrete value.  In other languages,
-- nominal types are sometimes used to hide a complex type behind a
-- simpler name, with the expectation that this name will also be used
-- in type errors.  In contrast, Futhark's type checker will usually
-- expose all the verbose guts of e.g. large records or sum types in
-- type errors.
--
-- There is a clumsy way to simulate such nominal types using a
-- higher-order module.  We define the parametric module `nominal` as
-- thus:

module nominal (T: { type def }) : {
  type t
  val name : T.def -> t
  val shame : t -> T.def
} = {
  type t = T.def
  let name = id
  let shame = id
}

-- We can then apply it like this:

module temperature = nominal { type def = temperature }
module height = nominal { type def = height }

-- There is now an abstract type `temperature.t` whose definition is
-- completely hidden.  However, the two inverse functions
-- `temperature.name` and `temperature.shame` allow us to convert
-- between `temperature.t` and the `temperature` type:

let x : temperature.t = temperature.name (#temperature 2)

let y : temperature = temperature.shame x

-- It's certainly awkward, but it may come in handy from time to time.
