s.boot;
b = Buffer.readChannel(s, "");
b.play;

// enabled, visible, background_(Color.new()), orientation, action_(function)
// Action set

(
/*
Elementos de la GUI
*/
w = Window.new("Granulator", Rect(200,300,400,500));
w.alwaysOnTop_(true);
~guiVolSlider = Slider.new();
~guiVolSlider.action_({
	arg v;

});
w.front;s
w.layout_(HLayout(~guiVolSlider));
)

(
{
	var sig;
	var triggSignal;
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: triggSignal,
		dur: \grainDur.kr(1),
		sndbuf: b,
		pos: 0.5,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512
	);
}.play
)

(

)