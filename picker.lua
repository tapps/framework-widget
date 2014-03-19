-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newPickerWheel unit test.

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

function scene:createScene( event )
	local group = self.view
	
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
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
	
	-- Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = backButtonPosition,
	    label = "Exit",
	    width = 200, height = 40,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	local days = {}
	local years = {}
	
	for i = 1, 31 do
		days[i] = i
	end
	
	for i = 1, 44 do
		years[i] = 1969 + i
	end
	
	-- Set up the Picker Wheel's columns
	local columnData = 
	{ 
		{ 
			align = "right",
			width = 150,
			startIndex = 1,
			labels = 
			{
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
			},
		},
		
		{
			align = "center",
			width = 60,
			startIndex = 18,
			labels = days,
		},
		
		{
			align = "right",
			width = 80,
			startIndex = 10,
			labels = years,
		},
	}
		
	-- Create a new Picker Wheel
	local pickerWheel = widget.newPickerWheel
	{
		top = display.contentHeight - 222,
		columns = columnData,
	}
	group:insert( pickerWheel )
	
	-- Scroll the second column to it's 8'th row
	--pickerWheel:scrollToIndex( 2, 8, 0 )
		
	
	local function showValues( event )		
		local values = pickerWheel:getValues()
		
		--print( values )
		
		---[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			--print( "Column", i, "index is:", values[i].index )
		end
		--]]
		
		return true
	end
	
	
	local getValuesButton = widget.newButton{
	    id = "getValues",
	    left = display.contentWidth * 0.5 - 50,
	    top = 60,
	    label = "Values",
	    width = 100, height = 52,
	    onRelease = showValues;
	}
	returnToListing.x = display.contentCenterX
	group:insert( getValuesButton )
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
