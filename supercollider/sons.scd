(
SynthDef(\pandeiro1, { |out, amp = 0.1, pan, drumfreq = 100, drumres = 10, decay = 0.2, beldec = 0.02, belamp = 0.5, freqScale=1|
	var snd = GrayNoise.ar();
	var filtFreq = amp.linlin(0.025, 0.1, 6000, 12000);
	var env = EnvGen.ar(Env.perc(0.01, decay, amp));
	var env2 = EnvGen.ar(Env.perc(0.05, decay + 0.1, amp), doneAction: 2);
	var filtered = RHPF.ar(snd, drumfreq, 0.3/drumres);
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
(
Pdef(\pandeiro, Pbind(
	\instrument, \pandeiro1,
	\pan, {1.0.rand2}!8,
	\lag, {0.02.rand2}!8,
	\drumfreq, {exprand(75, 200) }!8,

	\dur, 0.25
)).play;
);


0.gauss(0.01);
({ 0.gauss(0.1) } ! 100000).histo.plot;
(
var n = 8;
Pdef(\pandeiro, Pbind(
	\instrument, \pandeiro1,
	\pan, {0.8.rand2}!n,
	\lag, Pfunc( { {0.gauss(0.02) }!n} ),
	\drumfreq, { 1 + q.enc_12h.asMap.sqrt * 0.5 + 75 + exprand(75, 200) }!n,
	\drumres, {exprand(4, 25) + (1 + q.enc_12h.asMap * 0.5) }!n,
	\freqscale, {exprand(0.17, 3.1) }!n,
	\decay, {exprand(0.05, 0.15) }!n,
	\beldec, {exprand(0.01, 0.5) }!n,
	\belamp, {exprand(0.25, 0.5) }!n / 6,
	// more rand params
	\dur, Pseq([2,2,1, 2,2,1,2,1, 2, 1], inf) * 0.25,
	\dur, 0.25,
    // \amp, (0.05/n.sqrt),
    \amp, (0.05/n.sqrt) * Pseq([1,\r,1,\r,1,1,\r,1,\r,1,1,\r,1,1,\r,1],inf),
    // \timingOffset, {q.enc_12h.asMap.reciprocal}
)).play;
);

MFdef(\botoes).add(\toggle, {|msg|
    if (msg[6] == 1) { Pdef(\pandeiro).play };
    if (msg[6] == 0) {Pdef(\pandeiro).stop};
});
(
var n = 2;
Pdef(\surdo1, Pbind(
	\instrument, \surdo1,
	\pan, {0.8.rand2}!n,
	\lag, Pfunc( { {0.gauss(0.01) }!n} ),
	\freq, Pseq([ Pn({exprand(70, 80) }!n, 5), Pn({exprand(50, 60) }!n, 6)], inf),
	\decay, Pfunc( { {rrand(0.5, 1)}!n} ),
	\dur, Pseq([2, 2, 2, 1.5, 0.5, 1, 1, 2, 2, 1,1], inf) * 0.5,
	\amp, 0.75/n.sqrt,
	\seed, 11
)).play;
)


// surdo assurdo
(
SynthDef(\surdo1, { |out, amp = 0.1, freq=55, pan, decay = 0.2, batterAmp=0.1|
	var env = EnvGen.ar(Env.perc(0.001, decay, amp), doneAction: 2);
	var batter = LPF.ar(PinkNoise.ar * env.pow(4), 500) * batterAmp; // very soft
	var sins = SinOscFB.ar(freq * [1,2,3] * env.linlin(1,0,1,0.94), env.cubed, 1/[1,1.5,2]).mean;
	Out.ar(out, Pan2.ar(batter + sins * env, pan));
}).add;
);
(
SynthDef(\assurdo, { |out, amp = 0.1, freq=55, att=0.005, pan, decay = 0.2, batterAmp=0.1, twang=0.2, seed=1974|
	var overtones = 3;
    var nix = RandID.ir(0);
	var seedo = RandSeed.kr(1, seed);
	var env = EnvGen.ar(Env.perc(att, decay, amp), doneAction: 2);
	var envMods = overtones.collect{ SinOsc.kr(0.25/decay, Rand(pi*0.3, pi*0.7)).range(1-twang, 1.1) };
	var sins = SinOsc.ar(freq * [1,2,3] * envMods, 0.3, 1/[1,1.5,2]).mean;
	Out.ar(out, Pan2.ar(sins * env, pan));
}).add;
);
(
Pdef(\assurdoTest, Pbind(
	\instrument, \assurdo,
	\pan, 0,
	\lag, Pfunc( {0.gauss(0.01) } ),
	\freq, 50,
	\decay, Pfunc( {rrand(0.9, 2)} ),
	\dur, Pseq([2, 2, 2, 1.5, 0.5,    1,1, 2, 2, 1,1], inf) * 0.75,
	\amp, 0.85,
	\seed, 3
)).play;
);
Pdef(\assurdoTest).stop;
(
var n = 2;
Pdef(\surdo1, Pbind(
	\instrument, \surdo1,
	\pan, {0.8.rand2}!n,
	\lag, Pfunc( { {0.gauss(0.01) }!n} ),
	\freq, Pseq([ Pn({exprand(70, 80) }!n, 5), Pn({exprand(50, 60) }!n, 6)], inf),
	\decay, Pfunc( { {rrand(0.5, 1)}!n} ),
	//\dur, Pseq([2, 2, 2, 1.5, 0.5, 1, 1, 2, 2, 1,1], inf) * 0.5,
    \dur, 0.5,//Pseq([2, 2, 2, 1, 1, 1, 1, 2, 2, 1,1], inf) * 0.5,
	\amp, 0.75/n.sqrt * Pseq([1,1,1,\r],inf),
	\seed, {1 + q.enc_12h.asMap},
)).play;
);



TempoClock.default.tempo = 60/60;
Pdef(\pandeiro).play; Pdef(\surdo1).play;
Pdef(\surdo1).set(\seed, 1);
Pdef(\surdo1).set(\seed, 13); // minimal