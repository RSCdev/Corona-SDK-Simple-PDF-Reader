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


---------------------------------------------------------------
-- EXTERNAL LIBS
---------------------------------------------------------------
require("PdfUtils")
local widget = require("widget")

---------------------------------------------------------------
-- Creating a button to close the PDF file
---------------------------------------------------------------
	local closeBtn = widget.newButton{
			label = "Close",
	        onRelease = function()  framework:closePdfFile() end
	}
	
	closeBtn.x, closeBtn.y = display.contentCenterX, 50

---------------------------------------------------------------
-- Displaying a PDF file
---------------------------------------------------------------
framework:displayPdfFile( {  
	pdfFileName = "Touchscreens_activity_zones.pdf", 
	webViewY = 70,
	documentHeight=1000
} )
	
