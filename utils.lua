Utils = T{}

local HNM_ALIASES = {
    -- Behemoth line
    ["behemoth"]                 = { "Behemoth",        CreateMultiple.Type.King },
    ["king behemoth"]            = { "KB",               CreateMultiple.Type.King },
    ["behemoth/king behemoth"]   = { "Behemoth/KB",      CreateMultiple.Type.King },

    -- Adamantoise line
    ["adamantoise"]              = { "Ada",              CreateMultiple.Type.King },
    ["aspidochelone"]            = { "Aspid",            CreateMultiple.Type.King },
    ["adamantoise/aspidochelone"]= { "Ada/Aspid",        CreateMultiple.Type.King },

    -- Fafnir line
    ["fafnir"]                   = { "Fafnir",          CreateMultiple.Type.King },
    ["nidhogg"]                  = { "Nidhogg",         CreateMultiple.Type.King },
    ["fafnir/nidhogg"]           = { "Fafnir/Nidhogg",   CreateMultiple.Type.King },

    -- Wyrms
    ["tiamat"]                   = { "Tiamat",          CreateMultiple.Type.Wyrm },
    ["vrtra"]                    = { "Vrtra",           CreateMultiple.Type.Wyrm },
    ["jormungand"]               = { "Jormungand",       CreateMultiple.Type.Wyrm },

    -- TOAU HNMs
    ["khimaira"]                 = { "Khimaira",       CreateMultiple.Type.Toau },
    ["cerberus"]                 = { "Cerberus",       CreateMultiple.Type.Toau },
    ["hydra"]                    = { "Hydra",          CreateMultiple.Type.Toau },

    ["gulool ja ja"]             = { "Gulool Ja Ja",    CreateMultiple.Type.Normal },
    ["medusa"]                   = { "Medusa",          CreateMultiple.Type.Normal },
    ["gurfurlur"]                = { "Gurfurlur",       CreateMultiple.Type.Normal },

    -- Other HNMs
    ["simurgh"]                  = { "Simurgh",         CreateMultiple.Type.King },
    ["king arthro"]              = { "King Arthro",     CreateMultiple.Type.King },
    ["king vinegarroon"]         = { "King Vinegarroon",CreateMultiple.Type.Normal },
    ["bloodsucker"]              = { "Bloodsucker",     CreateMultiple.Type.Normal },
    ["shikigami weapon"]         = { "Shikigami",        CreateMultiple.Type.Normal },
}

local HNM_ALIASES_SHORT = {
    -- Behemoth line
    ["behemoth"]                 = { "Behe",        CreateMultiple.Type.King },
    ["king behemoth"]            = { "KB",               CreateMultiple.Type.King },
    ["behemoth/king behemoth"]   = { "KB",      CreateMultiple.Type.King },

    -- Adamantoise line
    ["adamantoise"]              = { "Ada",              CreateMultiple.Type.King },
    ["aspidochelone"]            = { "Aspid",            CreateMultiple.Type.King },
    ["adamantoise/aspidochelone"]= { "Aspid",        CreateMultiple.Type.King },

    -- Fafnir line
    ["fafnir"]                   = { "Faf",          CreateMultiple.Type.King },
    ["nidhogg"]                  = { "Nid",         CreateMultiple.Type.King },
    ["fafnir/nidhogg"]           = { "Nid",   CreateMultiple.Type.King },

    -- Wyrms
    ["tiamat"]                   = { "Tia",          CreateMultiple.Type.Wyrm },
    ["vrtra"]                    = { "Vrtra",           CreateMultiple.Type.Wyrm },
    ["jormungand"]               = { "Jorm",       CreateMultiple.Type.Wyrm },

    -- TOAU HNMs
    ["khimaira"]                 = { "Khim",       CreateMultiple.Type.Toau },
    ["cerberus"]                 = { "Cerb",       CreateMultiple.Type.Toau },
    ["hydra"]                    = { "Hydra",          CreateMultiple.Type.Toau },

    ["gulool ja ja"]             = { "Gulool Ja Ja",    CreateMultiple.Type.Normal },
    ["medusa"]                   = { "Medusa",          CreateMultiple.Type.Normal },
    ["gurfurlur"]                = { "Gurfurlur",       CreateMultiple.Type.Normal },

    -- Other HNMs
    ["simurgh"]                  = { "Sim",         CreateMultiple.Type.King },
    ["king arthro"]              = { "KA",     CreateMultiple.Type.King },
    ["king vinegarroon"]         = { "KV", CreateMultiple.Type.Normal },
    ["bloodsucker"]              = { "BS",     CreateMultiple.Type.Normal },
    ["shikigami weapon"]         = { "Shiki",        CreateMultiple.Type.Normal },
}


