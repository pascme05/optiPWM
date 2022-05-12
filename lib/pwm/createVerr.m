function [y0_al,y0_be,y1_al,y1_be,y2_al,y2_be,y3_al,y3_be] = createVerr(s0_al,s0_be,s1_al,s1_be,s2_al,s2_be,s3_al,s3_be,d0,d1,d2)  
    % d7
    y0_al = 0;
    y0_be = 0;
    % d2
    y1_al = s0_al*d0 + y0_al - s1_al*d0;
    y1_be = s0_be*d0 + y0_be - s1_be*d0;
    % d1
    y2_al = s1_al*(d0+d1) + y1_al - s2_al*(d0+d1);
    y2_be = s1_be*(d0+d1) + y1_be - s2_be*(d0+d1);
    % d0
    y3_al = s2_al*(d0+d1+d2) + y2_al - s3_al*(d0+d1+d2);
    y3_be = s2_be*(d0+d1+d2) + y2_be - s3_be*(d0+d1+d2);
end

