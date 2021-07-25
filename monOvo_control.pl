#    M              OOOOOOOO
#    A            OO--------OO
#    D          OO--------VVVVOO
#    E        OOVVVV------VVVVVVOO
#             OOVVVV------VVVVVVOO
#    B      OOVVVVVV--------VVVV--OO
#    Y      OOVVVVVV--------------OO
#         OO----------VVVVVV--------OO
#    O    OO--------VVVVVVVVVV------OO
#    V    OOVVVV----VVVVVVVVVV------OO
#    O    OOVVVVVV--VVVVVVVVVV--VV--OO
#    K      OOVVVV----VVVVVV--VVVVOO
#    O      OOVVVV------------VVVVOO
#    R        OOOO--------------OO
#    E            OO--------OOOO
#    !              OOOOOOOO

package monOvo_control;

use strict;
use Plugins;
use Globals;
use Settings;
use Misc qw(parseReload);

Plugins::register("monOvo_control", "change the mon_control according to the map", \&unload);

my $hooks = Plugins::addHooks(
	['packet/map_change', \&onMapChange, undef],
	['packet/map_loaded', \&onMapLoaded, undef]
);
	
sub unload {
	Plugins::delHooks($hooks);	
}

sub onMapChange {
	(my $path = Settings::getMonControlFilename()) =~ s/^monOvo_control[\\|\/][^\\|\/]+[\\|\/]([^\\|\/]+)[\\|\/]mon_control.txt$/$1/gm;
	if ($path ne $field->name) {
		if ($field->name eq $config{lockMap}) {
			if (-e "monOvo_control\\lock\\" . $config{lockMap} . "\\mon_control.txt") {
				Settings::setMonControlFilename("monOvo_control\\lock\\" . $config{lockMap} . "\\mon_control.txt");
			}
			else {
				Settings::setMonControlFilename('control\mon_control.txt');
			}
		}
		else {
			if (-e "monOvo_control\\way\\" . $field->name . "\\mon_control.txt") {
				Settings::setMonControlFilename("monOvo_control\\way\\" . $field->name . "\\mon_control.txt");
			}
			else {
				Settings::setMonControlFilename('control\mon_control.txt');
			}
		}
		parseReload("mon_control.txt");
	}
}

sub onMapLoaded {
	if ($field->name eq $config{lockMap}) {
		if (-e "monOvo_control\\lock\\" . $config{lockMap} . "\\mon_control.txt") {
			Settings::setMonControlFilename("monOvo_control\\lock\\" . $config{lockMap} . "\\mon_control.txt");
		}
		else {
			Settings::setMonControlFilename('control\mon_control.txt');
		}
	}
	else {
		if (-e "monOvo_control\\way\\" . $field->name . "\\mon_control.txt") {
			Settings::setMonControlFilename("monOvo_control\\way\\" . $field->name . "\\mon_control.txt");
		}
		else {
			Settings::setMonControlFilename('control\mon_control.txt');
		}
	}
	parseReload("mon_control.txt");
}
