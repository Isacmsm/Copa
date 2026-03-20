INSERT INTO Ism_Time (Nome)
VALUES 
('Brasil'), 
('Croácia'),
('Austrália'),
('Japão');

INSERT INTO Ism_Jogador (Nome, idTime)
VALUES
('Kaka', 1),
('Nakamura', 4),
('Adriano', 1),
('Kovak', 2),
('John', 3),
('Wayne', 3);


INSERT INTO Ism_Jogo (idTime1, idTime2, Placar1, Placar2)
VALUES
(1, 2, 1, 0),
(3, 4, 3, 1),
(2, 4, 1, 1),
(1, 3, 1, 1),
(4, 1, 1, 3);

INSERT INTO Ism_Participacao (idJogo, idJogador, GolsMarcados)
VALUES
(1, 1, 1),
(2, 5, 2),
(2, 6, 1),
(2, 2, 1),
(3, 4, 1),
(3, 2, 1),
(4, 3, 1);


SELECT * FROM Ism_Time
SELECT * FROM Ism_Jogador
SELECT * FROM Ism_Jogo
SELECT * FROM Ism_Participacao