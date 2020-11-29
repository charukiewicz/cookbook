#!/bin/bash

echo "What's the name of the project?"
read PROJECT_NAME

# An example working with a multiline string using the
# 'here-document' instruction, indicated by the <<- operator.
# The 'EOF' after the operator is the delimiter which defines
# where the multiline string will end.
#
# Each line in the template starts with a tab character (\t)
# that is stripped from the string. The dash (-) at the end of
# the <<- operator will strip away all leading tab characters
# in the multiline string. The << operator can be used if this
# behavior is undesirable.
TEMPLATE=$(cat <<- EOF
	module $PROJECT_NAME where

	import Data.List as List
	import Data.Maybe as Maybe

	main = putStrLn "Hello $PROJECT_NAME"
EOF
)

# Wrapping the $TEMPLATE variable in quotes is necessary
# to preserve the newlines (\n) in the output.
echo "$TEMPLATE" > "$PROJECT_NAME.hs"
