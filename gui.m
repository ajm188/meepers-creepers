function gui
f = figure('Name', 'Welcome to meepers creepers', 'MenuBar', 'none', 'Position', [1 1 330 175]);
movegui(f, 'center');

runButton = uicontrol('Style', 'pushbutton', 'String', 'Run It!', 'Callback', @runIt, 'Position', [25 25 80 25]);
abortButton = uicontrol('Style', 'pushbutton', 'Enable', 'off', 'String', 'Abort!', 'Callback', @abort, 'Position', [105 25 80 25]);
progBox = uicontrol('Style', 'edit', 'String', 'asm/yams', 'Position', [200 100 100 40]);
uicontrol('Style', 'text', 'String', 'Enter program basename (without -code.bin or -data.bin)',...
    'Position', [25 100 130 40]);

    function runIt(s, e)
        progName = get(progBox, 'String');
        set(runButton, 'Enable', 'off');
        set(runButton, 'String', 'Running!');
        set(abortButton, 'Enable', 'on');
        
        % Delete any old abort file
        delete('shouldistop.txt');
        
        % Execution will happen in timer callbacks after
        % this function returns.
        execProg(progName);
    end

    % FIXME: This function doesn't work yet. RunIt() never returns
    % from its callback which causes the callback thread to hang. This
    % means the abort() callback is never delivered while execProg() is
    % running. We will investigate throwing the emulation onto another
    % thread for the final version.
    function abort(s, e)
        
        fid = fopen('shouldistop.txt', 'w');
        if fid >= 0
            fprintf(fid, 'Yes, you should stop');
            fclose(fid);
        end
                
        set(runButton, 'Enable', 'on');
        set(runButton, 'String', 'Run It!');
        set(abortButton, 'Enable', 'off');
    end
end
