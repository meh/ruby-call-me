Various calling related functionalities
=======================================

memoization (supports 1.8)
--------------------------
I wasn't completely happy with the actual memoization gems so I made one myself.

```ruby
require 'call-me/memoize'

class Perl
  memoize
  def version
    `perl -MConfig -e 'print $Config{version};'`
  end
end

p = Perl.new
p.version # this will execute the method and cache the result
# subsequent calls will get the result from the cache

p.memoize_clear(:version) # this will clear the cache for version only
p.memoize_clear # this will clear the cache for every memoize method
# the caching is instance based, not class based, if you want class based
# caching just make a singleton :)

p.memoize_cache # this will return the cache (which is a simple Hash)
```

Memoizing already present classes from others code:

```ruby
class Shortie::Service
  class << self
    memoize :find_by_key
  end

  memoize :shorten
end
```

named parameters (supports 1.8)
-------------------------------
Stupid and ugly named parameters.

Some examples:

```ruby
require 'call-me/named'

class LOL
  named :a, :b, :c, :optional => 0 .. -1
  def lol (a=1, b=2, c=3)
    [a, b, c]
  end

  named :a, :b, :c, :optional => [:a => 1, :b => 2, :c => 3]
  def omg (a=1, b=2, c=3)
    [a, b, c]
  end

  named def wat (a, b)
    [a, b]
  end
end

l = LOL.new


l.lol                          # [1, 2, 3]
l.lol(3, 2)                    # [3, 2, 3]
l.lol(:a => true)              # [true, 2, 3]
l.lol(:a => true, :b => false) # [true, false, 3]
l.lol(:a => true, :c => false) # [true, nil, false]
l.omg(:a => true, :c => false) # [true, 2, false]
l.wat(1, 2)                    # [1, 2]
l.wat(:b => 2, :a => 1)        # [1, 2] on 1.9, exception on 1.8
l.wat(2 => 2, 1 => 1)          # [1, 2] on 1.8 too
````

Please note that the last call has `nil` in b, this is because there's no way
to tell Ruby _this parameter should be filled with the optional value_, so
if you want people to use it that way, make sure to use `nil` and set the default
value on `nil` OR make the optionals explicit and give them a value

overloading
-----------
Stupid and ugly overloading

Some examples:

```ruby
require 'call-me/overload'

class LOL
  def_signature Integer
  def lol (a)
    a * 2
  end

  def_signature String
  def lol (str)
    str * 2
  end
end

l = LOL.new

l.lol 2     # 4
l.lol "lol" # "lollol"
l.lol       # exception: ArgumentError: the arguments don't match any signature
```
