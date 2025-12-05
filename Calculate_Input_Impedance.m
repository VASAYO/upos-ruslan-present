function Zin = Calculate_Input_Impedance(Y, Zload, mode)
% Функция выполняет расчёт входного импеданса биполярного транзистора 
% (или другого активного элемента), работающего в режиме малого сигнала
%
% Входные аргументы:
%   Y     - Матрица 2x2 малосигнальных Y-параметров транзистора в рабочей 
%           точке при включении в схеме с общим эмиттером;
%   Zload - Импеданс нагрузки транзистора. Значение по умолчанию: +inf;
%   mode  - Режим включения транзистора в усилитель как трехполюсника:
%            'Common emitter' (default) || 
%            'Common collector'         || 
%            'Common base'
%
% Выходные параметры:
%   Zin - Входной импеданс транзистора.

% Валидация аргументов
    arguments
        Y       (2,2) double
        Zload   (1,1) double = +inf;
        mode    char {mustBeMember(mode,{'Common emitter', ...
                                         'Common collector', ...
                                         'Common base'})} ...
                                         = 'Common emitter';
    end
    narginchk(1, 3);

% Определение Y-параметров транзистора при заданной схеме включения
    switch mode
        case 'Common emitter'
            Ynew = Y;

        case {'Common collector', 'Common base'}
            % Построение матрицы неопределённых проводимостей
                Y3 = zeros(3);
                Y3(1:2,1:2) = Y;
                Y3(1:2, 3) = -( Y3(1:2, 1) + Y3(1:2, 2) );
                Y3(3, 1:2) = -( Y3(1, 1:2) + Y3(2, 1:2) );
                Y3(3,   3) = sum(Y3(1:2, 1:2), "all");

            % Получение на основе построенной матрицы системы Y-параметров
            % транзистора в нужной схеме включения
                if strcmp(mode, 'Common collector')
                    Ynew = Y3([1 3], [1 3]);

                elseif strcmp(mode, 'Common base')
                    Ynew = Y3([2 3], [2 3]);
                    Ynew = rot90(rot90(Ynew));
                end
    end

% Вычисление входного импеданса
    Zin = 1 / ( Ynew(1,1) - Ynew(1,2)*Ynew(2,1)/( Ynew(2,2) + 1/Zload ) );
