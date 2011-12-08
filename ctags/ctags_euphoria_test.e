-- t11B29a03:33 limited test file for ctags euphoria regex parsers
-- ctags_euphoria_test.e  (struct branch)
-- regex parser misses multiline fuction sig and other lists

namespace _1of3namespace

include std/os.e
include std/sequence.e
include std/types.e as _2of3namespace
public include "std\\io.e" as _3of3namespace  --not a real string

with define _1of4word
without define _2of4word

ifdef _3of4word then
elsifdef _4of4word then
elsedef
end ifdef

constant _1of2c=0

public 
constant 
	_2of2c = 0

--filescope
type _1of5type(object w)
	return TRUE
end type

public type _2of5type(object w)
	return TRUE
end type

	export type _3of5type(sequence z) return TRUE end type
 global type _4of5type(integer y)return TRUE end type

override type _5of5type(

	object o
	) return TRUE
end type

--not likely though legal won't be collected
?1	export type _0of5type(sequence z) return TRUE end type

function _1of2function() return TRUE end function
function _2of2function(
		atom b
		,atom a) 
 return TRUE end function


procedure _1of1procedure() end procedure

memtype _0o21amemtype as _1of1memtype
memtype  
	int as _1of2amemtype

memunion _1of1memunion  --
	int i
	unsigned char c
end memunion


memstruct _1of1memstruct
	object x
	_1of1memunion y
end memstruct

while TRUE label "_0of2label" do 
	if 0 then continue "_0of2label" end if
	goto "_1of2label"
end while 

label "_1of2label"
label "_2of2label"
--
