proc json2dict {JSONtext} {
string range [
    string trim          [
        regsub -- {^(\uFEFF)} [
        	regsub -all -- {[\n\r\t ]+}	[
            	string map {\t { } \n { } \r { } , { } : { } \[ \{ \] \}} $JSONtext
            										] { }
            		      				  ] {}
        			            ]
    	     		 ] 1 end-1
}

proc dict2json {dictionary} {
	dict for {key value} $dictionary {
		if {[string match {\[*\]} $value]} {
			lappend Result "\"$key\":$value"
		} elseif {![catch {dict size}]} {
			lappend Result "\"$key\":\"[dict2json $value]\""
		} else {
			lappend Result "\"$key\":\"$value\""
		}
	}
	return "\{[join $Result ",\n"]\}"
}

proc list2json {list} {
	set temp {}
	foreach item $list {
		lappend temp [dict2json $item]
	}
	return "\[[join $temp ",\n"]\]"
}

proc json_merge {json args} {
	set json [string replace $json end end]
	foreach item $args {
		append json",\n[string range $item 1 end-1]"
	}
	return "$json\}"
}