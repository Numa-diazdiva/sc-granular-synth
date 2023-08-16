s.boot;
b = Buffer.readChannel(s, "archivo-de-audio.wav", channels: [0]);
b.play;


s.plotTree;
s.plotTreeView;

/*
SynthDef granulador sincrónico
*/

(
SynthDef.new(\syncGranulator,
{
	var sig;
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.ar(\rate.kr(10)),
		dur: \grainDur.kr(1),
		sndbuf: b,
		pos: 0.5,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512
	);
	Out.ar(\out.kr(0) ,sig);
}).add;
)


x = Synth.new(\syncGranulator, [grainDur: 0.1, rate: 45]);


(
/*
Elementos de la GUI
*/
w = Window.new("Granulator", Rect(200,300,400,500));
w.alwaysOnTop_(true);
w.front;
~rateSlider = Slider.new();
~rateSlider.action_({
	arg rate;
	x.set(\rate, rate.value.linexp(0,1,1,200));
});
~grainDurationSlider = Slider.new();
~grainDurationSlider.action_({
	arg dur;
	x.set(\grainDur, dur.value.linexp(0,1,0.01,0.1));
});



w.layout_(GridLayout.rows([~rateSlider, ~grainDurationSlider]));
)

/* Listo mensajes que reciben las Views */
// enabled, visible, background_(Color.new()), orientation, action_(function)
// Action set