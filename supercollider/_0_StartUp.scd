(
SynthDef("ana_kick", {
	arg out=0, pan=0;
	var env, env2, env3, pch, osc, noise, outS;
	env = EnvGen.kr(Env.perc(0, 0.20, 1, -4), doneAction:2);
	env2 = EnvGen.kr(Env.new([60,3,0],[0.08,0.16],[-18,-5]));
	env3 = EnvGen.kr(Env.new([0.8,0],[0.10],[-10]));
	pch = (32+env2).midicps;

	osc = SinOsc.ar(pch, 0, env);
	noise = BPF.ar(WhiteNoise.ar(env3), 200, 2);
	outS = osc+noise;
	Out.ar(out, Pan2.ar(outS, pan));
}).add;

SynthDef("ana_snare", {
	arg out, pan=0;
	var env, env2, env3, pch, osc, noise, outS;
	env = EnvGen.kr(Env.perc(0, 0.05, 1, -5));
	env2 = EnvGen.kr(Env.new([56,3,0],[0.08,0.1],[-20,-5]));
	env3 = EnvGen.kr(Env.new([0.5,0,0.5,0],[0.001,0.001,0.16],[0,-3,-8]), doneAction:2);
	pch = (49+env2).midicps;

	osc = SinOsc.ar(pch, 0, env);
	noise = BPF.ar(WhiteNoise.ar(env3), 9000, 2);
	outS = osc+noise;
	Out.ar(out, Pan2.ar(outS, pan));
}).add;

SynthDef("ana_hat", {
	arg out=0, pan=0, decay=0.05;
	var env, pch, osc, noise, outS;
	env = EnvGen.kr(Env.perc(0, decay, 1, -6), doneAction:2);
	pch = (SinOsc.ar(320, 0, 2000, 9000));
	osc = SinOsc.ar(pch, 0, 0.5);
	noise = WhiteNoise.ar;
	outS = osc + noise;
	outS = BPF.ar(outS, 12000, 0.3, env);
	Out.ar(out, Pan2.ar(outS, pan));
}).add;

);

/*
(instrument: 'ana_kick').play;
(instrument: 'ana_snare').play;
(instrument: 'ana_hat').play;
s.meter
*/
().play
s.boot
//-- sure works in Tdef for me. How to write as parametrizable Pdef?

Tdef('1999_1').set(\dt, 1/4, \n, 24);
Tdef('1999_1', {|e|
	e.n.do({
		4.do({|i|
			var instr = [\ana_kick, \ana_hat, \ana_snare, \ana_hat] @@ i;
			( instrument, instr, pan e.pan).play;

			e.dt.wait;
		});
	});
});

Tdef('1999_1').play;
Tdef('1999_1').stop;

// clone
Tdef('1999_2').source = Tdef('1999_1').source;

// set both differently
q=q?();
q.totDur = 9*60; // unused
q.totNum = 128*2;
Tdef('1999_1').set(\pan, -0.8, \dt, 1/4, \n, q.totNum+1);
Tdef('1999_2').set(\pan, 0.8, \dt, 1/4 / (q.totNum-1)*q.totNum, \n, q.totNum-1+1);

// play both at once
[Tdef('1999_1'), Tdef('1999_2')].do( _.play );
