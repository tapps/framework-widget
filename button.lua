-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newButton unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_ANDROID_THEME = false
local USE_IOS7_THEME = widget.isSeven()
local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

local xAnchor, yAnchor

if not isGraphicsV1 then
	xAnchor = display.contentCenterX
	yAnchor = display.contentCenterY
else
	xAnchor = 0
	yAnchor = 0
end

-- Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background
	
	if USE_IOS7_THEME then
		background = display.newRect( xAnchor, yAnchor, display.contentWidth, display.contentHeight )
	else
		background = display.newImage( "unitTestAssets/background.png" )
		background.x, background.y = xAnchor, yAnchor
	end
	
	group:insert( background )
	
	if USE_IOS7_THEME then
		-- create a white background, 40px tall, to mask / hide the scrollView
		local topMask = display.newRect( 0, 0, display.contentWidth, 40 )
		topMask:setFillColor( 235, 235, 235, 255 )
		group:insert( topMask )
	end
	
	local backButtonPosition = 5
	local backButtonSize = 52
	
	if USE_IOS7_THEME then
		backButtonPosition = 0
		backButtonSize = 40
	end
	
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
	-- Button to return to unit test listing
	local returnToListing = widget.newButton
	{
	    id = "returnToListing",
	    left = 0,
	    top = backButtonPosition,
	    label = "Exit",
		labelAlign = "center",
		fontSize = 18,
	    width = 200, height = backButtonSize,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	-- Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_LABEL = false
	local TEST_SET_ENABLED = true
		
	-- Handle widget button events
	local function onButtonEvent( event )
		local phase = event.phase
		local target = event.target
		
		if "began" == phase then
			print( target.id .. " pressed" )
						
			-- Set a new label
			target:setLabel( "Hello Corona!" )
    	elseif "ended" == phase then
        	print( target.id .. " released" )
						
			-- Reset the label
			target:setLabel( target.oldLabel )
			
		elseif "cancelled" == phase then
			print( target.id .. " cancelled" )
						
			-- Reset the label
			target:setLabel( target.oldLabel )
    	end
    	
    	return true
	end
	
		
	-- Standard button 
	local buttonUsingFiles = widget.newButton
	{
		width = 278,
		height = 46,
		defaultFile = "unitTestAssets/default.png",
		overFile = "unitTestAssets/over.png",
	    id = "Left Label Button",
	    left = 0,
	    top = 120,
	    label = "Files",
		labelAlign = "left",
		fontSize = 18,
		labelColor =
		{ 
			default = { 0, 0, 0 },
			over = { 255, 255, 255 },
		},
		emboss = false,
		isEnabled = false,
	    onEvent = onButtonEvent,
	}
	buttonUsingFiles.x = display.contentCenterX
	buttonUsingFiles.oldLabel = "Files"	
	group:insert( buttonUsingFiles )
	
	-- Set up sheet parameters for imagesheet button
	local sheetInfo =
	{
		width = 200,
		height = 60,
		numFrames = 2,
		sheetContentWidth = 200,
		sheetContentHeight = 120,
	}
	
	-- Create the button sheet
	local buttonSheet = graphics.newImageSheet( "unitTestAssets/btnBlueSheet.png", sheetInfo )
	
	-- ImageSheet button 
	local buttonUsingImageSheet = widget.newButton
	{
		sheet = buttonSheet,
		defaultFrame = 1,
		--overFrame = 2,
	    id = "Centered Label Button",
	    left = 60,
	    top = 200,
	    label = "ImageSheet",
		labelAlign = "center",
		fontSize = 18,
		labelColor =
		{ 
			default = { 255, 255, 255 },
			over = { 255, 0, 0 },
		},
	    onEvent = onButtonEvent
	}
	buttonUsingImageSheet.x = display.contentCenterX
	buttonUsingImageSheet.oldLabel = "ImageSheet"	
	group:insert( buttonUsingImageSheet )
		

	-- Theme button 
	local buttonUsingTheme = widget.newButton
	{
	    id = "Right Label Button",
	    left = 0,
	    top = 280,
	    label = "Theme",
		labelAlign = "center",
	    width = 140, 
		height = 50,
		fontSize = 18,
		labelColor =
		{ 
			default = { 23, 127, 252 },
			--over = { 255, 255, 255 },
		},
	    onEvent = onButtonEvent
	}
	buttonUsingTheme.oldLabel = "Theme"
	buttonUsingTheme.x = display.contentCenterX
	group:insert( buttonUsingTheme )
	
	-- Text only button
	local buttonUsingTextOnly = widget.newButton
	{
		id = "Text only button",
		left = 0,
		top = 340,
		label = "Text Only Button",
		labelColor = 
		{
			default = { 0, 0, 0 },
			over = { 255, 0, 0 },
		},
		textOnly = true,
		--emboss = false,
		onEvent = onButtonEvent
	}
	buttonUsingTextOnly.oldLabel = "Text only button"
	buttonUsingTextOnly.x = display.contentCenterX
	group:insert( buttonUsingTextOnly )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--Test setting label
	if TEST_SET_LABEL then
		testTimer = timer.performWithDelay( 2000, function()
			buttonUsingTheme:setLabel( "New Label" ) -- "New Label"
		end, 1 )		
	end
	
	-- Test setting a button as enabled
	if TEST_SET_ENABLED then
		testTimer =	timer.performWithDelay( 400, function()
			buttonUsingFiles:setEnabled( true )
		end, 1)
	end
end

function scene:didExitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	storyboard.removeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
