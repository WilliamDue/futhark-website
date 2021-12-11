-- # Dex: Monte Carlo estimates of pi
--
-- The following is a port of
-- [pi.dx](https://google-research.github.io/dex-lang/pi.html)

import "dex-prelude"

-- First we import the random number implementation from
-- [random-numbers.fut](random-numbers.html) and define a few wrapper
-- functions.

module random = import "random-numbers"

type Key = random.lcg.rng
def rand = random.rand_f64
def split = random.lcg.split_n
def newKey = random.lcg.init

-- The rest of the definition is pretty much just like how Dex does
-- it.

def estimatePiArea (key:Key) : f64 =
  let (key, x) = rand key
  let (_, y) = rand key
  in 4.0 * f64.bool (sq x + sq y < 1)

def estimatePiAvgVal (key:Key) : f64 =
  let (_, x) = rand key
  in 4.0 * f64.sqrt (1.0 - sq x)

def meanAndStdDev (n: i64) (f: Key -> f64) (key: Key) : (f64, f64) =
  let samps = map f (split n key)
  in (mean samps, std samps)

-- For Futhark, we do need some first-order entry points.

def piAreaMeanAndStdDev n seed = meanAndStdDev n estimatePiArea (newKey seed)

def piAvgValMeanAndStdDev n seed = meanAndStdDev n estimatePiAvgVal (newKey seed)

-- And this is what it looks like:

-- > piAreaMeanAndStdDev 1000000i64 42i32

-- > piAvgValMeanAndStdDev 1000000i64 42i32
