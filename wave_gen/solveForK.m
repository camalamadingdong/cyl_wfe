function [k] = solveForK(omega, h)
    % k = SolveForK(omega, h)
    % solves for the wavenumber as a function of radial wave frequency (omega)
    % and depth (h).

    g = 9.806650;

    if (h <= 0)
        error('The depth must be greater than 0');
    elseif (h == Inf)
        k = omega.^2/g;
    else
        tol = 1e-8;
        k = omega.^2/g;
        const = h.*k;

        k0h = k.*h;
        tanhk0h = tanh(k0h);
        f0 = const - k0h.*tanhk0h;

        i = 0;

        while (any(f0 > tol))
            i = i+1;
            k0h = k.*h;
            tanhk0h = tanh(k0h);
            f0 = const - k0h.*tanhk0h;
            m = k0h.*tanhk0h.^2 - tanhk0h - k0h;
            kh = k0h - f0./m;
            k = kh./h;
        end
    end
end