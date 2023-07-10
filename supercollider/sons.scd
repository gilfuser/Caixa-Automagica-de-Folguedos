(
SynthDef(\pandeiro1, { |out, amp = 0.1, pan, drumfreq = 100, drumres = 10, decay = 0.2, beldec = 0.02, belamp = 0.5, freqScale=1|
	var snd = GrayNoise.ar();
	var filtFreq = amp.linlin(0.025, 0.1, 6000, 12000);
	var env = EnvGen.ar(Env.perc(0.01, decay, amp));
	var env2 = EnvGen.ar(Env.perc(0.05, decay + 0.1, amp), doneAction: 2);
	var filtered = RHPF.ar(snd, drumfreq, 0.3/drumres.lag(0.2));
	var bellz = Klank.ar(`[
		[3567, 4200, 4765, 5100, 5689],
	//	{ExpRand(3000, 5555)}!5,
		belamp,
		beldec,
	], Dust2.ar(ExpRand(3000, 5555)) * env2, freqScale).tanh;
	Out.ar(out, Pan2.ar(
		filtered * env + (bellz),
	pan));
}).add;
);

0.gauss(0.01);
({ 0.gauss(0.1) } ! 100000).histo.plot;

Pdef(\pandeiro).quant_([2, 0, 0, 1]);

(
var n = 8;
Pdef(\pandeiro, Pbind(
	\instrument, \pandeiro1,
	\pan, {0.8.rand2}!(q.enc_12h.asMap%32+1).asInteger,
	\lag, Pfunc( { {0.gauss(0.02) }!n} ),
	\drumfreq, { /*1 + q.enc_12h.asMap.sqrt * 0.5 + 75 +*/ exprand(75, 200) }!n,
	\drumres, {exprand(4, 50) /*+ (4 + q.enc_12h.asMap%25 * 0.5+4)*/ }!n,
	\freqscale, {exprand(0.17, 3.1) }!n,
	\decay, {exprand(0.05, 0.15) }!n,
	\beldec, {exprand(0.01, 0.5) }!n,
	\belamp, {exprand(0.25, 0.5) }!n / 6,
	// more rand params
	\dur, Pseq([2,2,1, 2,2,1,2,1, 2, 1], inf) * 0.25,
    \dur, Pdefn(\pand_dur),
    // \amp, (0.05/n.sqrt),
    \amp, (0.05/n.sqrt),// * Pseq([1,\r,1,\r,1,1,\r,1,\r,1,1,\r,1,1,\r,1],inf),
    // \timingOffset, {q.enc_12h.asMap.reciprocal}
)).play;
);
(
// MFdef(\botoes).remove(\post_pandeiro, {|msg| (msg[0]%35).postln});
MFdef(\botoes).add(\pandeiro, {|msg|
    var opt = (msg[0]%35);
    switch(opt,
        0, { Pdefn(\pand_dur, Pbjorklund2( 3, 4 ) * 0.5 )},
        2, {Pdefn(\pand_dur, Pbjorklund2( 3, 8 ) * 0.25)},
        4, {Pdefn(\pand_dur, Pbjorklund2( 5, 8 ) * 0.125)},
        6, {Pdefn(\pand_dur, Pbjorklund2( 6, 8 ) * 0.25)},
        8, {Pdefn(\pand_dur, Pbjorklund2( 6, 12 ) * 0.333333)},
        10, {Pdefn(\pand_dur, Pbjorklund2( 3, 8 ) * 0.5)},
        12,{Pdefn(\pand_dur, Pbjorklund2( 5, 16 ) * 0.25)},
        14,{Pdefn(\pand_dur, Pbjorklund2( 11, 32 ) * 0.25)},
        16,{Pdefn(\pand_dur, Pbjorklund2( 5, 32 ) * 0.25)},
        18,{Pdefn(\pand_dur, Pbjorklund2( 15, 32 ) * 0.25)},
        20,{Pdefn(\pand_dur,Pbjorklund2( Pseq( [  9, 7, 6, 5, 4, 3, 2, 1 ], inf ), 8 ) * 0.25)},
        22,{Pdefn(\pand_dur,Pbjorklund2( Pxrand( (1..16), inf ), 16 ) * (1/6))},
        24,{Pdefn(\pand_dur,Pbjorklund( Pxrand( (1..16), inf ), 8 ) * (1/9))},
        26,{Pdefn(\pand_dur,Pbjorklund2( 3, 8, inf, 1 ) * 0.25)},
        28,{Pdefn(\pand_dur,Pbjorklund2( 5, 8, inf, 1 ) * 0.25)},
        30,{Pdefn(\pand_dur,Pbjorklund2( 9, 16, inf, 1 ) * 0.25)},
        32,{Pdefn(\pand_dur,Pbjorklund2( 17, 32, inf, 1 ) * 0.25)},
        34,{Pdefn(\pand_dur,Pbjorklund2( 11, 32, inf, 1 ) * 0.25)},
    );
    if (msg[6] == 1) { Pdef(\pandeiro).play };
    if (msg[6] == 0) { Pdef(\pandeiro).stop };
});
)


// surdo assurdo
(
SynthDef(\surdo, { |out, amp = 0.1, freq=55, pan, decay = 0.2, batterAmp=0.1|
	var env = EnvGen.ar(Env.perc(0.001, decay, amp), doneAction: 2);
	var batter = LPF.ar(PinkNoise.ar * env.pow(4), 500) * batterAmp; // very soft
	var sins = SinOscFB.ar(freq * [1,2,3] * env.linlin(1,0,1,0.94), env.cubed, 1/[1,1.5,2]).mean;
	Out.ar(out, Pan2.ar(batter + sins * env, pan));
}).add;
);
Pdef(\surdo).quant_([2, 0, 0, 1]);

(
var n = 2;
Pdef(\surdo, Pbind(
	\instrument, \surdo,
	\pan, {0.8.rand2}!n,
	\lag, Pfunc( { {0.gauss(0.01) }!n} ),
	\freq, Pseq([ Pn({exprand(70, 80) }!n, 5), Pn({exprand(50, 60) }!n, 6)], inf),
	\decay, Pfunc( { {rrand(0.5, 1)}!n} ),
	//\dur, Pseq([2, 2, 2, 1.5, 0.5, 1, 1, 2, 2, 1,1], inf) * 0.5,
    \dur, Pdefn(\surdo_dur),//Pseq([2, 2, 2, 1, 1, 1, 1, 2, 2, 1,1], inf) * 0.5,
    \amp, 0.33/n.sqrt,
	\seed, {1 + q.enc_12h.asMap},
)).play;
)

(
MFdef(\botoes).add(\surdo, {|msg|
    var opt = (msg[1]%35);
    switch(opt,
        0, {Pdefn(\surdo_dur, Pbjorklund2( 3, 4 ) * 0.5 )},
        2, {Pdefn(\surdo_dur, Pbjorklund2( 3, 8 ) * 0.25)},
        4, {Pdefn(\surdo_dur, Pbjorklund2( 5, 8 ) * 0.25)},
        6, {Pdefn(\surdo_dur, Pbjorklund2( 6, 8 ) * 0.5)},
        8, {Pdefn(\surdo_dur, Pbjorklund2( 6, 12 ) * 0.333333 * 2)},
        10, {Pdefn(\surdo_dur, Pbjorklund2( 3, 8 ) * 0.25)},
        12,{Pdefn(\surdo_dur, Pbjorklund2( 5, 16 ) * 0.25)},
        14,{Pdefn(\surdo_dur, Pbjorklund2( 11, 32 ) * 0.25)},
        16,{Pdefn(\surdo_dur, Pbjorklund2( 5, 32 ) * 0.25)},
        18,{Pdefn(\surdo_dur, Pbjorklund2( 15, 32 ) * 0.25)},
        20,{Pdefn(\surdo_dur,Pbjorklund2( Pseq( [  9, 7, 6, 5, 4, 3, 2, 1 ], inf ), 8 ) * 0.25)},
        22,{Pdefn(\surdo_dur,Pbjorklund2( Pxrand( (1..16), inf ), 16 ) * (1/9)*2)},
        24,{Pdefn(\surdo_dur,Pbjorklund( Pxrand( (1..16), inf ), 8 ) * (1/12)*2)},
        26,{Pdefn(\surdo_dur,Pbjorklund2( 3, 8, inf, 1 ) * 0.25)},
        28,{Pdefn(\surdo_dur,Pbjorklund2( 5, 8, inf, 1 ) * 0.25)},
        30,{Pdefn(\surdo_dur,Pbjorklund2( 9, 16, inf, 1 ) * 0.25)},
        32,{Pdefn(\surdo_dur,Pbjorklund2( 17, 32, inf, 1 ) * 0.25)},
        34,{Pdefn(\surdo_dur,Pbjorklund2( 11, 32, inf, 1 ) * 0.25)},
    );
    if (msg[7] == 1) { Pdef(\surdo).play };
    if (msg[7] == 0) { Pdef(\surdo).stop };
})
)

(
SynthDef(\clave, {|freq = 220, amp = 0.1, sustain = 1, bright = 1, pan = 0, out=0|
	var partials = [1, 2.572, 4.644, 6.984, 9.723, 12]*8;
	var sig = Array.fill(6, {|i|
		var i_sig = SinOsc.ar(partials[i]*freq, rrand(0,2pi), (1+(bright*((i/5)-1)))/(i**2.5+1));
		var i_env = EnvGen.kr(Env.perc(0.01/(i+1), sustain/(i+1)*0.5, amp/2), doneAction: (i==0).asInteger * 2);
		i_sig*i_env}).sum;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
(instrument: \clave, bright: 4, legato: 0.125).play;

)
Pdef(\clave).quant_([2, 0, 0, 1]);
(
var n = 1;
Pdef(\clave, Pbind(
	\instrument, \clave,
	\pan, {0.8.rand2}!(q.enc_8h.asMap%32+1).asInteger,
	\lag, Pfunc( { {0.gauss(0.04) }!n} ),
	\drumfreq, { /*1 + q.enc_12h.asMap.sqrt * 0.5 + 75 +*/ exprand(75, 200) }!n,
	\drumres, {exprand(4, 50) /*+ (4 + q.enc_12h.asMap%25 * 0.5+4)*/ }!n,
	\freqscale, {exprand(0.17, 3.1) }!n,
	\decay, {exprand(0.05, 0.15) }!n,
    \bright, 4,
    \legato, 0.125,
	// more rand params
    // \dur, Pseq([2,2,1, 2,2,1,2,1, 2, 1], inf) * 0.25,
    \dur, Pdefn(\clave_dur),
    // \amp, (0.05/n.sqrt),
    \amp, (0.05/n.sqrt),// * Pseq([1,\r,1,\r,1,1,\r,1,\r,1,1,\r,1,1,\r,1],inf),
    // \timingOffset, {q.enc_12h.asMap.reciprocal}
)).play;
)

(
MFdef(\botoes).add(\clave, {|msg|
    var opt = (msg[2]%35);
    switch(opt,
        0, {Pdefn(\clave_dur, Pbjorklund2( 3, 4 ) * 0.5 )},
        2, {Pdefn(\clave_dur, Pbjorklund2( 3, 8 ) * 0.25)},
        4, {Pdefn(\clave_dur, Pbjorklund2( 5, 8 ) * 0.125)},
        6, {Pdefn(\clave_dur, Pbjorklund2( 6, 8 ) * 0.5)},
        8, {Pdefn(\clave_dur, Pbjorklund2( 6, 12 ) * 0.333333)},
        10, {Pdefn(\clave_dur, Pbjorklund2( 3, 8 ) * 0.25)},
        12,{Pdefn(\clave_dur, Pbjorklund2( 5, 16 ) * 0.25)},
        14,{Pdefn(\clave_dur, Pbjorklund2( 11, 32 ) * 0.25)},
        16,{Pdefn(\clave_dur, Pbjorklund2( 5, 32 ) * 0.25)},
        18,{Pdefn(\clave_dur, Pbjorklund2( 15, 32 ) * 0.25)},
        20,{Pdefn(\clave_dur,Pbjorklund2( Pseq( [  9, 7, 6, 5, 4, 3, 2, 1 ], inf ), 8 ) * 0.125)},
        22,{Pdefn(\clave_dur,Pbjorklund2( Pxrand( (1..16), inf ), 16 ) * (1/9))},
        24,{Pdefn(\clave_dur,Pbjorklund( Pxrand( (1..16), inf ), 8 ) * (1/12))},
        26,{Pdefn(\clave_dur,Pbjorklund2( 3, 8, inf, 1 ) * 0.25)},
        28,{Pdefn(\clave_dur,Pbjorklund2( 5, 8, inf, 1 ) * 0.25)},
        30,{Pdefn(\clave_dur,Pbjorklund2( 9, 16, inf, 1 ) * 0.25)},
        32,{Pdefn(\clave_dur,Pbjorklund2( 17, 32, inf, 1 ) * 0.25)},
        34,{Pdefn(\clave_dur,Pbjorklund2( 11, 32, inf, 1 ) * 0.25)},
    );
    if (msg[8] == 1) { Pdef(\clave).play };
    if (msg[8] == 0) { Pdef(\clave).stop };
})
)

(
SynthDef(\kick_electro1, {
    arg amp=1, pan=0, freq=60, out=0;
    var x, env1, env2, env3, mod, noise;
    env1 = Env.perc(0.001,0.15,1,-4);
    env2 = Env.perc(0.001,0.01,1,-4);
    env3 = Env.perc(0.0001,0.01,0.2,-10);
    mod = EnvGen.ar(env2, 1) * 100;
    noise = EnvGen.ar(env3, 1);
    x = SinOsc.ar(freq + mod);
    x = EnvGen.ar(env1, 1, timeScale: \legato.kr(0.2), doneAction: 2) * x - noise;
    OffsetOut.ar(out, Pan2.ar(x,pan, amp));
}).add;
)

Pdef(\clavoso).quant_([2, 0.5, 0, 1]);

(
var n = 4;
Pdef(\clavoso, Pbind(
	\instrument, \kick_electro1,
	\pan, {0.8.rand2}!(q.enc_8h.asMap%32+1).asInteger,
	\lag, Pfunc( { {0.gauss(0.02) }!n} ),
    \legato, {0.2 + 0.8.rand}!n,
    // \freq, { exprand(220, 880) }!n,
    \dur, Pdefn(\clavoso_dur),
    \amp, (0.2/n.sqrt),
));
)

(
MFdef(\botoes).add(\clavoso, {|msg|
    var opt = (msg[3]%35);
    switch(opt,
        0, {Pdefn(\clavoso_dur, Pbjorklund2( 3, 4 ) * 0.5 )},
        2, {Pdefn(\clavoso_dur, Pbjorklund2( 3, 8 ) * 0.25)},
        4, {Pdefn(\clavoso_dur, Pbjorklund2( 5, 8 ) * 0.125)},
        6, {Pdefn(\clavoso_dur, Pbjorklund2( 6, 8 ) * 0.5)},
        8, {Pdefn(\clavoso_dur, Pbjorklund2( 6, 12 ) * 0.333333)},
        10, {Pdefn(\clavoso_dur,Pbjorklund2( 3, 8 ) * 0.25)},
        12,{Pdefn(\clavoso_dur, Pbjorklund2( 5, 16 ) * 0.25)},
        14,{Pdefn(\clavoso_dur, Pbjorklund2( 11, 32 ) * 0.25)},
        16,{Pdefn(\clavoso_dur, Pbjorklund2( 5, 32 ) * 0.25)},
        18,{Pdefn(\clavoso_dur, Pbjorklund2( 15, 32 ) * 0.25)},
        20,{Pdefn(\clavoso_dur,Pbjorklund2( Pseq( [  9, 7, 6, 5, 4, 3, 2, 1 ], inf ), 8 ) * 0.125)},
        22,{Pdefn(\clavoso_dur,Pbjorklund2( Pxrand( (1..16), inf ), 16 ) * (1/9))},
        24,{Pdefn(\clavoso_dur,Pbjorklund( Pxrand( (1..16), inf ), 8 ) * (1/12))},
        26,{Pdefn(\clavoso_dur,Pbjorklund2( 3, 8, inf, 1 ) * 0.25)},
        28,{Pdefn(\clavoso_dur,Pbjorklund2( 5, 8, inf, 1 ) * 0.25)},
        30,{Pdefn(\clavoso_dur,Pbjorklund2( 9, 16, inf, 1 ) * 0.25)},
        32,{Pdefn(\clavoso_dur,Pbjorklund2( 17, 32, inf, 1 ) * 0.25)},
        34,{Pdefn(\clavoso_dur,Pbjorklund2( 11, 32, inf, 1 ) * 0.25)},
    );
    if (msg[9] == 0) {
        Pdef(\clavoso).set( \freq, { exprand(220, 880) }!4 );
        Pdef(\clavoso).stop
    };
    if (msg[9] == 1) {
        Pdef(\clavoso).play };
})
)

(
SynthDef(\assurdo, { |out, amp = 0.1, freq=55, att=0.005, pan, decay = 0.2, batterAmp=0.1, twang=0.2, seed=1974|
	var overtones = 3;
    var nix = RandID.ir(0);
	var seedo = RandSeed.kr(1, seed);
	var env = EnvGen.ar(Env.perc(att, decay, amp), doneAction: 2);
	var envMods = overtones.collect{ SinOsc.kr(0.25/decay, Rand(pi*0.3, pi*0.7)).range(1-twang, 1.1) };
	var sins = SinOsc.ar(freq * [1,2,3] * envMods, 0.3, 1 / [1,1.5,2] ).mean;
	Out.ar( out, Pan2.ar(sins * env, pan) );
}).add;
);

(
SynthDef('basedrum_holz', { arg out, freq=88, sustain=0.3, pan, amp=0.1;
	var env, e;
	env = Env.perc(0.02, sustain, amp);
	freq = freq * (XLine.ar(5, 1, 0.02));
	Out.ar(out,
		Pan2.ar(
			SinOsc.ar(freq, SinOsc.ar(freq, 0, 0.5, pi/2), EnvGen.kr(env, doneAction:2)),
			pan
		)
	)
}).add;
)

Pdef(\assurdo).quant_([2, 0, 0, 1]);

(
Pdef(\assurdo, Pbind(
	\instrument, \basedrum_holz,
	\pan, 0,
	\lag, Pfunc( {0.gauss(0.01) } ),
	\decay, Pfunc( {rrand(0.9, 2)} ),
    \dur, Pdefn(\assurdo),
	\amp, 0.2,
));
);

(
MFdef(\botoes).add(\assurdo, {|msg|
    var opt = (msg[4]%35);
    switch(opt,
        0, {Pdefn(\assurdo, Pbjorklund2( 3, 4 ) * 1 )},
        2, {Pdefn(\assurdo, Pbjorklund2( 3, 8 ) * 0.5)},
        4, {Pdefn(\assurdo, Pbjorklund2( 5, 8 ) * 0.25)},
        6, {Pdefn(\assurdo, Pbjorklund2( 6, 8 ) * 0.5)},
        8, {Pdefn(\assurdo, Pbjorklund2( 6, 12 ) * 0.333333*2)},
        10, {Pdefn(\assurdo,Pbjorklund2( 3, 8 ) * 0.5)},
        12,{Pdefn(\assurdo, Pbjorklund2( 5, 16 ) * 0.5)},
        14,{Pdefn(\assurdo, Pbjorklund2( 11, 32 ) * 0.5)},
        16,{Pdefn(\assurdo, Pbjorklund2( 5, 32 ) * 0.5)},
        18,{Pdefn(\assurdo, Pbjorklund2( 15, 32 ) * 0.5)},
        20,{Pdefn(\assurdo,Pbjorklund2( Pseq( [  9, 7, 6, 5, 4, 3, 2, 1 ], inf ), 8 ) * 0.125)},
        22,{Pdefn(\assurdo,Pbjorklund2( Pxrand( (1..16), inf ), 16 ) * (1/9)*4)},
        24,{Pdefn(\assurdo,Pbjorklund( Pxrand( (1..16), inf ), 8 ) * (1/12)*4)},
        26,{Pdefn(\assurdo,Pbjorklund2( 3, 8, inf, 1 ) * 0.5)},
        28,{Pdefn(\assurdo,Pbjorklund2( 5, 8, inf, 1 ) * 0.5)},
        30,{Pdefn(\assurdo,Pbjorklund2( 9, 16, inf, 1 ) * 0.5)},
        32,{Pdefn(\assurdo,Pbjorklund2( 17, 32, inf, 1 ) * 0.5)},
        34,{Pdefn(\assurdo,Pbjorklund2( 11, 32, inf, 1 ) * 0.5)},
    );
    	Pdef(\assurdo).set(\freq, (msg[4]%49 + 22 * 0.25)**2 );

    if (msg[10] == 0) {
        // Pdef(\clavoso).set( \freq, { exprand(220, 880) }!4 );
        Pdef(\assurdo).stop
    };
    if (msg[10] == 1) { Pdef(\assurdo).play };
})
)

Pdef(\baff).quant_([2, 0.5, 0, 1]);

(
SynthDef(\baff,
    { arg fratio=1, envDepth=1, rq=0.25, dec=0.025, att=0.05, amp=1, freq=44, out=0;
        var sound, env;
        env = EnvGen.kr(Env.perc(0.04, dec), timeScale: \sustain.kr(1), doneAction:2);
        sound = RLPF.ar(
            Saw.ar([freq, freq+5], amp*4),
            freq * fratio * EnvGen.kr(Env.perc(att, dec, envDepth), levelBias:1),
            rq,
            env
        ).distort;
        OffsetOut.ar(out, sound);
}, metadata: ( specs: ( fratio: [0.25,4], envDepth: [0.25,4], att: [0.002,1], dec: [0.01,1] ) ) ).add;
)

(
q.gongNames = q.gongSpecs.collect({ |spec, i| (\gong_ ++ i).asSymbol });

Pdef(\baff, Pbind(
	\instrument, (\gong_ ++ i).asSymbol,
	\pan, 0,
	\lag, Pfunc( {0.gauss(0.01) } ),
    // \dec, Pfunc( {rrand(0.1, 0.25)} ),
	\dur, Pseq([2, 2, 2, 1.5, 0.5,    1,1, 2, 2, 1,1], inf) * 0.75,
	\amp, 0.1,
    // \legato,0.5,
    // \freq,44
));
);

(
MFdef(\botoes).add(\baff, {|msg|
    var opt = (msg[5]%35);
    switch(opt,
        0, {Pdefn(\baff, Pbjorklund2( 3, 4 ) * 1 )},
        2, {Pdefn(\baff, Pbjorklund2( 3, 8 ) * 0.5)},
        4, {Pdefn(\baff, Pbjorklund2( 5, 8 ) * 0.25)},
        6, {Pdefn(\baff, Pbjorklund2( 6, 8 ) * 0.5)},
        8, {Pdefn(\baff, Pbjorklund2( 6, 12 ) * 0.333333*2)},
        10, {Pdefn(\baff,Pbjorklund2( 3, 8 ) * 0.5)},
        12,{Pdefn(\baff, Pbjorklund2( 5, 16 ) * 0.5)},
        14,{Pdefn(\baff, Pbjorklund2( 11, 32 ) * 0.5)},
        16,{Pdefn(\baff, Pbjorklund2( 5, 32 ) * 0.5)},
        18,{Pdefn(\baff, Pbjorklund2( 15, 32 ) * 0.5)},
        20,{Pdefn(\baff,Pbjorklund2( Pseq( [  9, 7, 6, 5, 4, 3, 2, 1 ], inf ), 8 ) * 0.125)},
        22,{Pdefn(\baff,Pbjorklund2( Pxrand( (1..16), inf ), 16 ) * (1/9)*4)},
        24,{Pdefn(\baff,Pbjorklund( Pxrand( (1..16), inf ), 8 ) * (1/12)*4)},
        26,{Pdefn(\baff,Pbjorklund2( 3, 8, inf, 1 ) * 0.5)},
        28,{Pdefn(\baff,Pbjorklund2( 5, 8, inf, 1 ) * 0.5)},
        30,{Pdefn(\baff,Pbjorklund2( 9, 16, inf, 1 ) * 0.5)},
        32,{Pdefn(\baff,Pbjorklund2( 17, 32, inf, 1 ) * 0.5)},
        34,{Pdefn(\baff,Pbjorklund2( 11, 32, inf, 1 ) * 0.5)},
    );
    Pdef(\baff).set(\freq, (msg[5]%61 + 22 * 0.25)**2 );
    if (msg[11] == 0) {
        // Pdef(\clavoso).set( \freq, { exprand(220, 880) }!4 );
        Pdef(\baff).stop
    };
    if (msg[11] == 1) { Pdef(\baff).play };
})
)

Pdef(\assurdoTest).stop;
// MFdef(\botoes).disable(\post)
Pdef(\clave).quant = 4
TempoClock.default.tempo = 60/60;
Pdef(\pandeiro).play; Pdef(\surdo1).play; Pdef(\clave).play;
Pdef(\surdo1).set(\seed, 1);
Pdef(\surdo1).set(\seed, 13); // minimal