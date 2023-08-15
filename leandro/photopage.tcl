#!/usr/bin/tclsh

# Leandro Martinez, May 2005

# 
# The procedures that get the keyword and its value
#

proc getkeyword { string } {
  set data [ split [ string trim $string ] " " ]
  set i 0
  foreach dat $data { 
    incr i
    set word($i) $dat
  }
  set keyword $word(1)
  if { $word(1) == "end" } { set keyword "$word(1) $word(2)" }
  return $keyword 
}

proc getvalue { string } {                     
  set data [ split [ string trim $string ] " " ]
  set i 0
  foreach dat $data { 
    incr i
    set word($i) $dat
  }
  set value " "
  if { $word(1) == "directory" } { set value $word(2) } 
  if { $word(1) != "end" &
       $word(1) != "directory" } {
      set j [ string first " " [ string trim $string ] ]
      set value [ string trim [ string range [ string trim $string ] $j 300 ] ] 
  }
  return $value 
}

#
# The header of all pages
#

proc header { } {
set header "
<html>
<head>
<style type=\"text/css\"><!--
a:visited {
        text-decoration: none;
        font-size: 12;
        font-family: arial, helvetica, sans-serif;
}
a:link {
        text-decoration: none;
        font-size: 12;
        font-family: arial, helvetica, sans-serif;
}
table {
        border: flat;
}
td {
        font-size: 12;
        font-family: arial, helvetica, sans-serif;
        border: none;
}
body {
        font-size: 12;
        font-family: arial, helvetica, sans-serif;
}

--></style>
</head>
<body bgcolor=white>"
return $header  
}
 
# Reading arguments

set args [split $argv " " ]
set i 1
foreach data $args { set arg($i) $data; incr i }

# Opening input file

set file [ open $arg(1) r ]
set input [ read $file ]
set input [ split $input "\n" ]
close $file

# Creating photopage directory

if { $i == 2 } { set dir ./photopage } else { set dir $arg(2) }
exec rm -rf $dir
exec mkdir $dir

# Creating the "index.html" and "blank.html" files

set file [ open ./$dir/index.html w ]
puts $file "
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">
<html>
<html>
<head>
</head>
<frameset cols=200,250,* frameborder=0 framespacing=0 border=0>
    <frame src=./menu.html
           name=menu
           border=0
           frameborder=0
           framespacing=0
           scrolling=auto
           noresize>
    <frame src=./section1_1.html 
           name=subsection
           border=0
           frameborder=0
           scrolling=auto
           noresize>
    <frame src=./blank.html 
           name=fotos
           border=0
           frameborder=0
           scrolling=auto
           noresize>
</frameset>
</html>
"
close $file

set file [ open ./$dir/blank.html w ]
puts $file "
<body bgcolor=white>
</body>
"
close $file

# Creating the menu

set file [ open ./$dir/menu.html w ]
puts $file [ header ]
puts $file "
<table border=1>
<tr><td bgcolor=lightgrey height=20><b>&Iacute;ndice</b></td></tr>"

set l 0
foreach line $input {
  if { [ string trim $line ] > " " } {
    set keyword [ getkeyword $line ]
    if { $keyword == "section" } {
      incr l
      set value [ getvalue $line ]
      puts $file "<tr><td><a href=./section$l\_1.html target=subsection>
                  $l. $value
                  </a></td></tr>"
    }
  }
}
puts $file "</table></body>"
close $file

# Now we need a counted input

set l 0
foreach line $input {
  if { [ string trim $line ] > " " } {
    incr l
    set iline($l) $line
  }
}
set nlines [ expr $l - 1 ]

# Now will create the subsection files that reference the photos

set l 0
set isec 0
while { $l <= $nlines } {
  incr l
  set keyword [ getkeyword $iline($l) ]       
  if { $keyword == "directory" } { 
    set photodir [ getvalue $iline($l) ]
  } elseif { $keyword == "section" } {
    incr isec
    set section [ getvalue $iline($l) ]
    set subfile [ open $dir/section$isec\_1.html w ]
    puts $subfile [ header ]
    puts $subfile "
         <table align=center border=1 width=100%> 
         <tr><td bgcolor=lightgrey align=center><b>$section</b></td></tr>
         </table>
         "                                                                      
    set ifoto 0
    while { [ getkeyword $iline([ expr $l + 1 ]) ] != "end section" } {
      incr l
      set keyword [ getkeyword $iline($l) ]
      if { $keyword == "directory" } { 
        set photodir [ getvalue $iline($l) ] 
      } elseif { $keyword == "subsection" } {
        puts $subfile "<b><br>[ getvalue $iline($l) ]</b><br>"
        set ifoto 0
      } elseif { $keyword != "end subsection" } {
        incr ifoto
        puts $subfile "<a href=../$photodir/[ getkeyword $iline($l) ] target=fotos>
                       $ifoto. [ getvalue $iline($l) ] </a><br>"
      }
    }
    close $subfile
  }
}

# Creating the index.html file that redirects to the photopage
# subdirectory

exec rm -f ./index.html
set file [ open ./index.html w ]
puts $file "
<body>
<meta HTTP-EQUIV=\"REFRESH\" content=\"0; url=./photopage/index.html\">
</body>
"
close $file



















