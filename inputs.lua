Inputs = { }

Inputs.Enum =
{
    ASCII_DEC_START = 48,
    ASCII_DEC_END   = 57,
    ASCII_TAB       = 9,
    NAME            = 'Name',
    YEAR            = 'Year',
    MONTH           = 'Month',
    DAY             = 'Day',
    HOUR            = 'Hour',
    MINUTE          = 'Minute',
    SECOND          = 'Second',
    MIN_YEAR        = 2003,
    MAX_YEAR        = 3000,
}

Inputs.Buffers =
{
    Name         = { },
    Date         = { [1] = tostring(os.date('%m/%d/%y', os.time())) },
    Time         = { [1] = '00:00:00 AM' },
    Custom_Gap   = { },
    Custom_Count = { },
    Minutes      = { },  -- ???
    Year         = { [1] = tostring(os.date('*t', os.time()).year)  },
    Month        = { [1] = tostring(os.date('*t', os.time()).month) },
    Day          = { [1] = tostring(os.date('*t', os.time()).day)   },
    Hour         = { [1] = tostring(0) },
    Minute       = { [1] = tostring(0) },
    Second       = { [1] = tostring(0) },
    Multiple     = { },
}

Inputs.Widths = { }
Inputs.Widths.Primary = 150
Inputs.Widths.Minute  = 50
Inputs.Widths.Custom  = 100
Inputs.Widths.Multiple = 400

Inputs.Meridiem    = {}
Inputs.Meridiem.AM = 'AM'
Inputs.Meridiem.PM = 'PM'

Inputs.Text_Flags = bit.bor(
    ImGuiInputTextFlags_CallbackCharFilter,
    ImGuiInputTextFlags_AutoSelectAll
)

