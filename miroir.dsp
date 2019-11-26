//miroir

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

mathmidi(m) = m,_: - : min(121);

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };
	        
miroir(m,r) = (mathmidi(m)<:_,_),_:  
_,transpose(1097,461):
transpose(1097,461): @(r);

centre = vslider("centre[unit:midi]", 60, 0 , 127, 0.01); 
retard = vslider("retard[unit:sec]", 0, 0, 2, 0.001)*SR;
volume = vslider("volume", 1, 0, 1, 0.1);

process = hgroup("miroir", _<: envelope,_,_ : (compress(-40, 80) : hauteurs), _ : miroir(centre,retard)*(volume));

----------
----------

//miroir

import("stdfaust.lib");
import("delays.lib");
import("maths.lib");

mean(n) =_<:_,@(n):-:+~_:/(n);
rms(n) = ^(2): mean(n): max(0): sqrt;

envelope = rms(480) : *(127) : vbargraph("envelope", 0, 127);

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };
	        
zcross = _<:>(0),@(1):_,<=(0):&;
integrator(n) = _<: _, @(n) :-: +~_;
pitch(n) = zcross : integrator(n) : *(SR/n);
pitchfolower = fi.bandpass(1,80,200) : (fi.lowpass(2) : pitch(2000))~(max(100));

hz2midikey(f) = (12)*(log(f/440)/log(2)):+(69);

hauteurs = pitchfolower : hz2midikey <: _,vbargraph("hauteurs", 0, 127) : attach;

mathmidi(m) = m,_: - : min(121);

miroir(m,s,fe,fon,r) = _,_,_:(mathmidi(m),<(s):*<:_,_),_:  
_,transpose(fe, fon):
transpose(fe, fon): @(r);

//fenetre = vslider("fenetre", 1097, 0 , 10000, 1); 
//fondu = vslider("fondu", 461, 0 , 10000, 1); 
centre = vslider("centre", 60, 0 , 127, 0.01); 
retard = vslider("retard", 0, 0, 1, 0.01)*SR;
seuil = vslider("seuil", 20, 0, 127, 0.01);

process = _ <: hauteurs, envelope, _ : miroir(centre,seuil,1097,461,retard);

________________________________
________________________________
--------------------------------
--------------------------------

//miroir

import("stdfaust.lib");
import("delays.lib");
import("maths.lib");

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };
	        
zcross = _<:>(0),@(1):_,<=(0):&;

integrator(n) = _<: _, @(n) :-: +~_;
pitchfolower(n) = zcross : integrator(n) : *(SR/n);

hz2midikey(f) = (12)*(log(f/440)/log(2)):+(69);

mathmidi(m) = m,(pitchfolower(2000) : hz2midikey(_)) : - : /(2) ;

miroir(m,fe,fon) = _<:_,(mathmidi(m)<:_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) : 
transpose(fe, fon, _),(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) : 
transpose(fe, fon, _),(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_): 
transpose(fe, fon, _), (_,_,_,_,_,_,_,_,_,_,_,_,_,_):
transpose(fe, fon, _);

//fenetre = vslider("fenetre", 1097, 0 , 10000, 1); 
//fondu = vslider("fondu", 461, 0 , 10000, 1); 
centre = vslider("centre", 60, 0 , 127, 0.01); 
//retard = vslider("retard", 10, 1 , 127, 1);

process = hgroup("miroir", miroir(centre,1097,461));

----------------------------------------------------
----------------------------------------------------

//miroir

import("stdfaust.lib");
import("delays.lib");
import("maths.lib");

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };
	        
zcross = _<:>(0),@(1):_,<=(0):&;
integrator(n) = _<: _, @(n) :-: +~_;
pitch(n) = zcross : integrator(n) : *(SR/n);
pitchfolower(x) = (fi.lowpass(1,_) : pitch(2000)) ~_;

hz2midikey(f) = (12)*(log(f/440)/log(2)):+(69);

mathmidi(m) = m,(pitchfolower : hz2midikey): -;

miroir(m,fe,fon) = _<:_,(mathmidi(m)<:_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_):  
transpose(fe, fon, _), (_,_,_,_,_,_,_,_,_,_,_,_,_,_):
transpose(fe, fon, _);

//fenetre = vslider("fenetre", 1097, 0 , 10000, 1); 
//fondu = vslider("fondu", 461, 0 , 10000, 1); 
centre = vslider("centre", 60, 0 , 127, 0.01); 
//retard = vslider("retard", 10, 1 , 127, 1);

process = hgroup("miroir", miroir(centre,1097,461));