-- ==========================================================
-- 1. POVOAMENTO DE TABELAS INDEPENDENTES (Sem Chaves Estrangeiras)
-- ==========================================================

-- Inserindo Membros
INSERT INTO Membro (nome, cpf, data_nascimento, telefone, email, data_ingresso, situacao) VALUES 
('João Silva', '123.456.789-00', '1985-05-10', '1199999-1111', 'joao@email.com', '2020-01-15', 'Ativo'),
('Maria Oliveira', '234.567.890-11', '1990-08-20', '1198888-2222', 'maria@email.com', '2021-03-10', 'Ativo'),
('Pedro Souza', '345.678.901-22', '1978-12-05', '1197777-3333', 'pedro@email.com', '2019-11-05', 'Inativo');

-- Inserindo Ministérios
INSERT INTO Ministerio (nome, descricao) VALUES 
('Louvor', 'Equipe responsável pela música e adoração nos cultos'),
('Infantil', 'Ensino bíblico para crianças de 2 a 10 anos'),
('Recepção', 'Acolhimento de membros e visitantes na entrada'),
('Mídia', 'Responsável pela projeção e transmissão dos cultos');

-- Inserindo Pregadores
INSERT INTO Pregador (nome, origem) VALUES 
('Pr. Antônio Carlos', 'Local'),
('Miss. Ana Clara', 'Convidado');

-- Inserindo Sermões
INSERT INTO Sermao (titulo, referencia_biblica, descricao) VALUES 
('O Poder da Fé', 'Hebreus 11:1', 'Sermão sobre a importância da fé em tempos difíceis'),
('Vivendo em Comunidade', 'Atos 2:42', 'Estudo sobre a igreja primitiva e comunhão');

-- Inserindo Locais
INSERT INTO Local (nome, capacidade) VALUES 
('Templo Principal', 300),
('Salão Social', 100),
('Sala 101 - Kids', 30);

-- ==========================================================
-- 2. POVOAMENTO DE TABELAS DEPENDENTES (Com Chaves Estrangeiras)
-- ==========================================================

-- Inserindo Cultos (Depende de: Local, Sermão, Pregador)
-- OBS: Assumindo que os IDs gerados acima foram 1 e 2
INSERT INTO Culto (data, horario, numero_visitantes, id_local, id_sermao, id_pregador) VALUES 
('2023-10-01', '19:00:00', 15, 1, 1, 1), -- Culto no Templo com Pr. Antônio
('2023-10-08', '19:00:00', 8, 1, 2, 2);  -- Culto no Templo com Miss. Ana

-- Inserindo Ofertas (Depende de: Culto)
INSERT INTO Oferta (valor, tipo, id_culto) VALUES 
(150.50, 'Oferta Corrente', 1),
(500.00, 'Dízimo', 1),
(200.00, 'Oferta Missionária', 2);

-- Inserindo Visitantes (Depende de: Culto)
INSERT INTO Visitante (nome, cidade, telefone_opcional, id_culto) VALUES 
('Carlos Pereira', 'São Paulo', '1191234-5678', 1),
('Fernanda Lima', 'Osasco', NULL, 1);

-- Inserindo Eventos (Depende de: Local)
INSERT INTO Evento (nome, data, descricao, id_local) VALUES 
('Café de Comunhão', '2023-11-15', 'Café da manhã para integração dos novos membros', 2);

-- Inserindo Atendimento Pastoral (Depende de: Membro)
INSERT INTO Atendimento_Pastoral (data, tema, observacoes, id_membro) VALUES 
('2023-10-05', 'Aconselhamento Familiar', 'Membro solicitou oração pela família', 1);

-- ==========================================================
-- 3. POVOAMENTO DE TABELAS ASSOCIATIVAS (N:N)
-- ==========================================================

-- Associando Membros a Ministérios (Quem participa de quê)
INSERT INTO Participacao_Ministerio (id_membro, id_ministerio, funcao, data_inicio) VALUES 
(1, 1, 'Guitarrista', '2020-02-01'), -- João no Louvor
(2, 2, 'Professora', '2021-04-01'), -- Maria no Infantil
(2, 3, 'Voluntária', '2022-01-10'); -- Maria na Recepção (Dupla participação)

-- Criando uma Escala (Quem serve quando)
INSERT INTO Escala (data, funcao, id_ministerio, id_membro) VALUES 
('2023-10-01', 'Tocar Guitarra', 1, 1),
('2023-10-01', 'Recepcionar', 3, 2);

-- 1. Consulta Simples: Listar todos os membros ativos ordenados por nome
SELECT nome, email, telefone 
FROM Membro 
WHERE situacao = 'Ativo' 
ORDER BY nome ASC;

-- 2. Consulta com JOIN (Relacionamento): Detalhes do Culto
-- Mostra data, horário, nome do pregador e título do sermão
SELECT 
    c.data AS Data_Culto, 
    c.horario, 
    p.nome AS Pregador, 
    s.titulo AS Sermao,
    l.nome AS Local
FROM Culto c
INNER JOIN Pregador p ON c.id_pregador = p.id_pregador
INNER JOIN Sermao s ON c.id_sermao = s.id_sermao
INNER JOIN Local l ON c.id_local = l.id_local;

-- 3. Consulta de Agregação (Soma): Total de ofertas por Culto
SELECT 
    c.data AS Data_Culto, 
    SUM(o.valor) AS Total_Arrecadado
FROM Oferta o
JOIN Culto c ON o.id_culto = c.id_culto
GROUP BY c.id_culto;

-- 4. Consulta Complexa (Associativa): Quem participa de qual ministério?
SELECT 
    m.nome AS Nome_Membro, 
    min.nome AS Ministerio, 
    pm.funcao AS Funcao_Exercida
FROM Membro m
JOIN Participacao_Ministerio pm ON m.id_membro = pm.id_membro
JOIN Ministerio min ON pm.id_ministerio = min.id_ministerio;

-- 5. Consulta com LIMIT: Os 3 eventos mais recentes/próximos
SELECT nome, data, descricao 
FROM Evento 
ORDER BY data DESC 
LIMIT 3;

-- 1. Atualizar o telefone e email de um membro específico
UPDATE Membro 
SET telefone = '1199999-8888', email = 'joao.silva.novo@email.com' 
WHERE id_membro = 1;

-- 2. Alterar a capacidade de um local (Ex: Reforma no salão)
UPDATE Local 
SET capacidade = 150 
WHERE nome = 'Salão Social';

-- 3. Corrigir o horário de um culto específico
UPDATE Culto 
SET horario = '19:30:00' 
WHERE id_culto = 1;
