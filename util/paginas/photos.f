c
c Writes a simple photo album in html from a simple data file
c
c Leandro Martinez Sept / 2003
c
c usage: photopage < fotos.dat > output.html
c


	implicit double precision (a-h,o-z)
	parameter(maxline=10000)
	parameter(maxsub=100)
	character*100 record(maxline), string, filename
	character*100 section
	character*100 subsection(maxsub)
	character*100 blank
	character*100 fotodir

	do i = 1, 100
	 blank(i:i) = ' '
	end do

	fotodir = blank

c Reading input file

	ifile = 0
	do while(.true.)
	  read(5,100,err=10,end=10) string
  100     format(a100)
	  if(string(1:100).gt.blank) then
	    ifile = ifile + 1
	    call getstring(string, record(ifile))
	  end if
	end do
   10	continue
	nfile = ifile

c writing title

	write(*,110)
  110	format(' <html>',/
     *         ' <body bgcolor="#FFFFFF">',/,/)

c building index

	write(*,120)
  120	format(' <!-- Start index -->',/,/
     *         ' <a name="index"></a>',/
     *         ' <table width="50%"> <br><br>',/
     *         ' <tr><td bgcolor="#010101" width="50%">',/
     *         ' <font size="+1" color="#1BCC11"> ',
     *         ' <strong>&Iacute;ndice ',
     *         ' </strong></font> </tr></td> ',/
     *         ' <tr><td>')

	nsection = 0
        do i = 1, ifile
	  string = record(i)
          if(string(1:7).eq.'section') then
	    nsection = nsection + 1
            read(string(8:100),130) section
  130	    format(a92)
	    call setlength(section,len)
	    write(*,*) '<a href="#section',nsection,'">',
     *                  section(1:len),'</a><br>'
	  end if
	  if(string(1:9).eq.'directory') 
     *      call dir(string,fotodir,ldir)
	end do
	
	write(*,150)
  150	format(' </tr></td>',
     *         ' </table>',/,
     *         ' <HR noshade size="3" width="50%" align="left"',
     *         ' color="#010101">',/,/
     *         ' <!-- End index -->',/,/,' <br><br>',/,/)	     

	ifile = 1
	isection = 1
	string = record(ifile)
	if(string(1:9).eq.'directory') 
     *    call dir(string,fotodir,ldir)
        do while(isection.le.nsection.and.ifile.lt.nfile)
	  if(string(1:7).eq.'section') then
	    section(1:92) = string(8:100)
	    call setlength(section,len)
	    write(*,*)
	    write(*,*) '<!-- Start of section ', 
     *                  isection,':',section(1:len),'-->'
	    write(*,*)
	    write(*,*) '<a name="section',isection,'"> </a>'
            write(*,*) '<HR noshade size="3" width="50%" align="left"',
     *                 ' color="#010101">'
	    write(*,*) '<table width="50%"><tr>',
     *          '<td valign="top" align="right">',
     *          '<a href="#index"> <font size="-1">',
     *          'Voltar ao &Iacute;ndice</font></a></td></tr></table>'
	    write(*,*) '<h2>',section(1:len),'</h2>'

	    ifile = ifile + 1
	    string = record(ifile)
	    if(string(1:9).eq.'directory') 
     *        call dir(string,fotodir,ldir)
	    do while(string(1:11).ne.'end section')
	      if(string(1:10).eq.'subsection') then
	        call setlength(string,isub)
	        string(11:isub+1) = string(11:isub)//':'

	        write(*,*) '<table><tr>'
	        write(*,*) '<td valign="top"> <h3>',string(11:isub+1),
     *                     '</h3></td>'
	        write(*,*) '<td>'

		ifile = ifile + 1
		string = record(ifile)
	        if(string(1:9).eq.'directory') 
     *            call dir(string,fotodir,ldir)
		do while(string(1:7).ne.'end sub')
		  read(string,*) filename
                  call setlength(filename,length)
	          filename = fotodir(1:ldir)//filename
	          length = length + ldir
                  call setlength(string,len)
                iw = length - ldir + 1
                do while(string(iw:iw).le.' '.or.iw.eq.len)
                  iw = iw + 1
                end do
                if(iw.lt.len) then
                  write(*,*) '<a href="',filename(1:length),
     *                       '">',string(length-ldir+1:len),
     *                       '</a>'
                else
                  write(*,*) '<a href="',filename(1:length),
     *                       '">',filename(ldir+1:length),
     *                       '</a>'
                end if
	          ifile = ifile + 1
		  string = record(ifile)
	          if(string(1:9).eq.'directory') 
     *              call dir(string,fotodir,ldir)
	        end do
	      end if
	      write(*,190)
  190         format(' </td></tr></table>')
	      ifile = ifile + 1
	      string = record(ifile)
	      if(string(1:9).eq.'directory') 
     *          call dir(string,fotodir,ldir)
            end do
            write(*,200)
  200	    format(' </table>',/,/
     *             ' <!-- End of section -->')
	    isection = isection + 1
	  end if
	  ifile = ifile + 1
	  string = record(ifile)
	  if(string(1:9).eq.'directory') 
     *      call dir(string,fotodir,ldir)
	end do

	write(*,210)
  210	format(/,/,
     *        '<HR noshade size="3" width="50%" align="left"',
     *        ' color="#010101">',/
     *        ' </table>',/
     *        ' <table width="50%">',
     *        ' <tr><td valign="top" align="right">',/,
     *        ' <a href="#index"> <font size="-1">',/,
     *        ' Voltar ao &Iacute;ndice</font></a></td></tr></table>',/,
     *        ' <br>',/,'<br<br>',/,/,/)
	end 


	subroutine getstring(string, record)

	implicit double precision (a-h,o-z)
	character*100 string, record, blank

	do i = 1, 100
	  blank(i:i) = ' '
	end do

	i = 1
	do while(string(i:i).le.' ')
	  i = i + 1
	end do
	istart = i

	record = blank
	length = 100 - istart + 1
	record(1:length) = string(istart:100)

	return
	end

	subroutine setlength(string, len)
	character*100 string
	integer len
	
	len = 100
	do while(string(len:len).le.' ')
	  len = len - 1
	end do
	
	return
	end
	
	subroutine dir(string,fotodir,ldir)

	integer j, ldir
	character*100 string, fotodir

        j = 10
        do while(string(j:j).le.' ')
          j = j + 1
        end do
        fotodir(1:100-j) = string(j:100)
        ldir = 1	
        do while(fotodir(ldir:ldir).gt.' ')
          ldir = ldir + 1
        end do
        ldir = ldir - 1

	return
	end



















