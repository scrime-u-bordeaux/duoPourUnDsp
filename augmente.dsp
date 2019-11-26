//augmente

import("stdfaust.lib");
import("delays.lib");
import("maths.lib");

mean(n) =_<:_,@(n):-:+~_:/(n);
rms(n) = ^(2): mean(n): max(0): sqrt;

envelope = rms(4000) : max(ba.db2linear(-70)) : ba.linear2db : hbargraph("niveau[unit:dB]", -70, +6);

compress(th, r) = (-(th) : max(0) : *( (1-r)/r ) : ba.db2linear), _ : *;

zcross = _<:>(0),@(1):_,<=(0):&;
integrator(n) = _<: _, @(n) :-: +~_;
pitch(n) = zcross : integrator(n) : *(SR/n);
pitchtracker = fi.bandpass(1,80,800) : (fi.lowpass(1) : pitch(2000))~(max(100));

hz2midikey(f) = (12)*(log(f/440)/log(2)):+(69);

hauteurs = pitchtracker : hz2midikey <: _,vbargraph("hauteurs[unit:midi]", 0, 127) : attach;

mathmidi(m) = m,(_<:_,_): *,_ : - : min(121);

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };
	        
augmente(m,r) = mathmidi(m),_:
transpose(1097,461): @(r);

facteur = vslider("facteur", 1, -1, 3, 0.01); 
retard = vslider("retard[unit:sec]", 0, 0, 2, 0.01)*SR;
volume = vslider("volume", 1, 0, 1, 0.1);

process = hgroup("augmente", _ <: envelope,_,_ : (compress(-40, 80) : hauteurs), _ : augmente(facteur,retard)*(volume));