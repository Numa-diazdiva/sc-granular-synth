(
s.boot;
b = Buffer.readChannel(server: s, path: "/home/numa/Escritorio/Radar de Carne.wav", channels: [0]);
)

s.plotTree;
s.plotTreeView;
b.play;

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


~openFile = {
	var fileLocation = "";
	Dialog.openPanel(
		okFunc: {
			arg path;
			fileLocation = path.value;
			path.postln;
		}
	);
	fileLocation;
}
~openFile.value;

currentEnvironment;

/*
Elementos de la GUI
*/
(
var grainDensityControl, grainDurationControl, bufferPosControl, recordControl, openFileControl, controlPanel;
w = Window.new("Granulator", Rect(200,300,400,200));
w.alwaysOnTop_(true);
w.front;

b = Buffer.readChannel(server: s, path: "/home/numa/Escritorio/Radar de Carne.wav", channels: [0]);
x = Synth.new(\syncGranulator, [grainDur: 0.1, grainDensity: 45]);

grainDensityControl = VLayout(
	StaticText().string_("density"),
	Slider.new()
	      .action_({
		     arg grainDensity;
	         x.set(\grainDensity, grainDensity.value.linexp(0,1,1,200));
	      })
);

grainDurationControl = VLayout(
	StaticText().string_("duration"),
	Slider.new()
	      .action_({
		     arg dur;
	         x.set(\grainDur, dur.value.linexp(0,1,0.01,0.1));
	      })
);

bufferPosControl = VLayout(
	StaticText().string_("bufferPos"),
	Slider.new()
	      .action_({
		     arg pos;
		     x.set(\bufferPos, pos.value.linexp(0,1,0.01,1));
	      })
);

~recording = false;
recordControl = VLayout(
	Button.new().action_({
		if(~recording, {
			  s.stopRecording;
		    },
		    {
			  s.record;
		    });
		~recording = ~recording.not;
	})
	.string_("Record");
);

openFileControl = VLayout(
	Button.new().action_({
		Dialog.openPanel(
		okFunc: {
				arg path;
				b = Buffer.readChannel(s, path.value, channels: [0]);
			}
		);

		x = Synth.new(\syncGranulator, [grainDur: 0.1, grainDensity: 45]);
	}).string_("Open")
);

controlPanel = VLayout(recordControl, openFileControl);

w.layout_(GridLayout.rows([grainDensityControl,grainDurationControl,bufferPosControl,controlPanel]));
)


/* Custom wrapper que tengo que arreglar */
(
CustomWrapper {
	var wrapper, label;

	*new { | children, label |
        ^super.new.init(children, label)
    }

    init { | children, label |
		this.label = StaticText.new();
		this.label.string(label)
		this.wrapper = VLayout.new([ this.label, children ]);
    }

}

~slider = Slider.new();
~wrapper = CustomWrapper.new(~slider, )
)