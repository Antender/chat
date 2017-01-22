if [catch {open Contacts.txt r} ContactsFile] { puts stderr {Couldn't open contacts.txt file} ; exit }
while {![eof $ContactsFile]} {set Contacts([gets $ContactsFile]) [gets $ContactsFile]}
close $ContactsFile
if [catch {open main.cfg r} ConfigFile] {puts stderr {Couldn't open main.cfg file} ; exit}
if [catch {socket -server ConnectionAccept [gets $ConfigFile]} InSock(Self)] { puts stderr {Couldn't open ingoing port, change it in main.cfg} ; exit }
proc ConnectionAccept {sock addr port} {
   global InSock
   puts "$Contacts($[array nextelement arr [array startsearch Contacts]])
) connected"
   set InSock(addr,$sock) [list $addr $port]
   fconfigure $sock -buffering line
   fileevent $sock readable [list InSock $sock]
}
proc InSock {sock} {
   global InSock
   global ExitSignal
   if {[eof $sock] || [catch {gets $sock line}] || ($line == {quit})} {
      close $sock
      puts "Close $InSock(addr,$sock)"
      unset InSock(addr,$sock)
      if {[array size InSock] == 1 } {set ExitSignal True}
   } else { puts $sock $line} }
vwait $InSock(Self)
