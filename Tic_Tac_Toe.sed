#!/bin/sed -nrf

:_Game
    # Tic Tac Toe

:_Author
    # seshoumara
    # http://codegolf.stackexchange.com/users/59010/seshoumara

:_TODO
    # 1. optimal bot strategy
    # 2. remove code duplication from :calculate_bot_move



# test if GNU extensions are supported (needed by this program)
:GNU
    t GNU
    1v

# save player input(s) and board state(s) to log file
:log
    t log
    1{
        s/^/Debug log for Tic Tac Toe in sed:\n-----\n/w log.txt
        s/^[^\n]*\n[^\n]*\n//
    }
    1,2!{
        x
        s/^/-----\n/w log.txt
        s/^[^\n]*\n//
        x
    }
    w log.txt
    e rm -f log.txt

# check if the user typed 'quit'
:exit
    t exit
    /^quit$/{
        s/.*/Thank you for playing. Good bye!/p
        q 0
    }

# intro display and game state initialisation
1{
    # ANSI Escape Sequences are used throughout to control printing position, plus text font, foreground and background color
    s/.*/\o033[2J\o033[H/p
    s/.*/\o033[34;1mWelcome to Tic Tac Toe in sed!\o033[0m\n/p
    x
    # first field stores the player that started first: p-player (default) or b-bot (lower case!)
    # second field stores the symbol of the current player to move: x or o (lower case!)
    # next 3 fields encode the board cells from top-left to bottom-right
    # a cell is defined by its drawing color: n-normal, h-highlighted, g-green or r-red, and its state: 0-empty, X or O (upper case!)
    # next 2 fields are used to keep player scores in unary format
    # last field keeps track of the current game status: R-running, D-draw, P-player victory or B-bot victory (upper case!)
    s/.*/p:x:<n,0><n,0><n,0>:<n,0><n,0><n,0>:<n,0><n,0><n,0>:::R/
    x
    s/.*/\nYou will play a game against the computer. Good luck!/p
    s/.*/\nTo exit, type \o033[37m'quit'\o033[0m at any time./p
    s/.*/\nDo you want to start first? Type \o033[37m'y'\o033[0m for yes, or \o033[37m'n'\o033[0m for no./p
    b
}

# check response
2{
    :restart
        t restart
        /^y$/{
            x
            s/^.:.:/p:x:/
            x
            b update_screen
        }
        /^n$/{
            x
            s/^.:.:/b:x:/
            x
            b calculate_bot_move
        }
        b error
}

# check whether a game turn or a restart (new game) needs to be performed
:check_restart
    t check_restart
    x
    /^restart\n/{
        s///
        /^p/{
            x
            s/.*/n/
            x
        }
        /^b/{
            x
            s/.*/y/
            x
        }
        x
        b restart
    }
    x
    b turn

:turn
    t turn
    # apply player's move
    /^[1-9]$/!b error
    G
    s/<h,/<n,/g
    /^1\n/s/^(.\n.:)(.)(:<).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^2\n/s/^(.\n.:)(.)(:<.,.><).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^3\n/s/^(.\n.:)(.)(:<.,.><.,.><).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^4\n/s/^(.\n.:)(.)(:<.,.><.,.><.,.>:<).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^5\n/s/^(.\n.:)(.)(:<.,.><.,.><.,.>:<.,.><).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^6\n/s/^(.\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^7\n/s/^(.\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^8\n/s/^(.\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /^9\n/s/^(.\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,.><).,(.)(>.*)$/\1\2\3h,\U\2\E\5;\4/
    /;0$/!b error
    s/^.\n(.*);.$/\1/
    h
    # call check_game_status
    s/.*/-t P/
    b check_game_status
    :continue_turn_from_Player
        t continue_turn_from_Player
        g
        /:[DP]$/b update_screen
    x
    y/xo/ox/
    x
    # get bot's move, then call check_game_status
    b calculate_bot_move
    :return_bot_move
        t return_bot_move
        s/.*/-t B/
        b check_game_status
        :continue_turn_from_Bot
            t continue_turn_from_Bot
    x
    y/xo/ox/
    x
    b update_screen

:check_game_status
    t check_game_status
    x
    /^.:o:/y/pb/bp/
    y/xo/XO/
    # check horizontal winning
    s/^(.):(.)(:)<.,\2><.,\2><.,\2>(:.*).$/\1:\2\3<\1,\2><\1,\2><\1,\2>\4\U\1\E/
    s/^(.):(.)(:<.,.><.,.><.,.>:)<.,\2><.,\2><.,\2>(:.*).$/\1:\2\3<\1,\2><\1,\2><\1,\2>\4\U\1\E/
    s/^(.):(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:)<.,\2><.,\2><.,\2>(:.*).$/\1:\2\3<\1,\2><\1,\2><\1,\2>\4\U\1\E/
    # check vertical winning
    s/^(.):(.)(:)<.,\2>(<.,.><.,.>:)<.,\2>(<.,.><.,.>:)<.,\2>(.*:).$/\1:\2\3<\1,\2>\4<\1,\2>\5<\1,\2>\6\U\1\E/
    s/^(.):(.)(:<.,.>)<.,\2>(<.,.>:<.,.>)<.,\2>(<.,.>:<.,.>)<.,\2>(.*:).$/\1:\2\3<\1,\2>\4<\1,\2>\5<\1,\2>\6\U\1\E/
    s/^(.):(.)(:<.,.><.,.>)<.,\2>(:<.,.><.,.>)<.,\2>(:<.,.><.,.>)<.,\2>(.*:).$/\1:\2\3<\1,\2>\4<\1,\2>\5<\1,\2>\6\U\1\E/
    # check diagonal winning
    s/^(.):(.)(:)<.,\2>(<.,.><.,.>:<.,.>)<.,\2>(<.,.>:<.,.><.,.>)<.,\2>(.*:).$/\1:\2\3<\1,\2>\4<\1,\2>\5<\1,\2>\6\U\1\E/
    s/^(.):(.)(:<.,.><.,.>)<.,\2>(:<.,.>)<.,\2>(<.,.>:)<.,\2>(.*:).$/\1:\2\3<\1,\2>\4<\1,\2>\5<\1,\2>\6\U\1\E/
    t end
    # check draw
    /<.,0>/!s/:.$/:D/
    :end
        t end
        s/<p,/<g,/g
        s/<b,/<r,/g
    s/:X:/:x:/
    s/:O:/:o:/
    /^.:o:/y/pb/bp/
    x
    # trick to "unwind the call stack": jump back is dependent on a temporary flag stored in pattern space
    /^-t P$/b continue_turn_from_Player
    /^-t B$/b continue_turn_from_Bot
    /^-cbm W/b continue_calculate_bot_move_from_Winning
    /^-cbm B/b continue_calculate_bot_move_from_Blocking

# non-optimal bot strategy
:calculate_bot_move
    t calculate_bot_move
    # pick immediate winning move, if one exists
    s/.*/123456789/
    # save original board state
    G
    :search_winning_bot_move
        t search_winning_bot_move
        x
        # if the current cell to investigate is free, then choose it as the bot's move in a temporary board state
        G
        /\n1/s/^(.:)(.)(:<.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n2/s/^(.:)(.)(:<.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n3/s/^(.:)(.)(:<.,.><.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n4/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n5/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n6/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n7/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n8/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n9/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        T continue_search_winning_bot_move
        s/\n.*$//
        # call check_game_status to find out if the temporary board state is a win for the bot or not
        x
        s/^/-cbm W\n/
        t check_game_status
        :continue_calculate_bot_move_from_Winning
            t continue_calculate_bot_move_from_Winning
            s/^-cbm W\n//
            x
            # revert board state to original and prepare the winning move to be applied
            /:B$/{
                g
                s/^.*\n//
                x
                s/^(.).*$/\1/
                G
                s/<h,/<n,/g
                b apply_bot_move
            }
            # revert board state to original, but continue searching for a winning move
            /:B$/!{
                g
                s/^.*\n//
                b continue_search_winning_bot_move
            }
        :continue_search_winning_bot_move
            t continue_search_winning_bot_move
            s/\n.*$//
            x
            s/^.//
            /^\n/!b search_winning_bot_move
    # pick immediate blocking move, if one exists
    s/.*/123456789/
    # save original board state
    G
    :search_blocking_move
        t search_blocking_move
        x
        # if the current cell to investigate is free, then choose it as the player's next move in a temporary board state
        G
        y/xo/ox/
        /\n1/s/^(.:)(.)(:<.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n2/s/^(.:)(.)(:<.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n3/s/^(.:)(.)(:<.,.><.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n4/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n5/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n6/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n7/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n8/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        /\n9/s/^(.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,.><.,)0(>.*)$/\1\2\3\U\2\E\4/
        T continue_search_blocking_move
        s/\n.*$//
        # call check_game_status to find out if the temporary board state is a win for the player or not
        x
        s/^/-cbm B\n/
        t check_game_status
        :continue_calculate_bot_move_from_Blocking
            t continue_calculate_bot_move_from_Blocking
            s/^-cbm B\n//
            x
            # revert board state to original and prepare the blocking move to be applied
            /:P$/{
                g
                s/^.*\n//
                x
                s/^(.).*$/\1/
                G
                s/<h,/<n,/g
                b apply_bot_move
            }
            # revert board state to original, but continue searching for a blocking move
            /:P$/!{
                g
                s/^.*\n//
                y/xo/ox/;    # to cancel out the next y
                b continue_search_blocking_move
            }
        :continue_search_blocking_move
            t continue_search_blocking_move
            s/\n.*$//
            y/xo/ox/
            x
            s/^.//
            /^\n/!b search_blocking_move
    # pick the first available move from the order below
    s/.*/561379248/
    G
    s/<h,/<n,/g
    :apply_bot_move
        t apply_bot_move
        /^1/s/^(.*\n.:)(.)(:<).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^2/s/^(.*\n.:)(.)(:<.,.><).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^3/s/^(.*\n.:)(.)(:<.,.><.,.><).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^4/s/^(.*\n.:)(.)(:<.,.><.,.><.,.>:<).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^5/s/^(.*\n.:)(.)(:<.,.><.,.><.,.>:<.,.><).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^6/s/^(.*\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^7/s/^(.*\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^8/s/^(.*\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><).,0(>.*)$/\1\2\3h,\U\2\E\4/
        /^9/s/^(.*\n.:)(.)(:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,.><).,0(>.*)$/\1\2\3h,\U\2\E\4/
        t break_apply_bot_move
        s/^.//
        /^\n/!b apply_bot_move
    :break_apply_bot_move
        s/^.*\n//
        h
    b return_bot_move

:update_screen
    t update_screen
    # clear screen
    1!s/.*/\o033[H\o033[J/p
    # print current board state
    g
    s/^.:.:/\n@@@@@@@@@@@@@@@@@@@@@@@\n@@     @@     @@     @@\n/
    s/:[^:]*:[^:]*:.$/\n@@     @@     @@     @@\n@@@@@@@@@@@@@@@@@@@@@@@\n/
    s/:/\n@@     @@     @@     @@\n@@@@@@@@@@@@@@@@@@@@@@@\n@@     @@     @@     @@\n/g
    s/,0>/, >/g
    s/<n,([ XO])>/@  \o033[1m\1\o033[0m  @/g
    s/<h,([ XO])>/@  \o033[33;1m\1\o033[0m  @/g
    s/<r,([ XO])>/@  \o033[31;1m\1\o033[0m  @/g
    s/<g,([ XO])>/@  \o033[32;1m\1\o033[0m  @/g
    s/\n@ /\n@@ /g
    s/ @\n/ @@\n/g
    s/@/\o033[104m \o033[0m/g
    p
    # check if the current game ended and update score if necessary
    x
    /:D$/{
        x
        s/.*/\o033[34;1mThe game ended in a draw!\o033[0m/p
        x
        # the score is kept unchanged
    }
    /:P$/{
        x
        s/.*/\o033[32;1mCongratulations! You have won the game.\o033[0m/p
        x
        s/:([^:]*):([^:]*):(.)$/:\1@:\2:\3/
    }
    /:B$/{
        x
        s/.*/\o033[31;1mUnfortunately you have lost the game.\o033[0m/p
        x
        s/:([^:]*):([^:]*):(.)$/:\1:\2@:\3/
    }
    w log.txt
    /:[DPB]$/{
        x
        # print score
        s/.*/\n\o033[1mScore so far:\o033[0m\n/p
        g
        s/^.:.:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,.><.,.>:([^:]*):([^:]*):.$/\1;\2/
        H
        s/;.*$//
        b unary_to_decimal
        :return_score_1
            t return_score_1
            s/.*/you = &/p
            x
            s/\n.*;/\n/
            x
        g
        s/.*\n//
        b unary_to_decimal
        :return_score_2
            t return_score_2
            s/.*/bot = &\n/p
            x
            s/\n.*//
            x
        b reset_board
    }
    x
    # the game is still running: ask for player's move and start a new cycle
    s/.*/Choose an empty cell number (1 to 9 starting from top-left):/p
    b

# prepare to start a new game
:reset_board
    t reset_board
    s/.*/\nPress enter to start a new game./p
    x
    s/^(.):.:<.,.><.,.><.,.>:<.,.><.,.><.,.>:<.,.><.,.><.,.>:([^:]*):([^:]*):.$/\1:x:<n,0><n,0><n,0>:<n,0><n,0><n,0>:<n,0><n,0><n,0>:\2:\3:R/
    s/.*/restart\n&/
    x
    b

:error
    t error
    s/.*/\o033[31mError: your input is not valid!\o033[0m/p
    q 1

# convert score from unary format (e.g. @@@) to decimal format (e.g. 3)
:unary_to_decimal
    t unary_to_decimal
    :loop
        /@/{
            s/@@@@@/v/g
            s/vv/x/g
            /[@v]/!s/x+/&0/
            s/@@/b/g
            s/bb/4/
            s/b@/3/
            s/v@/6/
            s/vb/7/
            s/v3/8/
            s/v4/9/
            y/@bvx/125@/
            t loop
        }
    s/^$/0/
    x
    /;/{
        x
        b return_score_1
    }
    x
    b return_score_2
