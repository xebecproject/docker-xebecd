#!/bin/bash
set -e

testAlias+=(
	[xebecd:trusty]='xebecd'
)

imageTests+=(
	[xebecd]='
		rpcpassword
	'
)
