--**
-- Section Heading:
--
-- This file was created for the purpose of testing syntax
-- highlighting for various editors. It is syntactically correct
-- but will **not** execute or do anything useful.
--
-- Parameters:
--   * ##name## - name of person to say hello to
--   * ##greeting## - greeting to say to `name`, defaults to "Hello"
--
-- See Also:
--   [[:check_method]] and [[:say_hello]]
--

namespace abc

include std/sequence.e as seq -- Common mistake to highlight sequence
include std/regex.e

-- Line comment, mispeled

deprecate function abc()
    return 10
end function

/*
 * Multiline Comment
 *
 * Mispeled.
 * TODO: contained in multiline comment
 */

/* Single Line - Multi-Line comment :-) */

trace(1)
with type_check
without inline

ifdef CHECK_NAME then
    public constant NAME = "John Doe"
    export sequence escapes = "Hello\n\r\tHello\\ and \" or \' \0 is null"
    sequence bin_escapes = "Hello \b010110 World!"
    sequence hex_escapes = "Hello\x0f\x8F, \u8FAE, \U8123FEDC is the last"
elsifdef CHECK_INAME then
    export enum I_NAME=10, I_AGE
elsedef
    global atom pi = +3.14159265
end ifdef

sequence various_nums = { 
    10, -10, +10, 18_288,     -- integers 
    203.33, .44,              -- atoms
    0b01011, 0b01_11_01,      -- binaries
    0t123, 0t_71_221,         -- octal
    0x01AF, 0xaf1c, 0xaf_1c,  -- hex style 1
    #01AF, #AF1C, #AF_1C      -- hex style 2
}

sequence str1 = "John Doe"
sequence str2 = `John Doe`
integer ch = 'A', ch2 = '\n', ch3 = '\\'
sequence str3 = """John Doe"""
sequence str4 = """
    Hello, Mr. John Doe. Mispeled

    How "are" you today?
    """
sequence str5 = `
    Hello, Mr. John Doe.

    How "are" you today?
    `

override function open(sequence fname, sequence mode = "w")
    if 1 then
        return 0
    elsif 2 then
        return 1
    else
        while integer(mode) with entry do
            printf(1, "fname = %s\n", { fname })
        entry
            fname &= mode
            abc:open("somefile.txt", "w")
        end while
        return 10
    end if
end function

switch "John" with fallthru do
    case 1 then
        fallthru
    case 2, 3, 4 then
        break
    case else
        puts(1, "else")
end switch

loop do
    i += 1
    
    until i > 20 
end loop

for i = 1 to 10 by 2 label "for_loop" do
    continue
    break
    retry
    exit
end for

-- TODO: contained in a comment
-- NOTE: contained in a comment
-- BUG: contained in a comment
-- FIXME: contained in a comment

public type def(object o)

end type

procedure xyz()
end procedure


