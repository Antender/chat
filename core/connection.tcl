proc accept {connection ip port} {
	set ::connection $connection
	set ::adress $ip:$port
	fconfigure $::connection -buffering line	
	fileevent $::connection readable {read_socket}
	.answer insert end "\nК вам подсоединился $ip:$port"
	.net configure -text Разъединиться -command {disconnect}
}

proc connect {} {
	set delimiter [string first : $::adress]
	set ip [string range $::adress 0 [expr $delimiter-1]]
	set port [string range $::adress [expr $delimiter+1] end]
	set ::connection [socket $ip $port]
	fconfigure $::connection -buffering line	
	fileevent $::connection readable {read_socket}
	.answer insert end "\nВы подсоединились к $ip:$port"
	.net configure -text Разъединиться -command {disconnect}
}

proc disconnect {} {
	close $::connection
	set adress {}
	set connection {}
	.net configure -text Подсоединиться -command {connect}
}

proc send_text {} {
	if {$::connection!={}} {
		puts $::connection [.message get 1.0 end]
		.answer insert end [.message get 1.0 end]
		.message delete 1.0 end
	}
}

proc read_socket {} {
   if {[eof $::connection] || [catch {gets $::connection line}]} {
		close $::connection
		.answer insert end "\nСобеседник отсоединился"
		set ::adress {}
		set ::connection {}
		.net configure -text Подсоединиться -command {connect}
   } else {
		.answer insert end "\n$line"
   }
}

set connections {}
socket -server {accept} [dict get $settings server_port] 
set adress "127.0.0.1:$server_port"