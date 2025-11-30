#!/usr/bin/env texlua

-- Identify the bundle and module
bundle = ""
module = "luakeyval"

stdengine    = "luatex"
checkengines = {"luatex"}
checkruns = 1
sourcefiles = {"*.lua", module .. ".tex"}
installfiles = sourcefiles
auxfiles = {"*.aux", "*.lof", "*.lot", "*.toc", '*.ref'}
docfiles = {module .. '.pdf'}
textfiles = {"*.md", "LICENSE"}
typesetexe = "optex"
typesetfiles = {module .. ".tex"}
ctanzip = module
tdsroot = "luatex"
packtdszip = true

specialformats = specialformats or { }
specialformats.plain  = {luatex = {binary = "luahbtex", format = ""}}
checkformat = "plain"

tagfiles = sourcefiles
table.insert(tagfiles, "README.md")
function update_tag(file,content,tagname,tagdate)
  return string.gsub(content,
    "Version: %d+%.%d+, %d%d%d%d%-%d%d%-%d%d",
    "Version: " .. tagname .. ", " .. tagdate)
end

function pre_release()
    call({"."}, "tag")
    call({"."}, "ctan", {config = options['config']})
    run(".", "zip -d " .. module .. ".zip " .. module .. ".tds.zip")
    rm(".", "*.pdf")
end

target_list["prerelease"] = { func = pre_release, 
			desc = "update tags, generate pdfs, build zip for ctan"}
