include std/types.e
include std/filesys.e
include std/io.e
include std/os.e
include std/utils.e

procedure err(sequence msg)
	puts(io:STDERR, "Cannot install mode: "&msg&"\n")
	abort(1)
end procedure

puts(io:STDOUT, "This program will install the EUPHORIA mode for jEdit.\n" &
	"Press ENTER to continue or CNTRL+C to stop.\n")
object line
line = gets(io:STDIN)

constant home = getenv("HOME")
constant appdata = getenv("APPDATA")
switch platform() do
	case WINDOWS then
		if atom(appdata) then
			err("No AppData directory.")
		end if
	case else
		if atom(home) then
			err("No HOME directory.")
		end if
end switch


constant settings = iif(platform() = WINDOWS, appdata & "\\jEdit",
					iif(platform() = OSX, home & "/Library/jEdit",
				        home & "/.jedit")) -- Other platforms
if not find(platform(), WINDOWS & OSX & LINUX & FREEBSD & NETBSD) then
	err("Your OS is not supported.")
end if

sequence catdir = settings & SLASH & "modes" 
sequence iname = catdir & SLASH & "catalog"
sequence oname = catdir & SLASH & "catalog.new"
integer ifd = open(iname, "r")
integer ofd = open(oname, "w")

procedure delete_temporary_file(integer discard)
	if ofd != -1 then
		-- must close ofd before deleting oname.
		close(ofd)
	end if
	delete_file(oname)
end procedure

-- the janitor is responsible for things getting cleaned up when the program ends unexpectedly
atom janitor = delete_routine(0, routine_id("delete_temporary_file"))

if ifd = -1 or ofd = -1 then
	ifd = -1
	ofd = -1
	err("Unable to open catalog file for editing.")
end if


boolean found_target = FALSE
while sequence(line) with entry do
	puts(ofd, line)
	if match("<MODES>", line) then
		found_target = TRUE
		exit
	end if
entry
	line = gets(ifd)
end while
if not found_target then
	err( "Cannot find <MODES> string.")
end if
while sequence(line) with entry do
	if match("<MODE NAME=\"euphoria\"", line) then
		-- supress this, we are rewriting this.
		line = gets(ifd)
		continue
	end if
	if match("</MODES>", line) then
		puts(ofd, """<MODE NAME="euphoria" FILE="euphoria.xml" """&
			"""FILE_NAME_GLOB="*.{ex,ew,exw,e}" />""" & '\n')
	end if
	puts(ofd, line)
entry
	line = gets(ifd)
end while

-- must close here so we may replace the old catalog.
close(ifd)
close(ofd)
-- set these so the janitor doesn't try to close the handles
-- a second time.
ifd = -1
ofd = -1
if not copy_file("euphoria.xml", settings & SLASH & "modes" & SLASH & "euphoria.xml", TRUE) then
	err("Cannot copy euphoria mode file")
end if
if not move_file(iname, iname & ".bak", TRUE) then
	err("Cannot backup the catalog.")
end if
if not move_file(oname, iname, TRUE) then
	err("Cannot move new mode configuration into place.")
end if
puts(io:STDERR, "Euphoria mode installed.\n")

