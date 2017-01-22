if [catch {open dlist.cfg r} DList ] {puts stderr {Couldn't open Contacts.txt for writing}; exit}
if [catch {socket [gets $DList] 80 } ExternalFile ] { puts stderr {Couldn't open network connection} ; exit }
if [catch {open contacts.txt w} Contacts ] {puts stderr {Couldn't open Contacts.txt for writing}; exit}
puts $ExternalFile "GET /[gets $DList] HTTP/1.0"
puts $ExternalFile "Host: "
puts $ExternalFile "User-Agent: Tcl Powered DList"
puts $ExternalFile ""
flush $ExternalFile
while {[gets $ExternalFile] != {} } {}
fcopy $ExternalFile $Contacts -command {set ExitSignal}
vwait ExitSignal
close $ExternalFile
close $Contacts
