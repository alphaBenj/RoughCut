#!/bin/bash



osascript << END
on newtab(name, cmd)
	set wd to do shell script "pwd"
	tell application "System Events" to tell process "Terminal.app" to keystroke "t" using command down
	tell application "Terminal" to do script "cd " & wd in front window
	tell application "Terminal" to do script cmd in front window
	setname(name)
	delay 1
end newtab

on setname(name)
	tell front window of application "Terminal"
		tell selected tab
			set title displays device name to false
			set title displays file name to false
			set title displays shell path to false
			set title displays window size to false
			set title displays custom title to true
			set custom title to name
		end tell
	end tell
end setname

my newtab("tick", "q tick.q schema . -p 5010")
my newtab("feed", "q tick/feed.q -t 200")
my newtab("rdb", "q tick/r.q :5010 -p 5011")
my newtab("last", "q tick/c.q last -p 5013")
my newtab("vwap", "q tick/c.q vwap -p 5014")

END

