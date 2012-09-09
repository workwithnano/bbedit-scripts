on run
	-- The run handler is called when the script is invoked normally,
	-- such as from BBEdit's Scripts menu.
	UpdateProjectTags()
end run



on menuselect()
	
	-- The menuselect() handler gets called when the script is invoked
	-- by BBEdit as a menu script. Save this script, or an alias to it,
	-- as "JS Lint Document" in the "Menu Scripts" folder in your
	-- "BBEdit Support" folder.
	UpdateProjectTags()
	
end menuselect

on UpdateProjectTags()
	
	tell application "BBEdit"
		
		try
			set project to project window 1
		on error
			beep
			return
		end try
		
		try
			set w to text window 1
		on error
			beep
			return
		end try
		
		set the_file to file of active document of w as text
		
		set the_properties to properties of project
		set file_name_and_project_name to name of the_properties
		
		set tmpArray to my theSplit(file_name_and_project_name, " — ")
		set project_name to item 2 of tmpArray
		
		set tmpArray to my theSplit(the_file, project_name)
		set project_root_folder to item 1 of tmpArray & project_name
		
		set project_root_folder to POSIX path of project_root_folder
		
		set script_string to "/usr/local/bin/bbedit '" & project_root_folder & "' --maketags"
		
		do shell script script_string
		
	end tell
	
end UpdateProjectTags

on theSplit(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore the old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the result
	return theArray
end theSplit

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars