//extensions_fractales

V = 5; // nombre de voix.

import("stdfaust.lib");
import("delays.lib");
import("maths.lib");

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };

fractales(1) = (+:transpose(1097, 461, t):@(d):*(r))~(*(c))
	with{
		d = vslider("duree1", 0.5, 0, 2, 0.001)*SR;
		r = 1-vslider("diminution1", 0.5, 0, 1, 0.01);
		t = vslider("transposition1", 0, -40, +40, 0.1);
		c = checkbox("recursive");
};
fractales(S) = _<:*(b),((+:transpose(1097, 461, t):@(d):*(r))~*(c)):_,(_<:*(1-(b)),_):(+:fractales(S-1)),_
	with{
		d = vslider("duree%S", 0.5, 0, 2, 0.001)*SR;
		r = 1-vslider("diminution%S", 0.5, 0, 1, 0.01);
		t = vslider("transposition%S", 0, -40, +40, 0.1);
		c = checkbox("recursive");
		b = checkbox("paralelle");
};

process = hgroup("extensions_fractales", _<:*(checkbox("passe")),fractales(V):>_);

--------------------------------------
--------------------------------------

V = 5; // nombre de voix.

import("stdfaust.lib");
import("delays.lib");
import("maths.lib");

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };

fractale = _<: par(i, V, (+:transpose(1097, 461, t):@(d):*(r))~(*(c))
	with{
		d = vslider("durée %i", 0.5, 0, 2, 0.01)*48000;
		r = 1-vslider("diminution %i", 0.5, 0, 1, 0.01);
		t = vslider("transposition %i", 0, -12, +12, 0.1);
		c = checkbox("recursive");
});

process = hgroup("fractale", fractale);

-----------------------------
-----------------------------

V = 2; // nombre de voix.

import("stdfaust.lib");
import("delays.lib");
import("maths.lib");

transpose (w, x, s, sig)  =
	fdelay1s(d,sig)*fmin(d/x,1) + fdelay1s(d+w,sig)*(1-fmin(d/x,1))
	   	with {
			i = 1 - pow(2, s/12);
			d = i : (+ : +(w) : fmod(_,w)) ~ _;
	        };

lesoiseaux = _<: par(i, V, +~(_:transpose(1097, 461, t):@(d):*(r)):>_
	with{
		d = vslider("durée%i", 0.5, 0, 2, 0.01)*48000;
		r = vslider("répétition%i", 0.5, 0, 1, 0.01);
		t = vslider("transposition%i", 0, -12, +12, 0.1);
});

process = hgroup("lesoiseaux", lesoiseaux);
