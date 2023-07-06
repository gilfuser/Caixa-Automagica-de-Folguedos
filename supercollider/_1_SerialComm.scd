
(
q.enc_12h = q.enc_12h ? Bus.control().set(0);
q.enc_10h = q.enc_10h ? Bus.control().set(0);
q.enc_8h = q.enc_8h ? Bus.control().set(0);
q.enc_6h = q.enc_6h ? Bus.control().set(0);
q.enc_4h = q.enc_4h ? Bus.control().set(0);
q.enc_2h = q.enc_2h ? Bus.control().set(0);
q.btn_12h =q.btn_12h ? Bus.control().set(0);
q.btn_10h = q.btn_10h ? Bus.control().set(0);
q.btn_8h = q.btn_8h ? Bus.control().set(0);
q.btn_6h = q.btn_6h ? Bus.control().set(0);
q.btn_4h = q.btn_4h ? Bus.control().set(0);
q.btn_2h = q.btn_2h ? Bus.control().set(0);

{
    q.port  = SerialPort("/dev/ttyACM0", 38400, crtscts: true);
    CmdPeriod.doOnce({ q.port.close});
    s.sync;
}.fork;
);
(
fork{
    var arr = [254, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 255];  //protoco
    var arr2 = arr.copy;
    var index = 0;
    var func = {|e12, e10, e8, e6, e4, e2, b12, b10, b8, b6, b4, b2, data = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]|
        data = [e12, e10, e8, e6, e4, e2, b12, b10, b8, b6, b4, b2];
                q.enc_12h.value = e12;
                q.enc_10h.value = e10;
                q.enc_8h.value = e8;
                q.enc_6h.value = e6;
                q.enc_4h.value = e4;
                q.enc_2h.value = e2;
                q.btn_12h.value = b12;
                q.btn_10h.value = b10;
                q.btn_8h.value = b8;
                q.btn_6h.value = b6;
                q.btn_4h.value = b4;
                q.btn_2h.value = b2;
        MFdef(\botoes).value(data);
    };
    var match = {|byte|  //like match in maxmsp
        if( arr[index].isNil or:{ arr[index] == byte }, {
            arr2[index]= byte;
            index= index+1;
            if( index >= arr.size, {
                func.value( arr2[1], arr2[2], arr2[3], arr2[4], arr2[5], arr2[6], arr2[7], arr2[8], arr2[9], arr2[10], arr2[11], arr2[12] );
                index= 0;
            });
        }, { index = 0; } );
    };
    Tdef(\readPort, {
        "oi".postln;
        inf.do{
            //0.2.wait;
            match.value(q.port.read);
        };
    }).play;
};
);
MFdef(\botoes).add(\post, { |msg| msg.postln})
MFdef(\botoes).enable(\post)
Tdef(\readPort).gui
q.btn_12h.value = 1
q.btn_12h.get
