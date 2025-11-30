#!/usr/bin/env texlua

-- Identify the bundle and module
bundle = ""
module = "luakeyval"

stdengine    = "luatex"
checkengines = {"luatex"}
checkruns = 1
sourcefiles = {"*.opm", "*.sty", "*.lua", module .. ".tex"}
installfiles = sourcefiles
auxfiles = {"*.aux", "*.lof", "*.lot", "*.toc", '*.ref'}
docfiles = {module .. '.pdf'}
textfiles = {"*.md", "LICENSE"}
typesetexe = "optex"
typesetfiles = {module .. ".tex"}
ctanzip = module
tdsroot = "luatex"
packtdszip = true

checkconfigs = {
    "configfiles/config-optex",
    "configfiles/config-latex",
    "configfiles/config-plain",
    "configfiles/config-nil",
}

specialformats = specialformats or { }
specialformats.optex  = {luatex = {binary = "optex", format = ""}}
specialformats.plain  = {luatex = {binary = "luahbtex", format = ""}}

tdslocations =
  {
    "tex/optex/" .. module .. "/*.opm",
    "tex/lualatex/" .. module .. "/*.sty",
    "tex/luatex/" .. module .. "/*.tex",
    "tex/luatex/" .. module .. "/*.lua",
  }

specialtypesetting = specialtypesetting or {}
function optex_doc()
    local error_level = 0
    if not direxists('./build') then
        error_level = error_level + mkdir('./build')
    end
    if not direxists('./build/doc') then
        error_level = error_level + mkdir('./build/doc')
    end
    error_level = error_level + cp('*opm', '.', './build/doc')
    error_level = error_level + run('./build/doc', "optex -jobname " .. module .. "-doc '\\docgen " .. module .. "'")
    error_level = error_level + run('./build/doc', "optex -jobname " .. module .. "-doc '\\docgen " .. module .. "'")
    error_level = error_level + run('./build/doc', "optex -jobname " .. module .. "-doc '\\docgen " .. module .. "'")
    error_level = error_level + cp('*pdf', './build/doc', '.')
    return error_level
end
specialtypesetting[module .. ".opm"] = {func = optex_doc}

tagfiles = sourcefiles
table.insert(tagfiles, "README.md")
function update_tag(file,content,tagname,tagdate)
  return string.gsub(content,
    "version   = %d+%.%d+, %d%d%d%d%-%d%d%-%d%d",
    "version   = " .. tagname .. ", " .. tagdate)
end

function pre_release()
    call({"."}, "tag")
    call({"."}, "ctan", {config = options['config']})
    run(".", "zip -d " .. module .. ".zip " .. module .. ".tds.zip")
    rm(".", "*.pdf")
end

target_list["prerelease"] = { func = pre_release, 
			desc = "update tags, generate pdfs, build zip for ctan"}
