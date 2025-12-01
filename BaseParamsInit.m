function Output = BaseParamsInit()
% Инициализация базовых параметров и исходных данных

% Сигнал
    Output.E = 1.5;
    Output.Fc = 180e6;
    Output.Fmod = 50e3;
    Output.m = 6;

% Полоса сигнала
    Output.SigBW = 2*Output.Fmod*(1+Output.m+sqrt(Output.m));

% Круговая частота несущей
    Output.Wc = 2*pi*Output.Fc;
end