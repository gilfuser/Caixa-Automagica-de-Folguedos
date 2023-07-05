
q.data = 1!5;
q.port.isOpen
q.enc_12h.get
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
    var enc_10h_arr = [238, nil, 239];  //protocol
    var enc_10_arr2 = enc_10h_arr.copy;
    var enc_8h_arr = [239, nil, 240];  //protocol
    var enc_8_arr2 = enc_8h_arr.copy;
    var enc_6h_arr = [240, nil, 241];  //protocol
    var enc_6_arr2 = enc_6h_arr.copy;
    var enc_4h_arr = [241, nil, 242];  //protocol
    var enc_4_arr2 = enc_4h_arr.copy;
    var enc_2h_arr = [242, nil, 243];  //protocol
    var enc_2_arr2 = enc_2h_arr.copy;
    var btn_12h_arr = [243, nil, 244];  //protocol
    var btn_12_arr2 = btn_12h_arr.copy;
    var btn_10h_arr = [244, nil, 245];  //protocol
    var btn_10_arr2 = btn_10h_arr.copy;
    var btn_8h_arr = [245, nil, 246];  //protocol
    var btn_8_arr2 = btn_8h_arr.copy;
    var btn_6h_arr = [246, nil, 247];  //protocol
    var btn_6_arr2 = btn_6h_arr.copy;
    var btn_4h_arr = [247, nil, 248];  //protocol
    var btn_4_arr2 = btn_4h_arr.copy;
    var btn_2h_arr = [248, nil, 249];  //protocol
    var btn_2_arr2 = btn_2h_arr.copy;
    var enc_12h_match, enc_10h_match, enc_8h_match, enc_6h_match, enc_4h_match, enc_2h_match;
    var btn_12h_match, btn_10h_match, btn_8h_match, btn_6h_match, btn_4h_match, btn_2h_match;

    var enc_12h_arr = [237, nil, 238, nil, 239];  //protoco
    var enc_12_arr2 = enc_12h_arr.copy;
    var index = 0;
    var func = {|e12, e10, enc = #[0, 0]|
        enc = [e12, e10];
        MFdef(\arduino).value(enc);
    };
    enc_12h_match = {|byte|  //like match in maxmsp
        if( enc_12h_arr[index].isNil or:{ enc_12h_arr[index] == byte }, {
            enc_12_arr2[index]= byte;
            index= index+1;
            if(index >= enc_12h_arr.size, {
                q.enc_12h.value = enc_12_arr2[1];
                q.enc_10h.value = enc_12_arr2[3];
                func.value(enc_12_arr2[1], enc_12_arr2[3]);
                index= 0;
            });
        }, { index = 0; } );
    };
    q.enc_10h.get;
    enc_10h_match = {|byte|  //like match in maxms
        if( enc_10h_arr[index].isNil or:{ enc_10h_arr[index] == byte }, {
            enc_10_arr2[index]= byte;
            index= index+1;
            if(index>=enc_10h_arr.size, {
                q.enc_10h.value = enc_10_arr2[1];
                func.value(enc_10_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    enc_8h_match = {|byte|  //like match in maxmsp
        if( enc_8h_arr[index].isNil or:{ enc_8h_arr[index] == byte }, {
            enc_8_arr2[index]= byte;
            index= index+1;
            if(index>=enc_12h_arr.size, {
                q.enc_8h.value(enc_8_arr2[1]);
                func.value(enc_8_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    enc_6h_match = {|byte|  //like match in maxmsp
        if( enc_6h_arr[index].isNil or:{ enc_6h_arr[index] == byte }, {
            enc_6_arr2[index]= byte;
            index= index+1;
            if(index>=enc_6h_arr.size, {
                q.enc_6h.value(enc_6_arr2[1]);
                func.value(enc_6_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    enc_4h_match = {|byte|  //like match in maxmsp
        if( enc_4h_arr[index].isNil or:{ enc_4h_arr[index] == byte }, {
            enc_4_arr2[index]= byte;
            index= index+1;
            if(index>=enc_4h_arr.size, {
                q.enc_4h.value(enc_4_arr2[1]);
                func.value(enc_4_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    enc_2h_match = {|byte|  //like match in maxmsp
        if( enc_2h_arr[index].isNil or:{ enc_2h_arr[index] == byte }, {
            enc_2_arr2[index]= byte;
            index= index+1;
            if(index>=enc_2h_arr.size, {
                q.enc_2h.value(enc_2_arr2[1]);
                func.value(enc_2_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };

    index = 0;
    btn_12h_match = {|byte|  //like match in maxmsp
        if( btn_12h_arr[index].isNil or:{ btn_12h_arr[index] == byte }, {
            btn_12_arr2[index]= byte;
            index= index+1;
            if(index>=btn_12h_arr.size, {
                q.btn_12h.value(btn_12_arr2[1]);
                func.value(btn_12_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    q.btn_10h_match = {|byte|  //like match in maxmsp
        if( btn_10h_arr[index].isNil or:{ btn_10h_arr[index] == byte }, {
            btn_10_arr2[index]= byte;
            index= index+1;
            if(index>=btn_12h_arr.size, {
                q.btn_10h.value(btn_10_arr2[1]);
                func.value(btn_10_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    q.btn_8h_match = {|byte|  //like match in maxmsp
        if( btn_8h_arr[index].isNil or:{ btn_8h_arr[index] == byte }, {
            btn_8_arr2[index]= byte;
            index= index+1;
            if(index>=btn_12h_arr.size, {
                q.btn_8h.value(btn_8_arr2[1]);
                func.value(btn_8_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    q.btn_6h_match = {|byte|  //like match in maxmsp
        if( btn_6h_arr[index].isNil or:{ btn_6h_arr[index] == byte }, {
            btn_6_arr2[index]= byte;
            index= index+1;
            if(index>=btn_6h_arr.size, {
                q.btn_6h.value(btn_6_arr2[1]);
                func.value(btn_6_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    q.btn_4h_match = {|byte|  //like match in maxmsp
        if( btn_4h_arr[index].isNil or:{ btn_4h_arr[index] == byte }, {
            btn_4_arr2[index]= byte;
            index= index+1;
            if(index>=btn_4h_arr.size, {
                q.btn_4h.value(btn_4_arr2[1]);
                func.value(btn_4_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    index = 0;
    q.btn_2h_match = {|byte|  //like match in maxmsp
        if( btn_2h_arr[index].isNil or:{ btn_2h_arr[index] == byte }, {
            btn_2_arr2[index]= byte;
            index= index+1;
            if(index>=btn_2h_arr.size, {
                q.btn_2h.value(btn_2_arr2[1]);
                func.value(btn_2_arr2[1]);
                index= 0;
            });
        }, { index = 0; } );
    };
    Tdef(\readPort, {
        "oi".postln;
        inf.do{
            //0.2.wait;
            enc_12h_match.value(q.port.read);
            // enc_10h_match.value(q.port.read);
            // enc_8h_match.value(q.port.read);
            // enc_6h_match.value(q.port.read);
            // enc_4h_match.value(q.port.read);
            /* if(q.port.read==237, {
                while({q.byte = q.port.read; q.byte !=238 }, {
                    q.enc_12h.value = q.byte;
                    q.enc_12h.get
                });
            }); */
            /* q.btn_10h_match.value(q.port.read);
            q.btn_8h_match.value(q.port.read);
            q.btn_6h_match.value(q.port.read);
            q.btn_4h_match.value(q.port.read);
            q.btn_2h_match.value(q.port.read);
            q.enc_12h_match.value(q.port.read);
            q.enc_10h_match.value(q.port.read);
            q.enc_2h_match.value(q.port.read); */
        };
    }).play;
};
);
MFdef(\arduino).add(\post, { |msg| msg.postln})
MFdef(\arduino).remove(\post)
Tdef(\readPort).gui
q.btn_12h.value = 1
q.btn_12h.get
