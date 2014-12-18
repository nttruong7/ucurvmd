% create 2-D grid function-------------------------------------------------
function  Mang = angle_fun(Mgrid, dir, n, alpha)

% angle meyer window
angd = 2/n;
ang = angd*[-alpha alpha 1-alpha 1+alpha];

switch dir
    case 1
        for in = 1:ceil(n/2)
            ang2 = -1+(in-1)*angd+ang;
            fang =  fun_meyer(Mgrid,ang2);
            tmp =  fang ;
            Mang{in} = tmp;
        end

    case 2
        for in = 1:ceil(n/2)
            ang2 = -1+(in-1)*angd+ang;
            fang =  fun_meyer(Mgrid,ang2);
            tmp = fang;
            Mang{in} = tmp;
        end

    otherwise
        disp('Error, unrecognized direction')
end


