#! /usr/bin/tclsh


set args [split $argv " " ]
set i 1
foreach data $args { set arg($i) $data; incr i }

exec photos < $arg(1) > temp.html

set file [open "./temp.html" r]
set data [read $file]
close $file

set output [open "./fotos.html" w]
set data [split $data "\n"]
foreach line $data {
  set line [string map {
                        "\<html\>" 
                        "\<html\>
                         \<head\>\<style> 
                         a:link\{text-decoration:none\}
                         a:visited\{text-decoration:none\}
                         \</style\>\</head\>"
                        "50\%" "90\%" 
                        "\<td valign=\"top\"\> \<h3\>" "\<tr\>\<td valign=\"top\"\> \<h3\>"
                        "\</h3\>\</td\>" "\</h3\>\</td\>\</tr\>\<tr\>"
                        ".JPG\"\>" ".JPG\" target=\"fotos\"\> \<li\>" 
                        ".jpg\"\>" ".jpg\" target=\"fotos\"\> \<li\>" 
                       } $line]
  puts $output $line 
}
close $output
exec rm -f ./temp.html
