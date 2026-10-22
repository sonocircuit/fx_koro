FxKoro : FxBase {

    *new { 
        var ret = super.newCopyArgs(nil, \none, (
            rate: 0.4,
            depth: 0.2,
            spread: 1
        ), nil, 0.5);
        ^ret;
    }

    *initClass {
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_koro";
    }  

    symbol {
        ^\fxKoro;
    }

    addSynthdefs {
        SynthDef(\fxKoro, {
          	arg outBus, inBus, rate = 0.1, depth = 0.2, spread = 1;
            var in, snd, preDel, tMod;
            var rskew = [0.94, 0.96, 0.99, 1, 1.02, 1.03, 1.06];
            var pskew = [2, 1, 0, 3, 4];
            // scale, slew, clamp;
            rate = Lag.kr(rate);
            spread = Lag.kr(spread);
            depth = Lag.kr(depth).linlin(0, 1, 0.01, 0.70);
            preDel = rate.explin(0.1, 6, 0.05, 0.02);
            // modulation
            tMod = LFPar.kr(rate * rskew, pskew).range((1 - depth), 1);
            // delay, modulate, spread
            in = In.ar(inBus, 2);
            snd = DelayC.ar(in, 0.04, preDel * tMod);
            snd = Splay.ar(snd, spread);
            Out.ar(outBus, snd);
        }).add;
    }

}