local linters_by_ft = require('lang.requirements').linters_by_ft

-- Sort the table in ascending order
local sorted_linters_by_ft = {}
for k, v in pairs(linters_by_ft) do
    table.insert(sorted_linters_by_ft, { k, v })
end
table.sort(sorted_linters_by_ft, function(a, b) return a[1] < b[1] end)

-- Reconstruct the table
linters_by_ft = {}
for _, v in ipairs(sorted_linters_by_ft) do
    linters_by_ft[v[1]] = v[2]
end

require('lint').linters_by_ft = linters_by_ft
