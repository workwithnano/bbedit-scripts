-- Update Project Tags BBEdit Menu Script
-- Created by Nano
-----------------------------------------
-- Description: When run in a window displaying the text contents
--              of a file in a BBEdit project (or pseudo-project
--              from a folder), this script will run the "bbedit --maketags"
--              command in the root directory of your project.
--
--              This creates a "tags" file in your root directory which
--              contains references to all the classes an functions
--              in all the files in your project, which lets you
--              use text autocomplete across your entire project.
--
--              For more information on the "tags" file and its uses,
--              see http://www.barebones.com/support/develop/ctags.html
--
--              To manually install BBEdit's command line files, go to
--              http://www.barebones.com/support/bbedit/cmd-line-tools.html
--
--
-- How to use:  Drag this script into your Application Support/BBEdit/Scripts
--              folder. Run from the script menu (or assign a custom key command
--              from System Preferences for increased usefulness) when you
--              are editing a file within a project. If you are editing a file
--              outside of the directory tree of the project, or do not have
--              a text file open in BBEdit, the script will fail.

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