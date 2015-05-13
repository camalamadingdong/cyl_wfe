classdef TestData
    % Holds data collected in the wave field experiments
    %   Meta Data
    %       - Frequency
    %       - WaveType
    %       - Runs used
    %       - WGSetup
    %       - WGNames
    %   Amplitude
    %       - Linear
    %       - Second order
    %       - Std
    %   Position
    %
    
    properties (Access = private)
        f;
        h;
        body;
        wave;
        motType;
        orient;
        runs;
        wgSetup;
        names;
        startT;
        amps1;
        amps2;
        std1;
        std2;
        mot1;
        mot2;
        motStd1;
        motStd2;
        for1;
        for2;
        forStd1;
        forStd2;
        pos;
    end
    
    properties (SetAccess = private)
        Body;
        MotionType;
        BodyOrient;
        Frequency;
        WaveType;
        WGSetup;
        RunsUsed;
        WGNames;
        StartT;
    end
    
    methods

        function [dat] = TestData(mainDir, body, f, varargin)
            % Creates the TestData object
            %
            %   - mainDir - location of the experimental data
            %   - body - 'none', 'atten', 'flap' for no body, 
            %       attenuator, or flap repectively. 
            %   - f - wave frequency, must be 0.8, 1, or 1.25
            %
            %   Optional arguments:
            %       'Wave', wave - incidnet wave type, 'Plane', 'Focus', 
            %           'Diverge', or 'Random'
            %       'Motion', mot - body motion type, 'Fix', 'Rad', 'Free'
            %       'Orient', orient - body orientation, must be:  
            %           -67.5, -45, -22.5, 0, 22.5, 45, 67.5, 90
            %       'WGSetup', wgSetup - gives the wave gauge setup, 
            %           must be either 1 or 2, or [1 2]. 
            %       'StartT', startT - sets the start time for the data
            %           analysis. i.e., the start time allows the tank to 
            %           settle into a steady state before the data is 
            %           analyzed. 
            
            [opts, args] = checkOptions({{'Wave', 1}, {'Motion', 1}, ...
                {'Orient', 1}, {'WGSetup', 1}, {'StartT', 1}, {'PlotChan', 1}, ...
                {'IgnoreRuns', 1}}, varargin);
            
            % default option values
            wav = 'NA';
            mot = 'NA';
            orien = 'NA';
            plotChans = {};
            wgSet = 2;
            starT = 40;
            ignoreRuns = [];
            
            % read in options
            if (opts(1))
                wav = args{1};
            end
            if (opts(2))
                mot = args{2};
            end
            if (opts(3))
                orien = args{3};
            end
            if (opts(4))
                wgSet = args{4};
            end
            if (opts(5))
                starT = args{5};
            end
            if (opts(6))
                plotChans = args{6};
            end
            if (opts(7))
                ignoreRuns = args{7};
            end
                
                       
            dat = dat.loadData(mainDir, body, f, wav, mot, orien, wgSet, starT, plotChans, ignoreRuns);
            dat.h = 1.16;
        end
        
        function [bod] = get.Body(dat)
            % Get the body type
            bod = dat.body;
        end
        
        function [mot] = get.MotionType(dat)
            % Get the body motions
            mot = dat.motType;
        end
        
        function [orien] = get.BodyOrient(dat)
            % Get the body orientation
            orien = dat.orient;
        end
        
        function [f_] = get.Frequency(dat)
            % Gets the frequency of this run
            f_ = dat.f;
        end
        
        function [wav] = get.WaveType(dat)
            % Gets the wave type of this run
            wav = dat.wave;
        end

        function [wg] = get.WGSetup(dat)
            % Gets the wave gauge setup: 1, 2, or [1 2]
            wg = dat.wgSetup;
        end
        
        function [run] = get.RunsUsed(dat)
            % Gets a list of the runs used to create this data object
            run = dat.runs;
        end
        
        function [nams] = get.WGNames(dat)
            % Gets a list of all the names of all the wave gauges
            nams = dat.names;
        end
        
        function [t_] = get.StartT(dat)
            % Gets the frequency of this run
            t_ = dat.startT;
        end
        
        function [amps] = WaveAmps(dat, names, varargin)
            % Returns the measured amplitudes at the wave gauges specified
            % by 'names'. 
            % 'names' can be either a single wg, e.g. 's1-1'. Or it can be a
            % cell array of individual wg names, e.g. {'s1-1', 'c0', 's0'}. 
            % Or it can be a range, 's1-1:4'. Or it can be all of 'c' or 
            % all of 's'. Or it can be a single spoke, e.g. 's1'.
            % 
            % By default the method returns the complex linear amplitudes. 
            % Optional arguments are:
            %   'Std' - return the standard deviations
            %   'O2' - retunr the second order amplitudes.
            % They can be used together to return the second order standard
            % deviations.
                        
            [opts, args] = checkOptions({{'Std'}, {'O2'}}, varargin);
            
            std = opts(1);
            sec = opts(2);
            
            if (std)
                if (sec)
                    amps = dat.std2;
                else
                    amps = dat.std1;
                end
            else
                if (sec)
                    amps = dat.amps2;
                else
                    amps = dat.amps1;
                end
            end
            
            inds = dat.getMultiPosInd(names);
            
            amps = amps(inds);
        end
        
        function [pos_] = WGPos(dat, names)
            % Returns the (x,y) position of the wave gauges specified by
            % 'names'. See the 'WaveAmps' methed to see how names can be
            % specified.
            
            inds = dat.getMultiPosInd(names);
            
            pos_ = dat.pos(inds,:);
        end
        
        function [forc] = Force(dat, varargin)
            % Returns the complex excitation force. If the run does not
            % contain a force measurement, returns 'NA'
            if (isnan(dat.for1))
                forc = 'NA';
                return
            end
            
            opts = checkOptions({{'Std'}, {'O2'}}, varargin);
            
            std = opts(1);
            sec = opts(2);
            
            if (std)
                if (sec)
                    forc = dat.forStd2;
                else
                    forc = dat.forStd1;
                end
            else
                if (sec)
                    forc = dat.for2;
                else
                    forc = dat.for1;
                end
            end
        end
        
        function [moti] = Motion(dat, varargin)
            % Returns the complex body motions. If the run does not
            % contain a motion measurement, returns 'NA'
            if (isnan(dat.mot1))
                moti = 'NA';
                return
            end
            
            opts = checkOptions({{'Std'}, {'O2'}}, varargin);
            
            std = opts(1);
            sec = opts(2);
            
            if (std)
                if (sec)
                    moti = dat.motStd2;
                else
                    moti = dat.motStd1;
                end
            else
                if (sec)
                    moti = dat.mot2;
                else
                    moti = dat.mot1;
                end
            end
        end
        
        function [cwave] = CirWaves(dat, M)
            % Creates circular waves (with the associated coefficients) for
            % this run from the circular wave gauge array
            etac = dat.WaveAmps('c');

            % compute coefficients from the circle
            if (strcmp(dat.body, 'None'))
                cwave = TestData.CreateCirWaves('In', etac, dat.f, M);
            else
                cwave = TestData.CreateCirWaves('Out', etac, dat.f, M);
            end
        end
        
    end
    
    methods (Static)
        function [cwave] = CreateCirWaves(inOrOut, etac, f, M)
            % Creates circular waves (with the associated coefficients) for
            % this run from the circular wave gauge array
            r0 = 0.8;
            theta = 0:2*pi/24:2*pi*23/24;
            z = 0;
            h = 1.16;

            L = 0;
            
            k = IWaves.SolveForK(2*pi*f, h);

            % compute coefficients from the circle
            if (strcmp(inOrOut, 'In'))
                am = waveDecomp(k, r0, theta, z, h, etac, L, M, 'Incident');
                cwave = CirWaves('In', [0 0], {am}, 1/f, h);
            elseif (strcmp(inOrOut, 'Out'));
                am = waveDecomp(k, r0, theta, z, h, etac, L, M);
                cwave = CirWaves('Out', [0 0], {am}, 1/f, h);
            else
                error('inOrOut must be ''In'' or ''Out''');
            end
        end
    end
    
    methods (Access = private)
        
        function [dat] = loadData(dat, mainDir, body, f, wav, mot, orien, wgSet, starT, plotChans, ignoreRuns)
                                    
            if (ismember(1, wgSet) && ~strcmp(body, 'None'))
                error('Unless body type is ''None'', WGSetup must be 2');
            end
        
            switch wav
                case 'Plane' 
                    wavstr = 'pw';
                case 'Focus'
                    wavstr = 'foc';
                case 'Diverge'
                    wavstr = 'div';
                case 'Random'
                    wavstr = 'rand';
                case 'NA'
                    if ~strcmp(mot, 'Rad')
                        error('Unless body motion is ''Rad'', TestData wave must be provided with optional argument ''Wave''');
                    end
                    wavstr = '';
                otherwise
                    error('Wave type not recognized. Choices are ''Plane'', ''Focus'', ''Diverging'', or ''Random''');
            end
            
            switch f
                case 0.8
                    fstr = 'f080';
                case 1
                    fstr = 'f100';
                case 1.25
                    fstr = 'f125';
                otherwise
                    error('f not recognized');
            end
                             
            startStr = 'Test';
                        
            switch body
                case 'None'
                    startStr = [startStr '_NB'];
                case 'Flap'
                    startStr = [startStr '_Fl'];
                case 'Atten'
                    startStr = [startStr '_At'];
                otherwise
                    error('TestData body not reconized');
            end
                        
            range = [];
            switch mot
                case 'Fix'
                    startStr = [startStr '_Fix'];
                case 'Rad'
                    startStr = [startStr '_Rad'];
                    orien = 0;
                    range = 'Range';
                case 'Free'
                    startStr = [startStr '_Fre'];
                    
                case 'NA'
                    if ~strcmp(body, 'None')
                        error('Unless body type is ''None'', TestData body motions must be provided with optional argument ''Motion''');
                    end
                otherwise
                    error('TestData motion not recognized');
            end
            
            switch orien
                case -67.5
                    startStr = [startStr '_bn675'];
                case -45
                    startStr = [startStr '_bn45'];
                case -22.5
                    startStr = [startStr '_bn225'];
                case 0
                    if (~strcmp(mot, 'Rad'))
                        startStr = [startStr '_b0'];
                    end
                case 22.5
                    startStr = [startStr '_b225'];
                case 45
                    startStr = [startStr '_b45'];
                case 67.5
                    startStr = [startStr '_b675'];
                case 90
                    startStr = [startStr '_b90'];
                case 'NA'
                    if ~strcmp(body, 'None')
                        error('Unless body type is ''None'' or motion is ''Rad'', TestData body orientation must be provided with optional argument ''Orient''');
                    end
                otherwise
                    error('TestData body orientation not recognized');
            end
            
            if strcmp(mot, 'Free')
                startStr = [startStr '_d0'];
            end
            
            dat.f = f;
            dat.body = body;
            dat.wave = wav;
            dat.motType = mot;
            dat.orient = orien;
            dat.wgSetup = wgSet;
            dat.startT = starT;
            
            wgconns = {'cir', 'star', 'sqr'};

            switch sum(wgSet)
                case 1
                    cnt = 60;
                case 2
                    cnt = 59;
                case 3
                    cnt = 70;
            end

            dat.pos = zeros(cnt, 2);
            
            as = zeros(cnt, 20);
            a2s = zeros(cnt, 20);
            eps = zeros(cnt, 20);
            ep2s = zeros(cnt, 20);
            
            acc = zeros(cnt, 1);
            
            f1 = zeros(20, 1);
            f1ep = zeros(20, 1);
            f2 = zeros(20, 1);
            f2ep = zeros(20, 1);
            
            accf = 0;
            
            m1 = zeros(20, 1);
            m1ep = zeros(20, 1);
            m2 = zeros(20, 1);
            m2ep = zeros(20, 1);
            
            accm = 0;
                              
            count = 0;
            
            for l = 1:length(wgSet)
                for m = 1:3

                    if (isempty(wavstr))
                        runz = [startStr '_' fstr '_wg' num2str(wgSet(l)) '_' wgconns{m} '_*.csv'];
                    else
                        runz = [startStr '_' fstr '_' wavstr '_wg' num2str(wgSet(l)) '_' wgconns{m} '_*.csv'];
                    end
                    namez = dir([mainDir '\' runz]);
                    namez = {namez.name};
                    
                    for n = 1:length(namez)
                        nam = namez{n};
                        lnam = length(nam);
                        datestr = nam((lnam-13):(lnam-6));
                        
                        if (strcmp(datestr, '20141106'))
                            % The runs from this day were done on the flap
                            % with out guide wires and are not good.
                            continue;
                        end
                        
                        runNum = str2num(nam(lnam-4));                        
                        if (any(ignoreRuns == runNum))
                            continue;
                        end
                        
                        count = count + 1;
                        allruns{count} = nam;

                        data = wfe_load_data_file([mainDir '\' namez{n}]);   % load the data file
                        cData = wfe_get_cald_data(mainDir, data);      % calibrate data
                        sampleFreq = data.SampleFreq;                   % sample frequency
                        
                        thisEp = 0;
                        if (~strcmp(mot, 'NA'))
                            % Last channel is force or position;
                            nWGs = data.ChannelCount - 1;
                            [~, a, ep, ~, ~, ~, a2, ep2] = wfe_compute_sig_vals(sampleFreq, cData(:,end), 'StartTime', starT, 'ExpectFreq', f, range);
                            
                            wgName = data.WGNames{end};
                            
                            if (strcmp(wgName, 'Force'))
                                accf = accf + 1;
                                
                                f1(accf) = a;
                                f1ep(accf) = ep;
                                f2(accf) = a2;
                                f2ep(accf) = ep2;
                            elseif (strcmp(wgName, 'Position'))
                                accm = accm + 1;
                                                                
                                if (strcmp(mot, 'Rad'))
                                    thisEp = ep;
                                else
                                    thisEp = 0;
                                end
                                
                                m1(accm) = a;
                                m1ep(accm) = dat.wrapEp(ep - thisEp);
                                m2(accm) = a2;
                                m2ep(accm) = dat.wrapEp(ep - thisEp);
                            end
                            % for the radiated wave case - need to zero out
                            % phase  
                        else
                            nWGs = data.ChannelCount;
                        end

                        for o = 1:nWGs
                            [~, a, ep, ~, ~, ~, a2, ep2] = wfe_compute_sig_vals(sampleFreq, cData(:,o), 'StartTime', starT, range);
                            
                            wgName = data.WGNames{o};
                            
                            if (~isempty(plotChans))
                                
                                plotThisChan = false;
                                for p = 1:length(plotChans)
                                    if (strcmp(plotChans{p}, wgName))
                                        plotThisChan = true;
                                        break;
                                    end
                                end
                                
                                if (plotThisChan)
                                    if (strcmp(data.ChanNames{n}, 'Position'))
                                        wgForPos = 'Pos';
                                    elseif (strcmp(data.ChanNames{n}, 'Force'))
                                        wgForPos = 'For';
                                    else
                                        wgForPos = 'WG';
                                    end

                                    t = data.time;
                                    wfe_analyze_chan(cData(:,o), t, starT, sampleFreq, data.ChanNames{o}, data.WGNames{o}, wgForPos, 'TestName', mot, range);
                                end
                            end
                            
                            ind = dat.getPosInd(wgSet(l), wgName);
                            acc(ind) = acc(ind) + 1;
                            
                            if (acc(ind) == 1)
                                dat.pos(ind, :) = wfe_get_wg_pos(wgSet(l), {wgName});
                            end
                            
                            as(ind, acc(ind)) = a;                                                            
                            eps(ind, acc(ind)) = dat.wrapEp(ep - thisEp);
                            a2s(ind, acc(ind)) = a2;
                            ep2s(ind, acc(ind)) = dat.wrapEp(ep2 - thisEp);
                         
                            %disp(sprintf('%i %i %s %i', sum(wgSetup), l, wgName, ind));
                        end
                        
                        clear data cData;
                    end
                end
            end
            
            if (count == 0)
                error('No runs for specified setup found.');
            end
            
            dat.runs = allruns;
            
            for m = 1:cnt
%                 dat.amps1(m) = mean(as(m,1:acc(m))).*exp(1i*mean(eps(m,1:acc(m))));
%                 dat.std1(m) = std(as(m,1:acc(m))).*exp(1i*std(eps(m,1:acc(m))));
%                 dat.amps2(m) = mean(a2s(m,1:acc(m))).*exp(1i*mean(ep2s(m,1:acc(m))));
%                 dat.std2(m) = std(a2s(m,1:acc(m))).*exp(1i*std(ep2s(m,1:acc(m))));
                [mA, stdA] = dat.meanStd(as(m,1:acc(m)), eps(m,1:acc(m)));
                dat.amps1(m) = mA;
                dat.std1(m) = stdA;
                [mA, stdA] = dat.meanStd(a2s(m,1:acc(m)), ep2s(m,1:acc(m)));
                dat.amps2(m) = mA;
                dat.std2(m) = stdA;
            end
            
            if (accf ~= 0)
                [mA, stdA] = dat.meanStd(f1(1:accf), f1ep(1:accf));
                dat.for1 = mA;
                dat.forStd1 = stdA;
                [mA, stdA] = dat.meanStd(f2(1:accf), f2ep(1:accf));
                dat.for2 = mA;
                dat.forStd2 = stdA;
            else
                dat.for1 = NaN;
            end
            
            if (accm ~= 0)
                [mA, stdA] = dat.meanStd(m1(1:accm), m1ep(1:accm));
                dat.mot1 = mA;
                dat.motStd1 = stdA;
                [mA, stdA] = dat.meanStd(m2(1:accm), m2ep(1:accm));
                dat.mot2 = mA;
                dat.motStd2 = stdA;
            else
                dat.mot1 = NaN;
            end           
        end
        
        function [inds] = getMultiPosInd(dat, wgNames)
            
            nWGnames = 1;
            if (iscell(wgNames))
                nWGnames = length(wgNames);
                if (nWGnames == 1)
                    wgNames = wgNames{1};
                end
            end
            
            if (nWGnames > 1)
                startI = 1;
                for n = 1:length(wgNames)
                    ind = dat.getPosInd(length(dat.wgSetup), wgNames{n});
                    stopI = startI + length(ind) - 1;
                    inds(startI:stopI) = ind;
                    startI = stopI + 1;
                end
            else
                inds = dat.getPosInd(length(dat.wgSetup), wgNames);
            end
        end
        
        function [inds] = getPosInd(dat, thisWgSetup, wgName)
            % Setup 1
            % 1:24      c0-c23
            % 25:31     s1 - 1:3, 5:8
            % 32:38     s2 - 1:3, 5:8
            % 39:45     s3 - 1:3, 5:8
            % 46:52     s4 - 1:3, 5:8
            % 53:59     s5 - 1:3, 5:8
            % 60        s0
            
            % Setup 2
            % 1:24      c0-c23
            % 25:31     s1 - 1, 3:8
            % 32:38     s2 - 1, 3:8
            % 39:45     s3 - 1, 3:8
            % 46:52     s4 - 1, 3:8
            % 53:59     s5 - 1, 3:8
            
            % Setup 1 and 2
            % 1:24      c0-c23
            % 25:26     setup 1, s1 - 1:2
            % 27:31     setup 1, s1 - 3, 5:8; setup 2, s1 - 1, 3:6
            % 32:33     setup 2, s1 - 7:8
            % 34:35     setup 1, s2 - 1:2
            % 36:40     setup 1, s2 - 3, 5:8; setup 2, s2 - 1, 3:6
            % 41:42     setup 2, s2 - 7:8
            % 43:44     setup 1, s3 - 1:2
            % 45:49     setup 1, s3 - 3, 5:8; setup 2, s3 - 1, 3:6
            % 50:51     setup 2, s3 - 7:8
            % 52:53     setup 1, s4 - 1:2
            % 54:58     setup 1, s4 - 3, 5:8; setup 2, s4 - 1, 3:6
            % 59:60     setup 2, s4 - 7:8
            % 61:62     setup 1, s5 - 1:2
            % 63:67     setup 1, s5 - 3, 5:8; setup 2, s5 - 1, 3:6
            % 68:69     setup 2, s5 - 7:8
            % 70        s0
                        
            if (length(dat.wgSetup) < 2)
                thisWgSetup = dat.wgSetup;
            end
            
            if (thisWgSetup == 1)
                cwg = 4;
            else
                cwg = 2;
            end
            
            if (length(dat.wgSetup) < 2)
                jump = 7;
                if (dat.wgSetup == 1)
                    totInds = 60;
                else
                    totInds = 59;
                end
            else
                jump = 9;
                totInds = 70;
            end
                        
            if (strcmp(wgName, 'all'))
                inds = 1:totInds;
                return
            end
            
            split = strsplit(wgName, ':');
            if (length(split) > 1)
                wg1 = split{1};
                wg2 = str2num(split{2});
            else
                wg1 = wgName;
                wg2 = [];
            end
            
            if (strcmp(wgName(1),'c'))
                % c0-c23    1:24
                if (length(wgName) == 1)
                    inds = 1:24;
                else
                    if (length(split) > 1)
                        ind1 = str2num(wg1(2:end)) + 1;
                        ind2 = wg2 + 1;
                        inds = ind1:ind2;
                    else
                        inds = str2num(wgName(2:end)) + 1; % add 1 because c begins with c0
                    end
                end
            else
                insrt = @(a, x, n) cat(2,  x(1:n-1), a, x(n:end));
                if (length(wgName) == 1)
                    inds = 25:totInds;
                    for n = 1:4
                        icwg = 3*(n - 1) + 13;
                        inds = insrt(icwg, inds, jump*(n-1)+cwg+n-1);
                    end
                    inds = insrt(1, inds, 4*(jump+1)+cwg);
                else
                    iS = str2num(wgName(2));
                    if (iS == 0)
                        inds = totInds;
                    else
                        rowInd = 24 + jump*(iS - 1);
                        if (iS == 5)
                            icwg = 1;
                        else
                            icwg = 3*(iS - 1) + 13;
                        end   
                         
                        if (length(wgName) == 2)
                            inds = (rowInd+1):(rowInd + jump);
                            inds = insrt(icwg, inds, cwg);
                        else
                            iS2 = str2num(wg1(4:end));
                            iS2i = iS2;
                            
                            if (length(dat.wgSetup) == 2)
                                iS2i = iS2i + 2;
                            end
                                
                            if (iS2 > cwg)
                                iS2i = iS2i - 1;
                            end

                            ind1 = rowInd + iS2i;
                            
                            if (length(split) > 1)
                                iwg2 = wg2;
                                if (wg2 >= cwg)
                                    iwg2 = iwg2 - 1;
                                end
                                ind2 = ind1 + iwg2 - iS2;
                                inds = ind1:ind2;
                                if ((iS2 <= cwg) && (wg2 >= cwg))
                                    inds = insrt(icwg, inds, cwg-iS2+1);
                                end
                            else
                                if (iS2 == cwg)
                                    inds = icwg;
                                else
                                    inds = ind1;
                                end
                            end
                        end
                    end
                end
            end
        end
        
        function [mA, stdA] = meanStd(data, a, ep)
            mA1 = mean(a);
            stdA1 = std(a);
            
            nEp = length(ep);
            
            if (ep(1) > pi || ep(1) < -pi)
                error('ep out of range');
            end
            
            sumEp = ep(1);            
            for n = 2:nEp
                if (ep(n) > pi || ep(n) < -pi)
                    error('ep out of range');
                end
                diffEp = abs(ep(n) - ep(n-1));
                if (diffEp > pi)
                    if (sumEp > 0)
                        ep(n) = ep(n) + 2*pi;
                    else
                        ep(n) = ep(n) - 2*pi;
                    end
                end
                
                sumEp = sumEp + ep(n);
            end
            
            mEp = sumEp/nEp;
            mEp2 = mean(ep);
            stdEp = std(ep);
            
            mA = mA1*exp(1i*mEp);
            stdA = stdA1*exp(1i*stdEp);
        end
        
        function [epo] = wrapEp(data, epin)
            if (abs(epin) > 2*pi)
                error('ep out of range');
            end
            
            if (epin > pi)
                epo = epin - 2*pi;
            elseif (epin < -pi)
                epo = epin + 2*pi;
            else
                epo = epin;
            end
        end
    end
        
end