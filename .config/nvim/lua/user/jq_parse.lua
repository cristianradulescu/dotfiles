---@diagnostic disable: param-type-mismatch
--- Parse json content using jq. Run with ":lua JqParse()".
---
--- @param jq_expr? string The JQ expression. Default: true
--- @param jq_use_raw? boolean Use raw format. default: false
function JqParse(jq_expr, jq_use_raw)
  jq_expr = jq_expr or '.'
  jq_use_raw = jq_use_raw or false

  local jq_raw = ''
  if (jq_use_raw == true) then
    jq_raw = '-r'
  end

  local current_buffer_content = vim.fn.getline(1, '$')
  local temp_file_path = '/tmp/nvim_jq_parse_' .. os.date("%YmdHMS")
  vim.fn.writefile(current_buffer_content, temp_file_path)

  local jq_parsed = vim.fn.systemlist('jq '.. jq_raw .. ' "' .. jq_expr .. '" ' .. temp_file_path)

  vim.api.nvim_command('vnew')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, jq_parsed)
  vim.fn.delete(temp_file_path)
end
