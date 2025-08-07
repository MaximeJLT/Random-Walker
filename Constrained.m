clear all; close all; clc;

N = 5000; % Nombre de simulations
T = 2500; % Nombre de pas
deltaX = 1;
deltaY = 1;
N_S = 3;
d = 2;

X = zeros(T, N);
Y = zeros(T, N); % Matrices allant de t=1 à t=T

% Génération des directions initiales
directions = randi(4, T, N); 

% Tracer l'origine
figure;
hold on;
plot(0, 0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Origine
xlabel('X'); ylabel('Y');
title('Marche Aléatoire 2D sans répétition immédiate');
grid on; axis equal;

colors = rand(N, 3);

for t = 2:T  
    X(t, :) = X(t-1, :);
    Y(t, :) = Y(t-1, :);

     for n = 1:N
        if directions(t, n) == 1 && directions(t-1, n) == 1
            directions(t, n) = 2; % Changer pour la direction opposée
            X(t, n) = X(t, n) - deltaX; % Corriger la position
        elseif directions(t, n) == 2 && directions(t-1, n) == 2
            directions(t, n) = 1;
            X(t, n) = X(t, n) + deltaX;
        elseif directions(t, n) == 3 && directions(t-1, n) == 3
            directions(t, n) = 4;
            Y(t, n) = Y(t, n) - deltaY;
        elseif directions(t, n) == 4 && directions(t-1, n) == 4
            directions(t, n) = 3;
            Y(t, n) = Y(t, n) + deltaY;
        end
     end
    
    % Mise à jour de la position selon la direction
    X(t, directions(t, :) == 1) = X(t, directions(t, :) == 1) + deltaX;
    X(t, directions(t, :) == 2) = X(t, directions(t, :) == 2) - deltaX;
    Y(t, directions(t, :) == 3) = Y(t, directions(t, :) == 3) + deltaY;
    Y(t, directions(t, :) == 4) = Y(t, directions(t, :) == 4) - deltaY;
end

for n = 1:N
    for t = 3:T  % On commence à t=3 pour comparer t, t-1 et t-2
        if (X(t, n) - X(t-1, n)) == (X(t-1, n) - X(t-2, n)) && ...
           (Y(t, n) - Y(t-1, n)) == (Y(t-1, n) - Y(t-2, n))
            error('Le marcheur a fait deux pas consécutifs dans la même direction.');
        end
    end
end

% Affichage final des trajectoires
for i = 1:N_S
    plot(X(:, i), Y(:, i), 'LineWidth', 1, 'Color', colors(i, :));
    plot(X(end, i), Y(end, i), 'o', 'MarkerFaceColor', colors(i, :),...
        'MarkerEdgeColor', colors(i, :), 'MarkerSize', 8);
end

% Distribution de D(T)
D = sqrt(X(T, :).^2 + Y(T, :).^2);

[H, edges] = histcounts(D, [1:100]);
figure(2);
bar(edges(1:end-1), H);
xlabel('Distance parcourue par le marcheur apres un temps T');
ylabel('Probabilité');

T_values = 500:2500; % Plage de T à analyser
MDS = zeros(length(T_values), 1); % Vecteur pour stocker le MDS pour chaque T

% Calcul du MDS pour chaque valeur de T
for i = 1:length(T_values)
    t = T_values(i);
    % Calcul du déplacement quadratique moyen (MDS) à l'instant t
    MDS(i) = mean((sqrt(X(t, :).^2 + Y(t, :).^2)).^2);
end

% Tracé du déplacement quadratique moyen en fonction de T
figure;
plot(T_values, MDS, 'LineWidth', 2);
xlabel('Nombre de pas (T)');
ylabel('Déplacement quadratique moyen (MDS)');
title('Déplacement quadratique moyen');

p = polyfit(T_values, MDS, 1);
pente = p(1);

r = corrcoef(T_values, MDS);
R_carre = r(1,2)^2;

Diff = pente / (2 * d); %On trouve un quart car le diff est relier a la probabilitee que le la particule se deplace, et se deplacement est un quart
