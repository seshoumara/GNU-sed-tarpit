#!/bin/sed -nrf

:_Game
    # Game of Life
    # Usage: xterm -bg black -bc -cr red -sh 0.9 -geometry '220x51+20+50' -e './GoL.sed CONFIGURATION;sed q'
    # Cell notation: '.'-dead (D), 'x'-alive (A)

:_Author
    # seshoumara
    # http://codegolf.stackexchange.com/users/59010/seshoumara

:_TODO
    # 1. input file with just the pattern, auto centered
    # 2. optimize run time (difficult)
    # 3. is there a way to have a dynamic grid size? (super difficult)



# test if GNU extensions are supported (needed by this program)
:GNU
    t GNU
    1v

:init
    t init
    b read_input
    :continue_init
    s:^.:>&:						# mark first cell in the starting pattern
    s:.*:CURRENT&NEXT&EOF:				# copy pattern to hold the next generation
    b update_screen

:read_input						# 110x50 (double char, 1:1 terminal aspect ratio)
    t read_input
    /^[.x]+$/! {
        s/.*/Error: found empty row(s) or other character(s) besides '.' and 'x'!/p
        Q 1
    }
    /^.{110}./ {
        s/.*/Error: found row(s) longer than 110 characters!/p
        Q 2
    }
    1h;1!H;$!b						# store each input line read
    g;s:[^\n]::g
    /^\n{49}\n/ {
        s/.*/Error: found more than 50 rows!/p
        Q 3
    }
    g;/x/! {
        s/.*/Error: no live pattern found!/p
        Q 4#04 :)
    }

:center_pattern_in_grid
    t center_pattern_in_grid
    s:^:.......................................................:mg
    s:$:.......................................................:mg
    :trim
        s:^\.::mg
        //
    t trim
    b continue_init

:update_screen
    t update_screen
    x;s:.*:\o033[H\o033[J:				# clear screen
    # remove internal data
    G;s:\nCURRENT>::
    s:NEXT.*::
    # apply colors and double char (1:1 terminal aspect ratio)
    s:\.:\o033[30;40m  \o033[0m:g
    s:x:\o033[37;47m  \o033[0m:g
    p;g;/x/!b						# end if no live pattern left

:next_gen
    t next_gen
    g;s:NEXT.*::
    # get neighbouring cells
    s:CURRENT.*([^\n])>.:\1&:				# L
    s:CURRENT.*>.([^\n]):\1&:				# R
    s:CURRENT.*([^\n]).{110}>.:\1&:			# U
    s:CURRENT.*>..{110}([^\n]):\1&:			# D
    s:CURRENT.*([^\n]).{111}>.:\1&:			# UL
    s:CURRENT.*([^\n]).{109}>.:\1&:			# UR
    s:CURRENT.*>..{109}([^\n]):\1&:			# DL
    s:CURRENT.*>..{111}([^\n]):\1&:			# DR
    s:CURRENT.*::
    s:\.::g						# keep only alive neighbours
    # transition rules - https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Rules
    G;s:\nCURRENT.*>(.).*:CURRENT\1NEXT:
    s:$:.:						# assume cell will die: rule #3(b)
    s:x{2,3}CURRENTxNEXT.:x:				# rule #1(b)
    s:x{3}CURRENT\.NEXT.:x:				# rule #2(b)
    s:.*NEXT::
    x;G
    s:(NEXT.*>).(.*EOF)\n(.):\1\3\2:			# apply transition
    # move marker to next cell and start again
    s:(CURRENT.*)>(.)(.*NEXT.*)>(.)(.*EOF):\1\2>\3\4>\5:
    s:>\n:\n>:g
#l
    />(N|E)/!b next_gen
    # prepare next generation for printing
    s:(CURRENT)(.*)>(NEXT)(.*)>(EOF):\1>\2\3>\4\5:	# reset marker to first cell
    s:(CURRENT).*(NEXT)(.*)(EOF):\1\3\2\3\4:		# set next generation as current
    b update_screen
