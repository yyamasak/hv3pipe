fconfigure stdin -encoding [encoding system] -translation binary
set pipe_html_raw [read stdin]

set pipe_html [string map {{<span style="height:1px;overflow-y:hidden">.</span>} {&nbsp;}} $pipe_html_raw]

package require hv3

proc tclvar_requestcmd {R} {
	# Get the URI from the request handle. The URI should look 
	# something like:
	#
	#   tclvar:///<global varname>
	#
	set uri [$R cget -uri]
	
	# Strip "tclvar:///" from the start of the URI.
	set var [string range $uri 10 end]
	
	# Return the data in the global variable $var to the widget.
	global $var
	$R finish [set $var]
}

::hv3::hv3 .hv3
bind all <MouseWheel> {.hv3.widget yview scroll [expr {-(%D/abs(%D)) * 4}] units}
bind all <Shift-MouseWheel> {.hv3.widget xview scroll [expr {-(%D/abs(%D)) * 4}] units}

pack .hv3 -fill both -expand true
.hv3 configure -requestcmd tclvar_requestcmd
.hv3 goto tclvar:///pipe_html

console show
