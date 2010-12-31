--sort & sift index_out.txt
--found with unofficial eu4 chm, built from creole.ex bookmarks
-- list of eu4 words, some kewords and builtins mixed
-- later versions will include namespace and paramters
-- that will have to be removed for some syntax files
--
-- write partial PSpad syntax file, add  to syntax/euphoria.ini
-- write partial PSpad context file, add  to context/euphoria.def
-- you will still have to make a few more edits
-- add the partial to the top of each default file 




include std/sequence.e
include std/io.e
--include std/sort.e
include std/search.e
include std/text.e
include euphoria/keywords.e as kw


sequence extras = split("inline,profile,profile_time,type_check,warning"
						, ",")
sequence incskips = remove_dups(
				kw:builtins & kw:keywords & extras, RD_SORT)


sequence lines = read_lines("index_out.txt")
lines = lines[2..$]  --remove comment

-- remove any keywords or builtins
-- some words will have parens (), remove before compare

	for x=1 to length(lines) do
		integer f = find('(', lines[x])
		sequence skip = lines[x]
		if f then
			skip = lines[x][1..f-1]
		end if
		--seems not finding them
		-- if not equal(find_nested(skip, incskips), {}) then
		-- if find(skip, incskips) then
		if find(skip, incskips) then
			lines[x] = ""
		end if
	end for

-- start building the sequence to write the ini
-- incskips &= {"?", "!", "$", "&", ".."}  edit in/out 

sequence wlines = {"[KeyWords]"}
	sequence keywords = remove_dups(kw:keywords, RD_SORT)
	for x=1 to length( keywords ) do
		wlines &= {keywords[x]&"="}
	end for

wlines &= {"[ReservedWords]"}
	sequence builtins = remove_dups(kw:builtins, RD_SORT)
	for x=1 to length( builtins ) do
		wlines &= {builtins[x]&"="}
	end for

-- sort out all but one blank,  if any
lines = remove_dups(lines, RD_SORT)

wlines &= {"[KeyWords2]"}
	for x=1 to length( extras ) do
		wlines &= {extras[x]&"="}
	end for

wlines &= {"[KeyWords3]"}
	for x=1 to length( lines ) do
		wlines &= {trim(lines[x], "() ")&"="}
	end for


write_lines("part_euphoria.ini", wlines)
-- ?2/0

-- slightly different format context file
-- harder to do automatically

wlines = {"[Keywords]"}

	--list  of include files
	-- with without inline etc
	-- types
	-- scopes
	-- keywords builtins stdlib words

	--still sorted and pruned from above
	for x=1 to length( lines ) do
		wlines &= {lines[x]}
	end for
write_lines("part_euphoria.DEF", wlines)

-- may want to move more into keywords2

-- other editor formats?