Utils.Trim = function(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Remove Emoji (discord style)
Utils.Strip_Emoji_Code = function(s)
    -- matches :word: including underscores and numbers
    return (s:gsub(":%w+:%s*", ""))
end

-- Remove trailing (n)
Utils.Strip_Trailing_Counter = function(s)
    -- matches Behemoth (4):blah
    return (s:gsub("%s*%(%d+%)s%*$", ""))
end

-- Extract time (24-hour, or 12-hour with AM/PM)
Utils.Extract_Time = function(s)
    -- H(H):MM:SS with optional AM/PM (e.g. "18:05:16" or "6:05:16 PM")
    -- Lua patterns cannot make a capture group optional with ?, so match AM/PM separately.
    local h, m, sec = s:match("(%d%d?):(%d%d):(%d%d)")
    if not h or not m or not sec then
        return nil
    end
    h, m, sec = tonumber(h), tonumber(m), tonumber(sec)
    if not h or not m or not sec then
        return nil
    end
    if m > 59 or sec > 59 then
        return nil
    end

    local meridiem = s:match("%d%d?:%d%d:%d%d%s*([AaPp][Mm])")
    if meridiem then
        meridiem = string.upper(meridiem)
        -- 12-hour clock: hours must be 1–12
        if h < 1 or h > 12 then
            return nil
        end
        if meridiem == "AM" then
            if h == 12 then h = 0 end
        else -- PM
            if h ~= 12 then h = h + 12 end
        end
    end

    return h, m, sec
end

-- Convert time to seconds
Utils.Time_To_Seconds = function(h, m, s)
    return h * 3600 + m * 60 + s
end

-- Converts UNIX timestamp to date and time
Utils.Timestamp_To_DateTime = function(ts)
    local t = os.date("*t", ts)
    return
    {
        year  = t.year % 100,   -- 25
        month = t.month,  -- 12
        day   = t.day,    -- 25
    },
    {
        hour   = t.hour,  -- 19
        minute = t.min,   -- 30
        second = t.sec,   -- 00
    }
end

-- Extract relative wording into seconds
Utils.Get_Relative_Seconds = function(line)

    line = line:lower()

    -- in a day
    if line:match("in%s+a%s+day") then
        return 24 * 3600 -- 24 hours
    end

    -- in n days
    local days = line:match("in%s+(%d+)%s+days?")
    if days then
        return tonumber(days) * 24 * 3600
    end

    -- in n hours
    local hours = line:match("in%s+(%d+)%s+hours?")
    if hours then
        return tonumber(hours) * 3600
    end

    -- in n minutes
    local min = line:match("in%s+(%d+)%s+minutes?")
    if min then
        return tonumber(min) * 60
    end

    -- in n seconds
    local sec = line:match("in%s+(%d+)%s+seconds?")
    if sec then
        return tonumber(sec)
    end

    -- n seconds ago
    local sec = line:match("(%d+)%s+seconds?%s+ago")
    if sec then
        return -tonumber(sec)
    end

    -- n minutes ago
    local min = line:match("(%d+)%s+minutes?%s+ago")
    if min then
        return -tonumber(min) * 60
    end

    -- n hours ago
    local hours = line:match("(%d+)%s+hours?%s+ago")
    if hours then
        return -tonumber(hours) * 3600
    end

    -- a day ago
    if line:match("a%s+day%s+ago") then
        return -24 * 3600
    end   

    -- n days ago
    local days = line:match("(%d+)%s+days?%s+ago")
    if days then
        return -tonumber(days) * 24 * 3600
    end   

end

-- How long a HNM stays relevant for in seconds
Utils.Relevant_Window_Seconds = function(hnm_type)
    if hnm_type == CreateMultiple.Type.King then
        return 3600 -- 1 hour
    elseif hnm_type == CreateMultiple.Type.Wyrm then
        return 24 * 3600 -- 1 day
    else
        return 0
    end
end

-- Check if a timer is still relevant
Utils.Is_Relevant = function(now, spawn, hnm_type)
    local grace = Utils.Relevant_Window_Seconds(hnm_type)

    -- Has not spawned yet
    if spawn > now then
        return true
    end

    -- Window past
    return (now - spawn) <= grace
end

-- Removes special chars and forces lowercase
Utils.Normalize_Name = function(s)
    s = s:lower()
    s = s:gsub("%s+", " ")
    return Utils.Trim(s)
end

-- Handles multiple entry HNM names
Utils.Canonicalize_HNM = function(name_raw)
    local hnm_match = false
    if not name_raw then
        return nil
    end

    -- check for direct match
    local full = Utils.Normalize_Name(Utils.Trim(name_raw))
    if HNM_ALIASES[full] then
        local match = HNM_ALIASES[full]
        local hnm_name = match[1]
        local hnm_type = match[2]
        hnm_match = true
        return hnm_name, hnm_match, hnm_type
    end

    for part in name_raw:gmatch("[^/]+") do
        part = Utils.Normalize_Name(Utils.Trim(part))
        if HNM_ALIASES[part] then
            hnm_match = true
            local match = HNM_ALIASES[part]
            local hnm_name = match[1]
            local hnm_type = match[2]
            return hnm_name, hnm_match, hnm_type
        end
    end
    -- no known match; return name as is
    return name_raw, hnm_match, CreateMultiple.Type.Normal
end

Utils.Canonicalize_Shorten_HNM = function(name_raw)
    local hnm_match = false
    if not name_raw then
        return nil
    end

    -- check for direct match
    local full = Utils.Normalize_Name(Utils.Trim(name_raw))
    if HNM_ALIASES_SHORT[full] then
        local match = HNM_ALIASES_SHORT[full]
        local hnm_name = match[1]
        local hnm_type = match[2]
        hnm_match = true
        return hnm_name, hnm_match, hnm_type
    end

    for part in name_raw:gmatch("[^/]+") do
        part = Utils.Normalize_Name(Utils.Trim(part))
        if HNM_ALIASES_SHORT[part] then
            hnm_match = true
            local match = HNM_ALIASES_SHORT[part]
            local hnm_name = match[1]
            local hnm_type = match[2]
            return hnm_name, hnm_match, hnm_type
        end
    end
    -- no known match; return name as is
    return name_raw, hnm_match, CreateMultiple.Type.Normal
end