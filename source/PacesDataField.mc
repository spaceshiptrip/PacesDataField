//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Graphics as Gfx;


class PaceDataField extends Ui.DataField
{
    var curPace = "0:00";
    var avgPace = "0:00";
    
    var paceFont    = Gfx.FONT_NUMBER_MEDIUM;
    var headerFont  = Gfx.FONT_XTINY;   
    
    var textJustify = Gfx.TEXT_JUSTIFY_CENTER;
    
    var width       = null;
    var fontHeight  = null;
    var textHCenter = null;
    var paceHCenter = null;
    

    //! Constructor
    function initialize()
    {
    	// empty
    }

    //! Handle the update event
    function compute(info)
    {
        if ( (info.currentSpeed != null) && (info.averageSpeed != null) )
        {
            curPace = computePace(info.currentSpeed);
            avgPace = computePace(info.averageSpeed);
        }
    }
    
    // compute pace from speed in [mph]
    // return formatted pace in [mm:ss]
    function computePace(speed) 
    {
    	var paceFormatted = "0:00";
    	if (speed != 0) 
    	{
    		var pace     = 60.0 / (speed * 2.23693629); // convert mph to mins/mile
    		var paceMins = pace.toNumber();  // get the minutes

    		// get the seconds
    		var paceStr    = pace.toString();
    		var decimalIdx = paceStr.find(".");
    		var paceMinsFraction = (paceStr.substring(decimalIdx + 1, decimalIdx + 3)).toFloat();
    		var paceSecs   = (60 * (paceMinsFraction/100)).toNumber().format("%.2d"); // convert to seconds
    		
    		paceFormatted = paceMins + ":" + paceSecs;
    	}
    	
    	return paceFormatted;
    }
    
    function onUpdate(dc){
        // optimize - no need to recompute
    	if (width == null) {
    		width = dc.getWidth();
    	}
        if (fontHeight  == null) {
        	fontHeight  = dc.getFontHeight(paceFont);
        }
        if (textHCenter  == null) {
        	textHCenter = (dc.getHeight() / 2) - (fontHeight / 2);
        }
        if (paceHCenter == null) {
        	paceHCenter = textHCenter + (dc.getFontHeight(headerFont));
        }

        // make sure to clear everything first before redrawing
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        dc.clear();
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        
        // draw yo info dood
        dc.drawText(width/4, 0, headerFont, "CUR PACE", textJustify);
        dc.drawText(width/4, paceHCenter, paceFont, curPace, textJustify );
        dc.drawText(width - width/4, 0, headerFont, "AVG PACE", textJustify);
        dc.drawText(width - width/4, paceHCenter, paceFont, avgPace, textJustify );
    }
    
}

//! main is the primary start point for a Monkeybrains application
class PacesDataField extends App.AppBase
{
    function onStart()
    {
        return false;
    }

    function getInitialView()
    {
        return [new PaceDataField()];
    }

    function onStop()
    {
        return false;
    }
}
