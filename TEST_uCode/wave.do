onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/top_if/clk
add wave -noupdate /top/top_if/reset
add wave -noupdate /top/top_if/cmd
add wave -noupdate /top/top_if/din1
add wave -noupdate /top/top_if/din2
add wave -noupdate /top/top_if/valid
add wave -noupdate /top/top_if/result
add wave -noupdate /top/top_if/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11060 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {8989 ns} {16640 ns}
