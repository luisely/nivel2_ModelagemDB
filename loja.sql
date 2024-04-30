
CREATE SEQUENCE pessoa_id_seq 
    START WITH 1  
    INCREMENT BY 1;

CREATE TABLE Usuario (
  idUsuario INT PRIMARY KEY IDENTITY NOT NULL,
  login VARCHAR(50),
  senha VARCHAR(255)
);

CREATE TABLE Produto (
  idProduto INT PRIMARY KEY IDENTITY NOT NULL,
  nome VARCHAR(255),
  quantidade INTEGER,
  precoVenda DECIMAL(10,2)
);

CREATE TABLE Pessoa (
  idPessoa INT PRIMARY KEY DEFAULT NEXT VALUE FOR pessoa_id_seq NOT NULL,
  nome VARCHAR(255),
  logradouro VARCHAR(255),
  cidade VARCHAR(255),
  estado VARCHAR(2),
  telefone VARCHAR(11),
  email VARCHAR(255)
);

CREATE TABLE PessoaFisica (
    ID INT PRIMARY KEY NOT NULL,
    CPF VARCHAR(14),
    FOREIGN KEY (ID) REFERENCES Pessoa(idPessoa)
);

CREATE TABLE PessoaJuridica (
    ID INT PRIMARY KEY NOT NULL,
    CNPJ VARCHAR(18),
    FOREIGN KEY (ID) REFERENCES Pessoa(idPessoa)
);

CREATE TABLE Movimento (
  idMovimento INT PRIMARY KEY IDENTITY NOT NULL,
  Produto_idProduto INTEGER  NOT NULL,
  Pessoa_idPessoa INTEGER  NOT NULL,
  usuario_idUsuario INTEGER,
  quantidade INTEGER,
  tipo CHAR(1),
  valorUnitario DECIMAL(10,2),
  FOREIGN KEY(Pessoa_idPessoa) REFERENCES Pessoa(idPessoa),
  FOREIGN KEY(Produto_idProduto) REFERENCES Produto(idProduto),
  FOREIGN KEY(Usuario_idUsuario) REFERENCES Usuario(idUsuario)
);

-- INSERTS
INSERT INTO Usuario(login, senha) VALUES ('op1', 'op1');
INSERT INTO Usuario(login, senha) VALUES ('op2', 'op2');
INSERT INTO Usuario(login, senha) VALUES ('op3', 'op3');

DECLARE @next_pessoa_id INT;
SET @next_pessoa_id = NEXT VALUE FOR pessoa_id_seq;

INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@next_pessoa_id, 'Info LTDA', 'Rua Joca, 108', 'Porto Alegre', 'RS', '51980234080', 'email1@gmail.com');
INSERT INTO PessoaJuridica(ID, CNPJ) VALUES (@next_pessoa_id, '61045948000158');

DECLARE @next_pessoa_id2 INT;
SET @next_pessoa_id2 = NEXT VALUE FOR pessoa_id_seq;

INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@next_pessoa_id2, 'Fernando', 'Rua Legal, 908', 'Porto Alegre', 'RS', '51980808080', 'email2@gmail.com');
INSERT INTO PessoaFisica(ID, CPF) VALUES (@next_pessoa_id2, '34529054324');

DECLARE @next_pessoa_id3 INT;
SET @next_pessoa_id3 = NEXT VALUE FOR pessoa_id_seq;

INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@next_pessoa_id3, 'Carlos', 'Rua Osvaldo Cruz, 908', 'Alegrete', 'RS', '51910101010', 'email3@gmail.com');
INSERT INTO PessoaFisica(ID, CPF) VALUES (@next_pessoa_id3, '24549064321')

DECLARE @next_pessoa_id4 INT;
SET @next_pessoa_id4 = NEXT VALUE FOR pessoa_id_seq;

INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@next_pessoa_id4, 'Giz Comp.', 'Rua Giz, 108', 'Garopaba', 'SC', '51980303030', 'email4@gmail.com');
INSERT INTO PessoaJuridica(ID, CNPJ) VALUES (@next_pessoa_id4, '31045948000123')

INSERT INTO Produto(nome, quantidade, precoVenda) VALUES ('Processador Intel i7-13700', 10 , 2300);
INSERT INTO Produto(nome, quantidade, precoVenda) VALUES ('Plca Mãe Z790', 12 , 1650);
INSERT INTO Produto(nome, quantidade, precoVenda) VALUES ('Memoria 16GB DDR5', 33 , 500);
INSERT INTO Produto(nome, quantidade, precoVenda) VALUES ('Placa de Video RTX 4070', 22 , 3900);
INSERT INTO Produto(nome, quantidade, precoVenda) VALUES ('Fonte Corsair 1000W Full Modular', 13 , 1900);
INSERT INTO Produto(nome, quantidade, precoVenda) VALUES ('Water Cooler', 23 , 700.99);
INSERT INTO Produto(nome, quantidade, precoVenda) VALUES ('SSD Corsair NVMe 1TB', 30 , 1500.90);

