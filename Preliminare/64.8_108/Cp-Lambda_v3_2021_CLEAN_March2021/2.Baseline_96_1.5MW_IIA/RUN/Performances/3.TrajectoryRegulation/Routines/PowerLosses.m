function PowerVector=PowerLosses(PowerVector)

FullPower=[0 3300]*1000;
PowerLosses=[0 300]*1000;
NetPower = FullPower - PowerLosses;

PowerVector = spline(FullPower,NetPower,PowerVector);
