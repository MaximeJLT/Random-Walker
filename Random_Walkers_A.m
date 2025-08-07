clear all; close all; clc;

N = 3000; % Nombre de simulations
X_1 = 0;
Y_1 = 0;
T = 3000; % Nombre de pas
deltaX = 1;
deltaY = 1;
N_S = 4; % Nombre de simulations pour l'affichage final
d = 2; % Dimension du problème

X = zeros(T, N);
Y = zeros(T, N); % Matrices allant de t=1 à t=T

directions = randi(4, T, N); % Même probabilité d'aller dans 4 directions

% Créer une figure pour l'affichage des trajectoires
figure;
hold on;

% Tracer l'origine
plot(0, 0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Origine
xlabel('X'); ylabel('Y');
title('Marche Aléatoire 2D');
grid on; axis equal;

% Initialisation de la couleur pour chaque marcheur
colors = rand(N, 3); % Générer une couleur aléatoire pour chaque marcheur

% Calcul des trajectoires pour chaque marcheur
for t = 2:T   % On utilise 2 car t=1 est déjà utilisé pour 0,0
    X(t, :) = X(t-1, :);
    Y(t, :) = Y(t-1, :); % On initialise à la position précédente
    
    % Mise à jour de la position selon la direction
    X(t, directions(t, :) == 1) = X(t, directions(t, :) == 1) + deltaX;
    X(t, directions(t, :) == 2) = X(t, directions(t, :) == 2) - deltaX;
    Y(t, directions(t, :) == 3) = Y(t, directions(t, :) == 3) + deltaY;
    Y(t, directions(t, :) == 4) = Y(t, directions(t, :) == 4) - deltaY; % On va selon 4 directions possibles
end

% Affichage final des trajectoires
for i = 1:N_S
    plot(X(:, i), Y(:, i), 'LineWidth', 1, 'Color', colors(i, :));
    plot(X(end, i), Y(end, i), 'o', 'MarkerFaceColor', colors(i, :), 'MarkerEdgeColor', colors(i, :), 'MarkerSize', 8);
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
