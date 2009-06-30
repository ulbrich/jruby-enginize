#!/bin/sh
# Utility script for splitting the JRuby JAR into two smaller JAR files. This
# is a workaround for a limitation of the JAR size in Google AppEngine.
#
# The code for this script has been taken from hints and links found at
# http://jruby-rack.appspot.com.

SCRIPTHOME=`dirname $0`
JRUBY=`which jruby`

if [ ! -x "$JRUBY" ]; then
  echo "!!Missing jruby executable. Please check installation." > /dev/stderr
  exit 1
fi

# See where the jruby binary is installed and find the JRuby JAR from there.

PREFIX=`dirname \`dirname $JRUBY\``
JARFILE="$PREFIX/share/java/jruby/lib/jruby-complete.jar"

if [ ! -f "$JARFILE" ]; then
  PREFIX=`dirname \`dirname $JRUBY\``
  JARFILE="$PREFIX/lib/jruby-complete.jar"
fi

if [ ! -f "$JARFILE" ]; then
  echo "!!Missing JRuby JAR. Please check installation." > /dev/stderr
  exit 1
fi

echo "Using $JARFILE for splitting"
echo "and assembling a AppEngine savvy version of the JRuby JAR in the lib "
echo "directory."

cd $SCRIPTHOME

rm -rf jruby-core.jar
rm -rf ruby-stdlib.jar
rm -rf tmp_unpack

mkdir -p tmp_unpack
cd tmp_unpack

jar xf $JARFILE

cd ..

mkdir -p jruby-core

mv tmp_unpack/org jruby-core
mv tmp_unpack/com jruby-core
mv tmp_unpack/jline jruby-core
mv tmp_unpack/jay jruby-core
mv tmp_unpack/jruby jruby-core

cd jruby-core

jar cf ../jruby-core.jar .

cd ../tmp_unpack

jar cf ../ruby-stdlib.jar .

cd ..

rm -rf jruby-core
rm -rf tmp_unpack
