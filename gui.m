function gui
figure('Name', 'Welcome to meepers creepers');

uicontrol('Style', 'pushbutton', 'String', 'Run It!', 'Callback', @runIt, 'Position', [25 25 80 25]);
uicontrol('Style', 'pushbutton', 'String', 'Abort!', 'Callback', @abort, 'Position', [105 25 80 25]);
progBox = uicontrol('Style', 'edit', 'String', 'asm/yams', 'Position', [250 100 75 40]);
uicontrol('Style', 'text', 'String', 'Enter program basename (without -code.bin or -data.bin)',...
    'Position', [100 100 130 40]);

    function runIt(s, e)
        progName = get(progBox, 'String');
        execProg(progName);
    end

    function abort(s, e)
        cpustate.halted = 1;
    end
end
