function [i_dc] = createIdc(R,i_ph,setup)
if(setup.SEQ == 127) %0127
    if R == 1
        i_dc = [0, i_ph(1), -i_ph(3),0,  -i_ph(3), i_ph(1),   0,    0];
    elseif R == 2
        i_dc = [0, -i_ph(3), i_ph(2),0,  i_ph(2), -i_ph(3),   0,    0];
    elseif R == 3
        i_dc = [0, i_ph(2), -i_ph(1),0,  -i_ph(1), i_ph(2),   0,    0];
    elseif R == 4
        i_dc = [0, -i_ph(1), i_ph(3),0,  i_ph(3), -i_ph(1),   0,    0];
    elseif R == 5
        i_dc = [0, i_ph(3), -i_ph(2),0,  -i_ph(2), i_ph(3),   0,    0];
    else
        i_dc = [0, -i_ph(2), i_ph(1),0,  i_ph(1), -i_ph(2),   0,    0];
    end
elseif(setup.SEQ == 12) %012
    if R == 1
        i_dc = [0, i_ph(1), -i_ph(3),0,  -i_ph(3), i_ph(1),   0,    0];
    elseif R == 2
        i_dc = [0, -i_ph(3), i_ph(2),0,  i_ph(2), -i_ph(3),   0,    0];
    elseif R == 3
        i_dc = [0, i_ph(2), -i_ph(1),0,  -i_ph(1), i_ph(2),   0,    0];
    elseif R == 4
        i_dc = [0, -i_ph(1), i_ph(3),0,  i_ph(3), -i_ph(1),   0,    0];
    elseif R == 5
        i_dc = [0, i_ph(3), -i_ph(2),0,  -i_ph(2), i_ph(3),   0,    0];
    else
        i_dc = [0, -i_ph(2), i_ph(1),0,  i_ph(1), -i_ph(2),   0,    0];
    end
elseif(setup.SEQ == 721) %721
    if R == 1
        i_dc = [0, -i_ph(3), i_ph(1),0,  i_ph(1), -i_ph(3),   0,    0];
    elseif R == 2
        i_dc = [0, i_ph(2), -i_ph(3),0,  -i_ph(3), i_ph(2),   0,    0];
    elseif R == 3
        i_dc = [0, -i_ph(1), i_ph(2),0,  i_ph(2), -i_ph(1),   0,    0];
    elseif R == 4
        i_dc = [0, i_ph(3), -i_ph(1),0,  -i_ph(1), i_ph(3),   0,    0];
    elseif R == 5
        i_dc = [0, -i_ph(2), i_ph(3),0,  i_ph(3), -i_ph(2),   0,    0];
    else
        i_dc = [0, i_ph(1), -i_ph(2),0,  -i_ph(2), i_ph(1),   0,    0];
    end
elseif(setup.SEQ == 121) %0121
    if R == 1
        i_dc = [0, i_ph(1), -i_ph(3), i_ph(1),  -i_ph(3), i_ph(1),   0,    0];
    elseif R == 2
        i_dc = [0, -i_ph(3), i_ph(2), -i_ph(3),  i_ph(2), -i_ph(3),   0,    0];
    elseif R == 3
        i_dc = [0, i_ph(2), -i_ph(1), i_ph(2),  -i_ph(1), i_ph(2),   0,    0];
    elseif R == 4
        i_dc = [0, -i_ph(1), i_ph(3), -i_ph(1),  i_ph(3), -i_ph(1),   0,    0];
    elseif R == 5
        i_dc = [0, i_ph(3), -i_ph(2), i_ph(3),  -i_ph(2), i_ph(3),   0,    0];
    else
        i_dc = [0, -i_ph(2), i_ph(1), -i_ph(2),  i_ph(1), -i_ph(2),   0,    0];
    end
elseif(setup.SEQ == 7212) %7212
    if R == 1
        i_dc = [0, -i_ph(3), i_ph(1), -i_ph(3),  i_ph(1), -i_ph(3),   0,    0];
    elseif R == 2
        i_dc = [0, i_ph(2), -i_ph(3), i_ph(2),  -i_ph(3), i_ph(2),   0,    0];
    elseif R == 3
        i_dc = [0, -i_ph(1), i_ph(2), -i_ph(1),  i_ph(2), -i_ph(1),   0,    0];
    elseif R == 4
        i_dc = [0, i_ph(3), -i_ph(1), i_ph(3),  -i_ph(1), i_ph(3),   0,    0];
    elseif R == 5
        i_dc = [0, -i_ph(2), i_ph(3), -i_ph(2),  i_ph(3), -i_ph(2),   0,    0];
    else
        i_dc = [0, i_ph(1), -i_ph(2), i_ph(1),  -i_ph(2), i_ph(1),   0,    0];
    end
elseif(setup.SEQ == 1012) %1012
    if R == 1
        i_dc = [i_ph(1), 0, i_ph(1), -i_ph(3), i_ph(1), 0, i_ph(1),  0];
    elseif R == 2
        i_dc = [-i_ph(3), 0, -i_ph(3), i_ph(2), -i_ph(3), 0, -i_ph(3),   0];
    elseif R == 3
        i_dc = [i_ph(2), 0, i_ph(2), -i_ph(1), i_ph(2), 0, i_ph(2),   0];
    elseif R == 4
        i_dc = [-i_ph(1), 0, -i_ph(1), i_ph(3), -i_ph(1),  0, -i_ph(1),   0];
    elseif R == 5
        i_dc = [i_ph(3), 0, i_ph(3), -i_ph(2), i_ph(3), 0, i_ph(3),   0];
    else
        i_dc = [-i_ph(2), 0, -i_ph(2), i_ph(1), -i_ph(2), 0, -i_ph(2),   0];
    end
elseif(setup.SEQ == 2721) %2721
    if R == 1
        i_dc = [-i_ph(3), 0, -i_ph(3), i_ph(1), -i_ph(3), 0, -i_ph(3),   0];
    elseif R == 2
        i_dc = [i_ph(2), 0, i_ph(2), -i_ph(3), i_ph(2), 0, i_ph(2),   0];
    elseif R == 3
        i_dc = [-i_ph(1), 0, -i_ph(1), i_ph(2), -i_ph(1), 0, -i_ph(1),   0];
    elseif R == 4
        i_dc = [i_ph(3), 0, i_ph(3), -i_ph(1), i_ph(3), 0, i_ph(3),   0];
    elseif R == 5
        i_dc = [-i_ph(2), 0, -i_ph(2), i_ph(3), -i_ph(2), 0, -i_ph(2),   0];
    else
        i_dc = [i_ph(1), 0, i_ph(1), -i_ph(2), i_ph(1), 0, i_ph(1),   0];
    end
end
end

