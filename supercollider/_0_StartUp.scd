
q.data = 1!5;
(
{
    q.port  = SerialPort("/dev/ttyACM0", 38400, crtscts: true);
    CmdPeriod.doOnce({ q.port.close});
    s.sync;
}.fork;
);
q.port.next
(
fork{
var func= { | x, y, data= #[ 1, 1 ] |
    //x = x.linlin( 0, 255, 0, 1 ).round(0.01);
    //y = y.linlin( 0, 255, 0, 1 ).round(0.01);
    data = [x, y];
    /*
    ("x " ++ x.round(0.01)++"  y "++ y.round(0.001)++"  z "++ z.round(0.01)).postln;  //check
    */
    q.data = data;
    MFdef(\arduino).value(data);
};
var arr= [249250, 251, 252, 253, 254, nil, nil, 255];  //protocol
var arr2= arr.copy;
var index= 0;
var match= {|byte|  //like [match] in maxmsp
        if(arr[index].isNil or:{arr[index]==byte}, {
                arr2[index]= byte;
                index= index+1;
                if(index>=arr.size, {
                        func.value(arr2[4], arr2[5]);
                        index= 0;
                });
        }, {
                index= 0;
        });
};var read = Routine.run({
    inf.do{
        match.value(q.port.read);
    };
});
};
);
MFdef(\arduino).add(\post, { |msg| msg.postln})
MFdef(\arduino).remove(\post)
