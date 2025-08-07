clear all; close all; clc;

N = 1; % Nombre de simulations
X_1 = 0;
Y_1 = 0;
T = 100000; % Nombre de pas
deltaX = 1;
deltaY = 1;
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
for i = 1:N
    plot(X(:, i), Y(:, i), 'LineWidth', 1, 'Color', colors(i, :));
    plot(X(end, i), Y(end, i), 'o', 'MarkerFaceColor', colors(i, :), 'MarkerEdgeColor', colors(i, :), 'MarkerSize', 8);
end

X_d = X(:, N); % Coordonnées X
Y_d = Y(:, N); % Coordonnées Y

% Initialisation du vecteur de MQS (Moyenne Quadratique des déplacements)
MQS = zeros(T-1, 1);

% Calcul de la MQS pour chaque valeur de tau
for tau = 1:T-1  % Tau varie de 1 à T-1
    % Calcul des déplacements pour chaque valeur de tau
    sum_MQS = 0;
    for t = 1:(T-tau)  % On commence à t=1 et on fait des pas de tau jusqu a T-tau
        % Calcul des différences au carré
        sum_MQS = sum_MQS + (X_d(t + tau) - X_d(t))^2 + (Y_d(t + tau) - Y_d(t))^2;
    end
    MQS(tau) = sum_MQS/(T-tau); %moyenne
end


% Tracé de la MQS en fonction de tau
figure;
plot(1:T-1, MQS, 'LineWidth', 2);
xlabel('Tau');
ylabel('Moyenne Quadratique des Déplacements (MQS)');
title('Moyenne Quadratique des Déplacements en fonction de Tau');

tau_interest = round(linspace(1, min(1000, T-1), 100)); 

% Filtrer les valeurs de tau et MQS
MQS_filtered = MQS(tau_interest);

% Ajustement linéaire
p = polyfit(tau_interest, MQS_filtered, 1);
pente = p(1);

r = corrcoef(tau_interest, MQS_filtered);
R_carre = r(1,2)^2;

% Calcul du coefficient de diffusion
Diff = pente / (2 * d);

% Tracé du MDS filtré
figure;
plot(tau_interest, MQS_filtered, 'o', 'MarkerFaceColor', 'b'); 
hold on;
plot(tau_interest, polyval(p, tau_interest), 'r-', 'LineWidth', 2); 
xlabel('Tau');
ylabel('MQS filtrée');
title('Moyenne Quadratique des Déplacements filtrée');
legend('Données filtrées', 'Ajustement linéaire');
hold off;
Fait 

