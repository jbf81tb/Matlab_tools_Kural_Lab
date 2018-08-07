function nd2_to_tif(num_files, file_wait)
%
%NUM_FILES is the number of files in the folder
%FILE_WAIT is the amount of time, in seconds, that should be waited for
%  in between each conversion. So it should be just slightly longer
%  than the longest file conversion time
%
%To use this code, I expect the user to convert the first file in the folder
%  manually. This will set up everything for NIS-Elements to work properly.
%
%This code will only run through one folder.
%  
%After this function is started, the user will have 3 seconds to bring
%  NIS-Elements into focus.
%
%To be clear, this funciton takes over the keyboard, so the computer
%  cannot be used at all while this function is executing.

import java.awt.*;
import java.awt.event.*;
rob = Robot;
pause(3)
press_wait = 0.001;
between_wait = 0.1;



for i = 1:num_files-1

rob.keyPress(KeyEvent.VK_CONTROL)
    rob.keyPress(KeyEvent.VK_F4)
    pause(press_wait)
    rob.keyRelease(KeyEvent.VK_F4)

    pause(between_wait)
    
    rob.keyPress(KeyEvent.VK_F12)
    pause(press_wait)
    rob.keyRelease(KeyEvent.VK_F12)
rob.keyRelease(KeyEvent.VK_CONTROL)

pause(between_wait)

rob.keyPress(KeyEvent.VK_SHIFT)
    rob.keyPress(KeyEvent.VK_TAB)
    pause(press_wait)
    rob.keyRelease(KeyEvent.VK_TAB)

    pause(between_wait)
    
    rob.keyPress(KeyEvent.VK_TAB)
    pause(press_wait)
    rob.keyRelease(KeyEvent.VK_TAB)
rob.keyRelease(KeyEvent.VK_SHIFT)

for j = 1:2*i
    rob.keyPress(KeyEvent.VK_DOWN)
    pause(press_wait)
    rob.keyRelease(KeyEvent.VK_DOWN)
    pause(between_wait)
end

rob.keyPress(KeyEvent.VK_ENTER)
pause(press_wait)
rob.keyRelease(KeyEvent.VK_ENTER)

pause(1)

rob.keyPress(KeyEvent.VK_ALT)
    rob.keyPress(KeyEvent.VK_F)
    pause(press_wait)
    rob.keyRelease(KeyEvent.VK_F)
rob.keyRelease(KeyEvent.VK_ALT)

pause(between_wait)

rob.keyPress(KeyEvent.VK_E)
pause(press_wait)
rob.keyRelease(KeyEvent.VK_E)

pause(1)

rob.keyPress(KeyEvent.VK_ENTER)
pause(press_wait)
rob.keyRelease(KeyEvent.VK_ENTER)

pause(file_wait)

end

rob.keyPress(KeyEvent.VK_ALT)
    rob.keyPress(KeyEvent.VK_F4)
    pause(press_wait)
    rob.keyRelease(KeyEvent.VK_F4)
rob.keyRelease(KeyEvent.VK_ALT)

pause(between_wait)

rob.keyPress(KeyEvent.VK_ENTER)
pause(press_wait)
rob.keyRelease(KeyEvent.VK_ENTER)
end