INSERT INTO Movimento(Produto_idProduto, Pessoa_idPessoa, usuario_idUsuario, quantidade, tipo, valorUnitario) 
VALUES (3, 4, 1, 3, 'E', 500.90);
INSERT INTO Movimento(Produto_idProduto, Pessoa_idPessoa, usuario_idUsuario, quantidade, tipo, valorUnitario) 
VALUES (1, 4, 2, 5, 'E', 2300);
INSERT INTO Movimento(Produto_idProduto, Pessoa_idPessoa, usuario_idUsuario, quantidade, tipo, valorUnitario) 
VALUES (2, 1, 1, 5, 'E', 1650);
INSERT INTO Movimento(Produto_idProduto, Pessoa_idPessoa, usuario_idUsuario, quantidade, tipo, valorUnitario) 
VALUES (4, 2, 2, 1, 'S', 3900);
INSERT INTO Movimento(Produto_idProduto, Pessoa_idPessoa, usuario_idUsuario, quantidade, tipo, valorUnitario) 
VALUES (1, 2, 1, 1, 'S', 2300);
INSERT INTO Movimento(Produto_idProduto, Pessoa_idPessoa, usuario_idUsuario, quantidade, tipo, valorUnitario) 
VALUES (7, 3, 1, 3, 'S', 1500);
INSERT INTO Movimento(Produto_idProduto, Pessoa_idPessoa, usuario_idUsuario, quantidade, tipo, valorUnitario) 
VALUES (3, 3, 1, 2, 'S', 500);

-- a) Dados completos de pessoas físicas.
SELECT 
    p.idPessoa,
    p.nome,
    p.cidade,
	p.estado,
	p.logradouro,
    p.telefone,
    pf.CPF
FROM 
    Pessoa p
JOIN 
    PessoaFisica pf ON p.idPessoa = pf.ID;

-- b) Dados completos de pessoas jurídicas.

SELECT 
    p.idPessoa,
    p.nome,
    p.cidade,
	p.estado,
	p.logradouro,
    p.telefone,
    pj.CNPJ
FROM 
    Pessoa p
JOIN 
    PessoaJuridica pj ON p.idPessoa = pj.ID;

-- c) Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total.

SELECT m.idMovimento, Prod.nome, Pj.CNPJ AS FORNECEDOR, m.quantidade, m.valorUnitario, (m.quantidade * m.valorUnitario) AS Valor_Total
FROM Movimento m 
JOIN Produto Prod ON m.Produto_idProduto = Prod.idProduto
JOIN PessoaJuridica Pj ON M.Pessoa_idPessoa = Pj.ID
WHERE m.tipo = 'E'


-- d) Movimentações de saida, com produto, comprador, quantidade, preço unitário e valor total.
SELECT 
	m.idMovimento AS ID, 
	Prod.nome AS PROD_NAME, 
	Pf.CPF AS COMPRADOR,
	m.quantidade AS QUANTITY,
	m.valorUnitario AS PRICE_UNIT, 
	(m.quantidade * m.valorUnitario) AS TOTAL_PRICE
FROM Movimento m 
JOIN Produto Prod ON m.Produto_idProduto = Prod.idProduto
JOIN PessoaFisica Pf ON M.Pessoa_idPessoa = Pf.ID
WHERE m.tipo = 'S'

-- e) Valor total das entradas agrupadas por produto.

SELECT Prod.nome AS PRODUTO, SUM(m.quantidade * m.valorUnitario) AS TOTAL_ENTRADAS 
FROM Movimento m
JOIN Produto Prod ON m.Produto_idProduto = Prod.idProduto
JOIn PessoaJuridica Pj ON m.Pessoa_idPessoa = Pj.ID
WHERE m.tipo = 'E'
GROUP BY Prod.nome


-- f) Valor total das saidas agrupadas por produto.

SELECT Prod.nome AS PRODUCT, SUM(m.quantidade * m.valorUnitario) AS TOTAL_SELLS
FROM Movimento m
JOIN Produto Prod ON m.Produto_idProduto = Prod.idProduto
JOIn PessoaFisica Pf ON m.Pessoa_idPessoa = Pf.ID
WHERE m.tipo = 'S'
GROUP BY Prod.nome

-- g) Operadores que não efetuaram movimentações de entrada (compra).

SELECT idUsuario, login 
FROM Usuario
WHERE idUsuario NOT IN (
	SELECT DISTINCT
		usuario_idUsuario
	FROM Movimento
	WHERE tipo = 'E'
);

-- h) Valor total de entrada, agrupado por operador.

SELECT u.idUsuario, u.login, COALESCE(NULLIF(SUM(m.quantidade * m.valorUnitario),0),0) AS TOTAL_ENTRADA FROM Usuario u 
LEFT JOIN Movimento m ON u.idUsuario = m.usuario_idUsuario AND m.tipo = 'E' 
GROUP BY u.idUsuario, u.login


-- i) Valor total de saida, agrupado por operador.

SELECT u.idUsuario, u.login, COALESCE(NULLIF(SUM(m.quantidade * m.valorUnitario),0),0) AS TOTAL_SAIDA FROM Usuario u 
LEFT JOIN Movimento m ON u.idUsuario = m.usuario_idUsuario AND m.tipo = 'S' 
GROUP BY u.idUsuario, u.login

-- j) Valor médio de venda por produto, utilizando média ponderada.

SELECT Prod.idProduto, Prod.nome, SUM(m.quantidade * m.valorUnitario) / SUM(m.quantidade) AS VALOR_MEDIA FROM Produto Prod
JOIN Movimento m ON Prod.idProduto = m.Produto_idProduto AND m.tipo = 'S'
GROUP BY Prod.idProduto, Prod.nome