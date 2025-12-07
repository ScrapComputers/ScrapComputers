sm.scrapcomputers.time = {}

local function is_leap_year(year)
    return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

local month_days = {31,28,31,30,31,30,31,31,30,31,30,31}

---Formats an EPOCH to SS, MM, HH, DD, MM, YYYY
---@param epoch number The epoch time
---@return number seconds, number minutes, number hours, number days, number months, number years
function sm.scrapcomputers.time.formatEpoch(epoch)
	local sec = epoch % 60
    local minutes_total = math.floor(epoch / 60)
    local min = minutes_total % 60
    local hours_total = math.floor(minutes_total / 60)
    local hour = hours_total % 24
    local days_total = math.floor(hours_total / 24)

    local year = 1970

    while true do
        local days_in_year = is_leap_year(year) and 366 or 365

        if days_total >= days_in_year then
            days_total = days_total - days_in_year
            year = year + 1
        else
            break
        end
    end

    local month = 1

    while true do
        local dim = month_days[month]

        if month == 2 and is_leap_year(year) then
            dim = 29
        end

        if days_total >= dim then
            days_total = days_total - dim
            month = month + 1
        else
            break
        end
    end

    local day = days_total + 1

    return sec, min, hour, day, month, year
end

---Formats hours to SS, MM, HH
---@param hours number The minutes to format
---@return number seconds, number minutes, number hours
function sm.scrapcomputers.time.formatHours(hours)
    local totalSeconds = hours * 3600
    local wholeHours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60

    return seconds, minutes, wholeHours
end

---Formats minutes to SS, MM, HH
---@param minutes number The minutes to format
---@return number seconds, number minutes, number hours
function sm.scrapcomputers.time.formatMinutes(minutes)
    local totalSeconds = minutes * 60
    local hours = math.floor(totalSeconds / 3600)
    local minutesLeft = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60

    return seconds, minutesLeft, hours
end

---Formats seconds to SS, MM, HH
---@param seconds number The minutes to format
---@return number seconds, number minutes, number hours
function sm.scrapcomputers.time.formatSeconds(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60
	
    return remainingSeconds, minutes, hours
end