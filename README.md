[![Build Status](https://secure.travis-ci.org/billdueber/ruby-marc-marc4j.png)](http://travis-ci.org/billdueber/ruby-marc-marc4j)


# ruby-marc-marc4j

Convert ruby-marc `MARC::Record` objects to/from java marc4j `org.marc4j.marc.Record` objects under JRuby.

Useful if you're working in JRuby and need to use a marc4j reader, or if you want to use a standard ruby-marc reader but
spool some functionality out to java code that relies on marc4j obejcts.

* [Homepage](https://github.com/billdueber/ruby-marc-marc4j)
* [Issues](https://github.com/billdueber/ruby-marc-marc4j/issues)


## Creating a converter

You can load up the `marc4j` jar file in three ways:

* Just require it yourself at the top of a file. `MARC::MARC4J` will detect that it's already been loaded and not try to load another copy.

```ruby

require 'marc/marc4j'
require '../jarfiles/marc4j_2.5.jar'
converter = MARC::MARC4J.new # will use above jarfile
```

* Call `MARC::MARC4J.new(:jardir=>'/path/to/marc4j/jar/directory')` to state where your jar files live

```ruby
require 'marc/marc4j'
converter = MARC::MARC4J.new(:jardir => '../jarfiles/') # Load all .jar files in ../jarfiles
```

* Call `MARC::MARC4J.new` without a `:jarfile` argument to use the bundled marc4j jarfile.

```ruby
require 'marc/marc4j'

converter = MARC::MARC4J.new  # uses bundled marc4j jarfile unless marc4j is already loaded
```

## Logging

You can also pass in a logger object, that responds to the normal `debug`/`warn`/etc.

```ruby

require 'marc/marc4j'
require 'my/logging/library'

logger  = My::Logging::Library.new(opts)
converter = MARC::MARC4J.new(:logger=>logger)
```


## Doing the conversions

A converter only has two useful methods:

* `marc4j = converter.rubymarc_to_marc4j(r)` will convert a ruby-marc `MARC::Record` object to a marc4j record
* `rmarc  = converter.marc4j_to_rubymarc(j)` will convert a marc4j record to a ruby `MARC::Record` object


## Implementation details worth knowing

* The converter doesn't do any caching at all, so if you want to only do the conversion once, you need to
stick the result somewhere. 

* `marc4j` records are built using a marc4j factory object. This defaults to a `org.marc4j.marc.MarcFactory`, but will
use whatever class is in the java system property `org.marc4j.marc.MarcFactory` (as seen in the [marc4j source code](https://github.com/marc4j/marc4j/blob/master/src/org/marc4j/marc/MarcFactory.java#L47)).

## Install

    $ gem install ruby-marc-marc4j

## Copyright

Copyright (c) 2013 Bill Dueber

See {file:LICENSE.txt} for details.
