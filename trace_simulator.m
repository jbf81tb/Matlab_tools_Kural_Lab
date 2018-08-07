function trace = trace_simulator(varargin)
%TRACE_SIMULATOR Simulate AP2 traces based on various model parameters
% List of model paremters:
% poff - percent of off, photobleached, or unlabeled AP2 molecules
% flint - fluorophore intensity under a normal distribution
% dt - control timestep size for binding probability
% binding probability currently a flat 1 per second, but can be varried
%   based on many factors, includiing possible the number of currently 
%   bound molecules.
% bkgrd - camera noise. ****Should be modeled more accurately.****
% len - number of fluorophores in a completed pit. currently a normal
%   distribution
% each time point has a normally distributed noise associated with it.
% each trace has a chance of stopping at any time after a fluorophore 
%   binds. currently 1% chance.
% unt - uncoating time of the pit is proportional to the coating time, with
%   normally distributed variance
% unpdt - uncoating amount per time point. uncoating should correspond to a
%   3d random walk upwards. currently just a linear decrease in intensity
%   with a flat distributed variance and normally distributed background
%   noise
% platt - platteau time of the pit is proportional to the coating time,
%   with normally distributed variance
% when the uncoating intensity falls below a certain background intensity
%   the coat is considered complete.
% Things to work on:
%   Modeling background noise
%   Modeling uncoating
%   Different models for coating
%   How should the variance in fluorophre intensity be modeled?
%   Does poff affect things?
%   Does dt conversion affect things?
switch nargin
    case 0
        nfl = 1000;
        frame_rate = 2;
    case 1
        nfl = varargin{1};
        frame_rate = 2;
    case 2
        nfl = varargin{1};
        frame_rate = varargin{2};
end
poff = 0.2; 
flint = (10*randn(nfl,1)+120).*(rand(nfl,1)>poff);
trace = struct('full_int',cell(nfl,1));
tpdt = 0.1; %time per dt in seconds
br = 1; %binding rate in seconds
tn = 1; %trace counter
fl = 1; %fluorophore counter
while true
    coat = false; uncoat = false;
    dt = length(trace(tn).full_int)+1; %dt = 0.1s, reminder: on average, 1 fl per second
    fln = 0; %fluorophore per trace counter
    bkgrd = 400+20*randn;
    mnnfl = 40;
    len = max(1,round(10*randn+mnnfl));
    prob_success = 10^(-6*tpdt/(2*len));
    trace(tn).full_int(dt) = bkgrd;
    dt=dt+1;
    while ~coat
        if rand>tpdt*br
            trace(tn).full_int(dt) = trace(tn).full_int(dt-1)+20*randn;
        else
            if fl>nfl, trace = trace(1:tn-1); return; end
            trace(tn).full_int(dt) = trace(tn).full_int(dt-1)+flint(fl);
            fl=fl+1; fln=fln+1;
            if fln==len, coat=true; end
        end
        if rand>prob_success*((1-prob_success)*(fln/len)+1)*(fln>9)+(fln<=9)*(.99-exp(2*(fln-9.5))), coat=true; end
        dt=dt+1;
    end
%     if trace(tn).full_int(dt-1)<=bkgrd, continue; end
    unt = max(1,round(dt*(.2*randn+.6)));
    unpdt = trace(tn).full_int(dt-1)/unt;
    if fln==len
        platt = max(1,round(br*mnnfl/tpdt*(.05*randn+.6)));
    else
        platt = dt*rand;
    end
    for i = 1:platt
        trace(tn).full_int(dt) = trace(tn).full_int(dt-1)+20*randn;
        dt=dt+1;
    end
    test = 1;
    while ~uncoat
        unptt = (.75+.5*rand)*unpdt + 20*randn;
        trace(tn).full_int(dt) = trace(tn).full_int(dt-1)-unptt;
        if trace(tn).full_int(dt)<=bkgrd, uncoat=true; end
        dt=dt+1;
        test = test+1;
    end
    trace(tn).full_int = trace(tn).full_int + 10*randn(size(trace(tn).full_int));
    trace(tn).int = trace(tn).full_int(ceil(rand*frame_rate/tpdt):frame_rate/tpdt:end)';
    if length(trace(tn).int)<2, trace(tn) = []; continue; end
    if rand>.01
        tn=tn+1;
    end
end
end