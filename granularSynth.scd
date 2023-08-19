s.boot;
b = Buffer.readChannel(s, "", channels: [0]);
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
		trigger: Impulse.ar(\grainDensity.kr(10)),
		dur: \grainDur.kr(1),
		sndbuf: b,
		pos: \bufferPos.kr(0.2),
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512
	);
	Out.ar(\out.kr(0) ,sig);
}).add;
)


x = Synth.new(\syncGranulator, [grainDur: 0.1, grainDensity: 45]);

/*
Elementos de la GUI
*/
(
w = Window.new("Granulator", Rect(200,300,400,500));
w.alwaysOnTop_(true);
w.front;.
~grainDensitySlider = Slider.new();
~grainDensitySlider.action_({
	arg grainDensity;
	x.set(\grainDensity, grainDensity.value.linexp(0,1,1,200));
});
~grainDurationSlider = Slider.new();
~grainDurationSlider.action_({
	arg dur;
	x.set(\grainDur, dur.value.linexp(0,1,0.01,0.1));
});
~bufferPosSlider = Slider.new();
~bufferPosSlider.action_({
	arg pos;
	x.set(\bufferPos, pos.value.linexp(0,1,0.01,1));
});

~recording = false;
~recordButton = Button.new();
~recordButton.action({
 	/*if(~recording) {
 		s.stopRecording();
 		~recording = false;
 	}, {
 		s.record();
 		~recording = true;
	}*/
	s.record;
 });

w.layout_(GridLayout.rows([~grainDensitySlider, ~grainDurationSlider,~bufferPosSlider,~recordButton]));
)

s.stopRecording;
/* Listo mensajes que reciben las Views */
// enabled, visible, background_(Color.new()), orientation, action_(function)
// Action set