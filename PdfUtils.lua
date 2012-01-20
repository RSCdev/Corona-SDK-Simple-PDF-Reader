--[[
This code is MIT licensed - you're basically free to do anything you want with it, including use it without any strings attached !!!!!
-----------------------------------------------
Author: Frederic Beauvois
http://mobileandwebdeveloper.wordpress.com/ 
f_beauvois@hotmail.com
-----------------------------------------------
 Description: FILE UTILS is a set of  helper functions to be used to display a pdf file
Version: 1.0 (jan-2012)

NOTES:  

the code contained in the copyToDocumentsDirectory is from a post in the anscamobile forum, but I can't find it anymore...

---------------------------------------------
TESTED ON
---------------------------------------------
-Xcode iOS simulator
-iPhone 4 and iPad 2 running iOS 5.0.1

---------------------------------------------
LIMITATION TO DISPLAYING PDF FILES USING THIS METHOD
---------------------------------------------

This code is nothing more than a hack but does the job in my case so far.  However, if anyone can think of a better way to do this, please let this code grow with your knowledge!

1) Make sure that the pdf file name does not contain any blanks, ie : change a file called "Touchscreens activity zones.pdf" to "Touchscreens_activity_zones.pdf"
2) Make sure that the pdf file is located in the app's resource directory and not in a subfolder
3) The pdf viewer will look strange when running in the Corona Simulator but runs fine on the Xcode iOS simulator and on iOS devices
4) The native webview must not cover the entire screen surface
5) You must know in the advance the appropriate lenght, in pixels, of your pdf file 

Please refer to the notes regarding the parameters of the 'framework:displayPdfFile' function

 
--]]---------------------------------------------


framework = {}

---------------------------------------------------------------
-- COPY FILE TO DOCUMENT DIRECTORY
---------------------------------------------------------------
function framework:copyToDocumentsDirectory(params)
	
	local overwrite = params.overwrite or false
	local fileName = params.fileName
	
	-- See if Database File Already Exists in Documents Directory
	path = system.pathForFile( fileName, system.DocumentsDirectory )
	file = io.open( path, "r" )
 
	if  ( file ~= nil and overwrite == true )  or (file == nil )  then
 
        -- Doesn't Already Exist, So Copy it In From Resource Directory
        
        pathSource     = system.pathForFile( fileName, system.ResourceDirectory )
        fileSource     = io.open( pathSource, "r" )
   	 contentsSource = fileSource:read( "*a" )
                
       -- Write Destination File in Documents Directory
                
    	pathDest = system.pathForFile( fileName, system.DocumentsDirectory )
        fileDest = io.open( pathDest, "w" )
        fileDest:write( contentsSource )
        
	    -- Done
            
        io.close( fileSource )
    	io.close( fileDest )		
	end
    	    
end

---------------------------------------------------------------
-- COPY FILE TO DOCUMENT DIRECTORY - DIFFERENT SOURCE AND DEST FILE NAME + SOURCE CONTENT MODIFICATION
---------------------------------------------------------------
local function modifySourceAndCreateCopyToDocumentsDirectory(params)
	
	local overwrite = params.overwrite or false
	local srcFileName = params.srcFileName
	local destFileName = params.destFileName
	
	path = system.pathForFile( destFileName, system.DocumentsDirectory )
	file = io.open( path, "r" )
 
	if  ( file ~= nil and overwrite == true )  or (file == nil )  then
 
        pathSource     = system.pathForFile( srcFileName, system.ResourceDirectory )
        fileSource     = io.open( pathSource, "r" )
   	 contentsSource = fileSource:read( "*a" )

    	pathDest = system.pathForFile( destFileName, system.DocumentsDirectory )
        fileDest = io.open( pathDest, "w" )
        
        for i = 1, #params.lookFor do
        	contentsSource = string.gsub ( contentsSource, params.lookFor[i], params.replace[i] ) 
        end
               
       fileDest:write(contentsSource )

        io.close( fileSource )
    	io.close( fileDest )	
	end
    	    
end

---------------------------------------------------------------
-- PREPARES A HTML FILE IN THE DOCUMENT DIRECTORY TO EMBED A PDF FILE
---------------------------------------------------------------
local function prepareHtmlForPDF(params)
	--print("will display: " .. params.fileName)
	
	local destFile = params.fileName .. ".html"
	
	local params = {  
			srcFileName="pdf_viewer_template.html",
			destFileName=destFile,
			lookFor=  { "##pdf_file_name##", "##html_obj_height##" },
			replace= { params.fileName, params.htmlObjHeight } ,
			--overwrite=true,
	}
	modifySourceAndCreateCopyToDocumentsDirectory( params )
	
	return destFile
end

---------------------------------------------------------------
-- DSIPLAY A PDF FILE
---------------------------------------------------------------
--[[
	
requires the following parameters:  

1) params.pdfFileName
pdf file name including file extension, and without any directory name preceeding it

2) params.documentHeigh
The height of the html object which embeds the pdf file, which must be expressed in 'px' or '%' as it is an HTML attribute. 
The height is a number that you calculate according to the number of pages found in your pdf file.  

3) params.webViewY 
WebView y position.  This is so that the native web view invoke by Corona does not cover the entire surface of screen, because if it did, 
than the user wouldn't be able to get out of the web view.  
By leaving some space free on the top, you get the space to place a button to close it.


--]]

function framework:displayPdfFile ( params )
	
	--print(params)
	
	local fileName  = params.pdfFileName
	self:copyToDocumentsDirectory( { fileName= fileName} )

	local destFile = prepareHtmlForPDF(  { 
														fileName= fileName, 
														htmlObjHeight= params.documentHeight }  )
		
	local options = { hasBackground=true, 
							   baseUrl=system.DocumentsDirectory }
							   
								native.showWebPopup( 0, 
								params.webViewY, 
								display.contentWidth, 
								display.contentHeight, 
								destFile, 
								options )
						
end

function framework:closePdfFile()
	native.cancelWebPopup ( )
end