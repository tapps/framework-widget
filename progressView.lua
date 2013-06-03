-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newProgressView unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_ANDROID_THEME = false

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
	--Display an iOS style background
	local background = display.newImage( "unitTestAssets/background.png" )
	group:insert( background )
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = 5,
	    label = "Exit",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute automated tests.
	local TEST_REMOVE_PROGRESS_VIEW = false
	local TEST_RESET_PROGRESS_VIEW = true
	local TEST_DELAY = 1000
		
	-- Create a new progress view object
	local newProgressView = widget.newProgressView
	{
		left = 20,
		top = 20,
		width = 150,
		isAnimated = true,
	}
	newProgressView.x = display.contentCenterX
	newProgressView.y = display.contentCenterY
	group:insert( newProgressView )
		
	local currentProgress = 0.0

	testTimer = timer.performWithDelay( 100, function( event )
		currentProgress = currentProgress + 0.01
		newProgressView:setProgress( currentProgress )
		
		if TEST_RESET_PROGRESS_VIEW then
			if newProgressView:getProgress() >= 0.5 then
				newProgressView:setProgress( 0 )
				currentProgress = 0.0
			end
		end
		
		--print( newProgressView:getProgress() )
	end, 0 )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	-- Test removing the progress view
	if TEST_REMOVE_PROGRESS_VIEW then
		testTimer = timer.performWithDelay( 100, function()
			display.remove( newProgressView )
			
			TEST_DELAY = TEST_DELAY + TEST_DELAY
		end )
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