Inputs.Date_Time_Flags = bit.bor(
    ImGuiInputTextFlags_AutoSelectAll
)

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the time buffer.
-- ------------------------------------------------------------------------------------------------------
local getTime = function()
    return Inputs.Buffers.Time[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the date buffer.
-- ------------------------------------------------------------------------------------------------------
local getDate = function()
    return Inputs.Buffers.Date[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the date buffer as a date table.
-- ------------------------------------------------------------------------------------------------------
Inputs.Get_Date_Table = function()
    local s = Inputs.Buffers.Date[1]

    -- Must be a string
    if type(s) ~= "string" then
        return nil
    end

    -- Trim whitespace just in case
    s = s:match("^%s*(.-)%s*$")
    if s == "" then
        return nil
    end

    -- Parse MM/DD/YY
    local mm, dd, yy = s:match("^(%d%d?)/(%d%d?)/(%d%d)$")
    if not mm then
        return nil
    end

    mm = tonumber(mm)
    dd = tonumber(dd)
    yy = tonumber(yy)

    if not mm or not dd or not yy then
        return nil
    end

    -- Basic sanity checks
    if mm < 1 or mm > 12 then return nil end
    if dd < 1 or dd > 31 then return nil end

    -- IMPORTANT:
    -- year is intentionally 2-digit to conform to Timers.Make_Time_Table
    return {
        year  = yy,  -- e.g. 25
        month = mm,  -- e.g. 12
        day   = dd,  -- e.g. 25
    }
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the custom gap buffer.
-- ------------------------------------------------------------------------------------------------------
local getCustomGap = function()
    return Inputs.Buffers.Custom_Gap[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the custom count buffer.
-- ------------------------------------------------------------------------------------------------------
local getCustomCount = function()
    return Inputs.Buffers.Custom_Count[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the minutes buffer.
-- ------------------------------------------------------------------------------------------------------
local getMinutes = function()
    return Inputs.Buffers.Minutes[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the name buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.GetName = function()
    return Inputs.Buffers.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves string blob from the multiple buffer.
-- ------------------------------------------------------------------------------------------------------
Inputs.GetMultiple = function()
    return Inputs.Buffers.Multiple[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Retrieves data from the date buffer as a date table (2-digit year for Timers.MakeTimeTable).
-- ------------------------------------------------------------------------------------------------------
Inputs.GetDateTable = function()
    local s = Inputs.Buffers.Date[1]

    if type(s) ~= 'string' then
        return nil
    end

    s = s:match('^%s*(.-)%s*$')
    if s == '' then
        return nil
    end

    local mm, dd, yy = s:match('^(%d%d?)/(%d%d?)/(%d%d)$')
    if not mm then
        return nil
    end

    mm = tonumber(mm)
    dd = tonumber(dd)
    yy = tonumber(yy)

    if not mm or not dd or not yy then
        return nil
    end

    if mm < 1 or mm > 12 then return nil end
    if dd < 1 or dd > 31 then return nil end

    return {
        year  = yy,
        month = mm,
        day   = dd,
    }
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for name.
-- ------------------------------------------------------------------------------------------------------
Inputs.NameField = function()
    UI.SetNextItemWidth(Inputs.Widths.Primary) UI.InputText('Name', Inputs.Buffers.Name, 100, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for time.
-- ------------------------------------------------------------------------------------------------------
Inputs.TimeField = function()
    UI.SetNextItemWidth(Inputs.Widths.Primary) UI.InputText('Time', Inputs.Buffers.Time, 12, Inputs.Date_Time_Flags)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for date.
-- ------------------------------------------------------------------------------------------------------
Inputs.DateField = function()
    UI.SetNextItemWidth(Inputs.Widths.Primary) UI.InputText('Date', Inputs.Buffers.Date, 9, Inputs.Date_Time_Flags)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for custom gap.
-- ------------------------------------------------------------------------------------------------------
Inputs.CustomGapField = function()
    UI.SetNextItemWidth(Inputs.Widths.Custom) UI.InputInt('Minutes', Inputs.Buffers.Custom_Gap, 1, 5, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for custom count.
-- ------------------------------------------------------------------------------------------------------
Inputs.CustomCountField = function()
    UI.SetNextItemWidth(Inputs.Widths.Custom) UI.InputInt('# Windows', Inputs.Buffers.Custom_Count, 1, 5, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates the entry field for minutes.
-- ------------------------------------------------------------------------------------------------------
Inputs.MinutesField = function()
    UI.SetNextItemWidth(Inputs.Widths.Minute) UI.InputText('Minutes', Inputs.Buffers.Minutes, 4, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Creates a multi-line text field for multi-input.
-- ------------------------------------------------------------------------------------------------------
Inputs.MultipleField = function()
    UI.InputTextMultiline('##m', Inputs.Buffers.Multiple, 4096, { Inputs.Widths.Multiple, UI.GetTextLineHeight() * 15 }, ImGuiInputTextFlags_AutoSelectAll)
end

-- ------------------------------------------------------------------------------------------------------
-- Validates name input.
-- ------------------------------------------------------------------------------------------------------
---@param notRequired? boolean
---@return boolean
---@return string
---@return string
-- ------------------------------------------------------------------------------------------------------
Inputs.ValidateName = function(notRequired)
    local defaultName = 'Default Name'
    local name        = Inputs.GetName()

    if not name then
        return false, Timers.Errors.ERROR, defaultName
    elseif not notRequired and string.len(name) == 0 then
        return false, Timers.Errors.NO_NAME, defaultName
    elseif Timers.Timers[name] or Timers.Groups.Exists(name) then
        return false, Timers.Errors.EXISTS, defaultName
    end

    return true, Timers.Errors.NO_ERROR, name
end

-- ------------------------------------------------------------------------------------------------------
-- Validates a time input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return table
-- ------------------------------------------------------------------------------------------------------
Inputs.ValidateTime = function()
    local defaultTime = { hour = 0, minute = 0, second = 0, meridiem = 'AM' }
    local time        = getTime()
    local err         = ''

    if not time or time == '' then
        err = '{HH:MM:SS}'

        return false, err, defaultTime
    end

    local hours, minutes, seconds, meridiem = string.match(time, '(%d?%d):(%d?%d):(%d?%d)%s*(%a?%a?)')

    -- If a meridian was entered then need to make sure it is valid.
    if meridiem and meridiem ~= '' then
        if string.lower(meridiem) == 'am' then
            meridiem = Inputs.Meridiem.AM
        elseif string.lower(meridiem) == 'pm' then
            meridiem = Inputs.Meridiem.PM
        else
            err = '{HH:MM:SS}'

            return false, err, defaultTime
        end
    end

    -- Validate and adjust hours for AM/PM.
    if hours and minutes and seconds then
        hours   = tonumber(hours)
        minutes = tonumber(minutes)
        seconds = tonumber(seconds)

        local hourCheck   = hours   >= 0 and hours   <= 24
        local minuteCheck = minutes >= 0 and minutes <= 59
        local secondCheck = seconds >= 0 and seconds <= 59

        if not (hourCheck and minuteCheck and secondCheck) then
            err = '{HH:MM:SS}'

            return false, err, defaultTime
        end

        -- Hours will supercede meridiem. Meridiem only matters for values less than 13.
        -- If AM/PM is not entered for values less than 13 then we assume miliatry time.
        if hours == 12 then
            if meridiem == '' then
                meridiem = 'AM'
            end

            if meridiem == 'AM' then
                hours = hours - 12
            end

        elseif hours <= 11 then
            if meridiem == Inputs.Meridiem.PM then
                hours = hours + 12
            else
                meridiem = 'AM'
            end

        else
            meridiem = 'PM'
        end

    else
        err = '{HH:MM:SS}'

        return false, err, defaultTime
    end

    return true, err, { hour = hours, minute = minutes, second = seconds, meridiem = string.upper(meridiem) }
end

-- ------------------------------------------------------------------------------------------------------
-- Validates date input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return table
-- ------------------------------------------------------------------------------------------------------
Inputs.ValidateDate = function()
    local now         = os.time()
    local defaultDate = { month = os.date('%m', now), day = os.date('%d', now), year = os.date('%y', now) }
    local err         = ''
    local date        = getDate()

    if not date then
        err = 'Date Required'

        return false, err, defaultDate
    end

    local month, day, year = string.match(date, '^(%d?%d)[/%-](%d?%d)[/%-](%d%d)$')

    if month and day and year then
        month = tonumber(month)
        day   = tonumber(day)
        year  = tonumber(year)

        local monthCheck = month >= 1 and month <= 12
        local dayCheck   = day   >= 1 and day <= 31

        if not (monthCheck and dayCheck) then
            err = 'Date Required'

            return false, err, defaultDate
        end

    else
        err = 'Date Required'

        return false, err, defaultDate
    end

    return true, err, { month = month, day = day, year = year }
end

-- ------------------------------------------------------------------------------------------------------
-- Validates gap input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Inputs.ValidateGap = function()
    local err = ''
    local gap = tonumber(getCustomGap())

    if not gap then
        err = 'Gap Required'

        return false, err, 0
    end

    if gap <= 0 then
        err = 'Positive Gap Required'

        return false, err, 0
    elseif gap > 720 then
        err = 'Gap Too High'

        return false, err, 720
    end

    return true, err, gap
end

-- ------------------------------------------------------------------------------------------------------
-- Validates gap input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Inputs.ValidateCount = function()
    local err = ''
    local count = tonumber(getCustomCount())

    if not count then
        err = 'Count Required'

        return false, err, 0
    end

    if count <= 0 then
        err = 'Positive Count Required'

        return false, err, 0
    elseif count > 25 then
        err = 'Gap Too High'

        return false, err, 25
    end

    return true, err, count
end

-- ------------------------------------------------------------------------------------------------------
-- Validates minute input.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Inputs.ValidateMinutes = function()
    local err = ''
    local minutes = tonumber(getMinutes())

    if not minutes then
        err = 'Minutes Required'

        return false, err, 0
    end

    if minutes <= 0 then
        err = 'Positive Minutes Required'

        return false, err, 0

    elseif minutes > 1440 then
        err = 'Gap Too High'

        return false, err, 1440
    end

    return true, err, minutes
end

-- ------------------------------------------------------------------------------------------------------
-- Compute Relative Spawn Time
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Inputs.SpawnFromClockGated = function(baseDate, h, m, s, relSec, nowTs)
    local SECS_PER_DAY = 86400
    nowTs = nowTs or os.time()

    local function tsForDayOffset(offsetDays)
        local d = { year = baseDate.year, month = baseDate.month, day = baseDate.day + offsetDays }
        local t = { hour = h, minute = m, second = s }
        return Timers.MakeTimeTable(d, t)
    end

    local ts0 = tsForDayOffset(0)

    -- If no relative phrase, return base timestamp
    if relSec == nil then
        return ts0
    end

    -- Future phrase: calculates future timestamp based on relative phrase
    if relSec > 0 then
        local d0 = ts0 - nowTs
        local k = math.floor((relSec - d0) / SECS_PER_DAY)

        if k < 0 then k = 0 end

        local tsK  = tsForDayOffset(k)
        local tsK1 = tsForDayOffset(k + 1)

        local dk  = tsK  - nowTs
        local dk1 = tsK1 - nowTs

        if math.abs(dk - relSec) <= math.abs(dk1 - relSec) then
            return tsK
        else
            return tsK1
        end
    end

    -- Past phrase: calculates past timestamp based on relative phrase
    if relSec < 0 then
        local ts1 = tsForDayOffset(-1)

        local d0 = ts0 - nowTs
        local d1 = ts1 - nowTs

        if d0 <= 0 then
            if math.abs(d0 - relSec) <= math.abs(d1 - relSec) then return ts0 else return ts1 end
        else
            return ts1
        end
    end

    return ts0
end

-- ------------------------------------------------------------------------------------------------------
-- Parse Multi-Line String
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return string
-- ------------------------------------------------------------------------------------------------------

Inputs.ParseInput = function(mode, shorter)
    local now = os.time()
    local baseDate = Inputs.GetDateTable()
    local input = Inputs.GetMultiple()
    if not input or input == '' then
        return false, 'No Input'
    end

    for line in (input .. '\n'):gmatch('(.-)\n') do
        local valid, name, timestamp, relSec, day = Inputs.ParseLine(line)
		
        if valid and name then

            -- Check if name is a known HNM
			local hnmName, isHnm, hnmType = Utils.Canonicalize_HNM(name)
            if shorter then
				hnmName, isHnm, hnmType = Utils.Canonicalize_Shorten_HNM(name)
			end

            if isHnm then
                local lineRel = Utils.Get_Relative_Seconds(line)

                if not lineRel then
                    lineRel = 0
                end

                local spawnTs = Inputs.SpawnFromClockGated(
                    baseDate,
                    timestamp[1],
                    timestamp[2],
                    timestamp[3],
                    lineRel,
                    now
                )

                if spawnTs then
                    local isRel = Utils.Is_Relevant(now, spawnTs, hnmType)

                    if isRel and mode == 'creation' then
                        local date, time = Utils.Timestamp_To_DateTime(spawnTs)

                        CreateMultiple.Schedule(
                            hnmType,
                            hnmName,
                            date,
                            time,
                            nil,
                            day
                        )
                    end
                end
            else
                -- Unknown name: still create a single normal timer
                -- using the parsed clock + relative phrase.
                if mode == 'creation' then
                    local spawnTs = Inputs.SpawnFromClockGated(
                        baseDate,
                        timestamp[1],
                        timestamp[2],
                        timestamp[3],
                        relSec,
                        now
                    )

                    if spawnTs then
                        local date, time = Utils.Timestamp_To_DateTime(spawnTs)

                        CreateMultiple.Schedule(
                            CreateMultiple.Type.Normal,
                            name,
                            date,
                            time,
                            nil,
                            day
                        )
                    end
                end
            end
        end
    end

    return true, 'Completed successfully'
end

-- ------------------------------------------------------------------------------------------------------
-- Parse Single Line String
-- ------------------------------------------------------------------------------------------------------
---@return boolean
---@return name
---@return table{int}
---@return integer
---@return string
-- ------------------------------------------------------------------------------------------------------
Inputs.ParseLine = function(line)
    -- Check if line exists
    if not line or line == '' then
        return false, nil, nil, nil, nil
    end

    -- Attempt to pattern match for a timestamp
    local h, m, sec = Utils.Extract_Time(line)
    if not h or not m or not sec then
        return false, nil, nil, nil, nil
    end

    -- Validate timestamp
    if tonumber(m) > 59 or tonumber(sec) > 59 then
        return false, nil, nil, nil, nil
    end

    -- Get relative phrase
    local rel = Utils.Get_Relative_Seconds(line)
    if rel == nil then
        rel = 0 -- no relative phrase, assume no relativity
    end

    -- Extract optional day from (**2**)
    local day = line:match('%((%d+)%)')

    -- Split string before timestamp
    local name = line:match('^([A-Za-z /]+)')

    -- Strip junk text
    if name then
        name = name:gsub('%s+', ' ') -- whitespace
        name = Utils.Trim(name)
    end

    -- Check if left with valid name
    if name == '' then
        return false, nil, nil, nil, nil
    end

    return true, name, { h, m, sec }, rel, day
end