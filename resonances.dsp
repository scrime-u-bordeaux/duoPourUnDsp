C = 14;//"cordes"

import("stdfaust.lib");
import("maths.lib");

sympatique(f,i) = fi.fb_fcomb(maxdel,del,b0,aN)*(i!=0) 
        with {
            maxdel = 1<<16;
            freq = 1/(f:ba.midikey2hz):si.smooth(0.99);
            del = freq *(ma.SR) : si.smooth(0.99);
            b0 = 1;
            aN = i*(0.01):si.smooth(0.99):min(0.999):max(0);
        };
        
resonances = _<: (par(i, C, sympatique(vslider("frequence%i",((i/127)*(12700/C)),0,127,0.01),
vslider("intensite%i", 95,0,100,0.01))):>
*(reverbGain),*(reverbGain):(re.zita_rev1_stereo(rdel,f1,f2,t60dc,t60m,fsmax))),
(*(1 - (reverbGain))<:_,_):>_,_
  with{
	   reverbGain = hslider("[1] reverb[style:knob]", 0.1, 0, 1, 0.01) : min(1) : max(0);
       roomSize = reverbGain*4: min(2) : max(0.5);
       rdel = 20;
       f1 = 200;
       f2 = 6000;
	   t60dc = hslider("[2] graves[unit:s][style:knob]", 0.1, 0.01, 2, 0.01):si.smooth(0.999):min(6):max(0.5);
       t60m = hslider("[3] mediums[unit:s][style:knob]", 0.1, 0.01, 2, 0.01):si.smooth(0.999):min(6):max(0.5);
	   fsmax = 48000.0;
       };
						
process = hgroup("resonances",resonances);
