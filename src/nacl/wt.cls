Class nacl.wt
{

ClassMethod py()
{
	job ..bg()::3 
	else  write "Job start failed",!  quit
	write "Job "_$ZC_" started",!
	do ..fg()
	quit
}

/// 	background communication
ClassMethod bg(hang = 5)
{
	set fg="|TCP|11111"
	open fg:("localhost":11111:"Q":):2 else  quit
	use fg
	try {
		do ##class(nacl.rcc).py()
		}
	catch e {
		use fg zwrite e 
		}
	close fg
}

/// foreground user interface
ClassMethod fg()
{
	set bg="|TCP|11111"
	open bg:(:11111:"Q"):2 
	else  use 0 write "no connection",! quit
	use bg
	try {
		for  {
			use bg read line:5
			use 0 else  w "?",! continue
			s line=$replace(line,$c(10),$c(13,10))
			w line
			if $e(line,*-2,*)="]: " {
				read ans 
				use bg write $g(ans)_$c(10)
				}
		}
	}
	catch e {
		use 0 
		if $ze'["<READ>" zwrite e b
		}	
	close bg
	quit
}

}
