local source = {}

function source:is_available()
  return vim.tbl_contains({ "text", "markdown" }, vim.bo.filetype)
end

function source:get_debug_name()
  return "calendar"
end

local calendar_table = {
  -- Days of week
  { label = "Monday" },
  { label = "Tuesday" },
  { label = "Wednesday" },
  { label = "Thursday" },
  { label = "Friday" },

  -- Months
  { label = "January" },
  { label = "February" },
  { label = "March" },
  { label = "April" },
  { label = "May" },
  { label = "June" },
  { label = "July" },
  { label = "August" },
  { label = "September" },
  { label = "October" },
  { label = "November" },
  { label = "December" },

  -- Generated
  { label = "Today", insertText = os.date("%Y-%m-%d") },
}

function source:complete(_, callback)
  callback(calendar_table)
end

function source:resolve(completion, callback)
  callback(completion)
end

function source:execute(completion, callback)
  callback(completion)
end

require("cmp").register_source("calendar", source)
