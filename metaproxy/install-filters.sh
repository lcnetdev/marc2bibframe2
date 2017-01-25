#!/bin/sh

A=/etc/metaproxy/filters-available
E=/etc/metaproxy/filters-enabled

enable_mod()
{
	if test ! -f $A/$2; then
		echo "$A/$2 does not exist"
	elif test -f $E/$1_$2; then
		echo "$1_$2 already exist"
	else
		ln -s $A/$2 $E/$1_$2
	fi
}

if test ! -d $A; then
	echo "$A does not exist"
	exit 1
fi
cp filters-available/*.xml $A
enable_mod 90 z3950_client.xml
enable_mod 40 marc2xml.xml
enable_mod 30 marc2bibframe2.xml
