---Highlights a lua comment
---@param line number
---@param theme Syntax.Theme
function sm.scrapcomputers.syntax.highlightComment(line, theme)
    --- TODO: Get emmylua comment syntaxhighlighting implemented
    --- 
    --- We have delayed this fucking V3 update for way too long because we are lazy as hell or we wanted to do other stuff.
    --- So for now its like this. The next few updates or so probably will have this implemented.
    --- 
    --- The issue is that i (veradev) want to have a full EmmyLua comment highlighting implementation but its more painful
    --- than literally highlighting lua code.
    
    return theme.comment.defaultColor .. line
end