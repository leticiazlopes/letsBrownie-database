CREATE DATABASE letsbrownie;

USE letsbrownie;

CREATE TABLE cliente(
	cpf_cliente CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    bairro VARCHAR(45) NOT NULL,
    rua VARCHAR(45) NOT NULL,
    numero VARCHAR(45) NOT NULL,
    cidade VARCHAR(45) NOT NULL,
    data_de_nascimento DATE NOT NULL,
    sexo CHAR(1) NULL,
	CONSTRAINT PK_cliente PRIMARY KEY (cpf_cliente)
);

-- Adicionando checagem que não colocamos na definição da tabela :)
ALTER TABLE cliente
ADD CONSTRAINT CK_sexo CHECK(sexo IN ('M', 'F'));

CREATE TABLE doces(
	codigo INT NOT NULL,
    validade DATE NOT NULL,
    descricao VARCHAR(45) NOT NULL,
    fabricacao VARCHAR(45) NOT NULL,
    preco FLOAT NOT NULL,
    CONSTRAINT PK_doces PRIMARY KEY (codigo)
);

CREATE TABLE funcionario(
	cpf_funcionario CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    funcionariocol VARCHAR(45) NOT NULL,
    escolaridade VARCHAR(45) NOT NULL,
    endereco VARCHAR(45) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    funcao VARCHAR(45) NOT NULL,
    funcionario_cpf_funcionario CHAR(11), # autorelacionamento
    confeiteiro BOOL NULL,
    CONSTRAINT PK_funcionario PRIMARY KEY (cpf_funcionario),
    CONSTRAINT FK_FUNCIONARIO_gerencia_funcionario FOREIGN KEY (funcionario_cpf_funcionario) REFERENCES funcionario(cpf_funcionario)
);

CREATE TABLE experiencia(
	experiencia VARCHAR(150) NOT NULL,
    funcionario_cpf_funcionario CHAR(11) NOT NULL,
    CONSTRAINT PK_experiencia PRIMARY KEY (experiencia, funcionario_cpf_funcionario),
	CONSTRAINT FK_EXPERIENCIA_funcionario FOREIGN KEY (funcionario_cpf_funcionario) REFERENCES funcionario(cpf_funcionario)
);

CREATE TABLE pedido(
	data_pedido DATE NOT NULL,
    valor DECIMAL NOT NULL,
    produto VARCHAR(45) NOT NULL,
    entregador VARCHAR(50) NULL,
    horario_entrega DATETIME NULL,
    funcionario_cpf_funcionario CHAR(11) NOT NULL,
    numero_da_entrega INT NULL,
    cliente_cpf_cliente CHAR(11) NOT NULL,
    CONSTRAINT PK_PEDIDO PRIMARY KEY (data_pedido, funcionario_cpf_funcionario, cliente_cpf_cliente),
    CONSTRAINT FK_PEDIDO_funcionario FOREIGN KEY (funcionario_cpf_funcionario) REFERENCES funcionario(cpf_funcionario),
    CONSTRAINT FK_PEDIDO_cliente FOREIGN KEY (cliente_cpf_cliente) REFERENCES cliente(cpf_cliente) 
);

CREATE TABLE inclui(
	quantidade INT NOT NULL,
    PK_doces INT NOT NULL,
    data_pedido DATE NOT NULL,
    pedido_funcionario_cpf_funcionario CHAR(11) NOT NULL,
    pedido_cliente_cpf_cliente CHAR(11) NOT NULL,
    CONSTRAINT PK_inclui PRIMARY KEY (PK_doces, data_pedido, pedido_funcionario_cpf_funcionario, pedido_cliente_cpf_cliente),
    -- Definindo as chaves estrangeiras
    CONSTRAINT FK_inclui_doces FOREIGN KEY (PK_doces) REFERENCES doces(codigo),
    CONSTRAINT FK_inclui_pedido_data FOREIGN KEY (data_pedido, pedido_funcionario_cpf_funcionario, pedido_cliente_cpf_cliente)  REFERENCES pedido(data_pedido, funcionario_cpf_funcionario, cliente_cpf_cliente)
);

CREATE TABLE telefone(
	numero VARCHAR(15) NOT NULL,
    cliente_cpf_cliente CHAR(11) NOT NULL,
    CONSTRAINT PK_telefone PRIMARY KEY (numero, cliente_cpf_cliente),
    CONSTRAINT FK_TELEFONE_cliente FOREIGN KEY (cliente_cpf_cliente) REFERENCES cliente(cpf_cliente)
);

-- SEGUNDA PARTE - DML

-- Usar o banco de dados
USE letsbrownie;

-- Inserir dados na tabela cliente
INSERT INTO cliente (cpf_cliente, nome, bairro, rua, numero, cidade, data_de_nascimento, sexo)
VALUES
('12345678901', 'João Silva', 'Centro', 'Rua A', '123', 'São Paulo', '1990-05-10', 'M'),
('98765432100', 'Maria Oliveira', 'Jardim', 'Rua B', '456', 'Rio de Janeiro', '1985-12-25', 'F'),
('45678912345', 'Ana Souza', 'Bela Vista', 'Rua C', '789', 'Curitiba', '1992-03-15', 'F'),
('32165498700', 'Carlos Pereira', 'Industrial', 'Rua D', '321', 'Belo Horizonte', '1980-07-22', 'M'),
('74185296314', 'Fernanda Lima', 'Vila Nova', 'Rua E', '654', 'Fortaleza', '1995-09-30', 'F'),
('85274196310', 'Lucas Gonçalves', 'São José', 'Rua F', '852', 'Porto Alegre', '1993-04-05', 'M'),
('96385274120', 'Bruna Costa', 'Santa Maria', 'Rua G', '951', 'Salvador', '1988-08-18', 'F'),
('12345897542', 'Josefina da Silva de Aquino', 'Centro', 'Rua B', '131', 'São Paulo', '1967-07-15', 'F'),
('12345897777', 'Pedro Lucas da Silva', 'Pedro Godim', 'Rua Pipipi', '222', 'João Pessoa', '2003-08-30', 'M');


-- Inserir dados na tabela doces
INSERT INTO doces (codigo, validade, descricao, fabricacao, preco)
VALUES
(1, '2024-12-31', 'Brownie de Chocolate', '2024-01-01', 5.00),
(2, '2024-11-30', 'Brownie de Nozes', '2024-02-01', 6.00),
(3, '2024-10-15', 'Brownie de Brigadeiro', '2024-03-10', 7.00),
(4, '2024-09-25', 'Brownie de Limão', '2024-04-05', 5.50),
(5, '2024-08-20', 'Brownie de Doce de Leite', '2024-05-01', 6.50),
(6, '2024-07-31', 'Brownie de Amendoim', '2024-06-10', 5.75),
(7, '2024-06-30', 'Brownie Vegano', '2024-07-01', 7.25);

-- Inserir dados na tabela funcionario
INSERT INTO funcionario (cpf_funcionario, nome, funcionariocol, escolaridade, endereco, telefone, funcao, funcionario_cpf_funcionario, confeiteiro)
VALUES
('12345678911', 'Pedro Silva', 'Gerente', 'Ensino Superior', 'Rua H, 10', '11999999999', 'Gerente', NULL, 0),
('98765432122', 'Joana Souza', 'Assistente', 'Ensino Médio', 'Rua I, 20', '21999999999', 'Assistente', '12345678911', 0),
('45678912333', 'Carlos Santos', 'Confeiteiro', 'Ensino Técnico', 'Rua J, 30', '31999999999', 'Confeiteiro', '12345678911', 1),
('32165498744', 'Rosa Pereira', 'Atendente', 'Ensino Médio', 'Rua K, 40', '41999999999', 'Atendente', '12345678911', 0),
('74185296355', 'Miguel Lima', 'Auxiliar', 'Ensino Fundamental', 'Rua L, 50', '51999999999', 'Auxiliar', '12345678911', 0),
('85274196366', 'Patrícia Gomes', 'Confeiteira', 'Ensino Técnico', 'Rua M, 60', '61999999999', 'Confeiteira', '12345678911', 1),
('96385274177', 'Lucas Almeida', 'Entregador', 'Ensino Médio', 'Rua N, 70', '71999999999', 'Entregador', '12345678911', 0);

-- Inserir dados na tabela experiencia
INSERT INTO experiencia (experiencia, funcionario_cpf_funcionario)
VALUES
('Trabalhou na padaria A por 2 anos', '12345678911'),
('Trabalhou como assistente na empresa X', '98765432122'),
('Fez curso de confeitaria avançada', '45678912333'),
('Atendimento ao cliente no mercado Y', '32165498744'),
('Trabalhou como auxiliar de serviços gerais', '74185296355'),
('Fez estágio em confeitaria', '85274196366'),
('Experiência com entregas rápidas', '96385274177');

-- Inserir dados na tabela pedido
INSERT INTO pedido (data_pedido, valor, produto, entregador, horario_entrega, funcionario_cpf_funcionario, numero_da_entrega, cliente_cpf_cliente)
VALUES
('2024-09-15', 50.00, 'Brownie de Chocolate', NULL, '2024-09-15 14:30:00', '96385274177', 101, '12345678901'),
('2024-09-16', 60.00, 'Brownie de Nozes', 'Lucas Almeida', '2024-09-16 15:00:00', '96385274177', 102, '98765432100'),
('2024-09-17', 70.00, 'Brownie de Brigadeiro', NULL, '2024-09-17 16:00:00', '96385274177', 103, '45678912345'),
('2024-09-18', 55.00, 'Brownie de Limão', 'Lucas Almeida', '2024-09-18 14:00:00', '96385274177', 104, '32165498700'),
('2024-09-19', 65.00, 'Brownie de Doce de Leite', 'Lucas Almeida', '2024-09-19 13:30:00', '96385274177', 105, '74185296314'),
('2024-09-20', 75.00, 'Brownie de Amendoim', NULL, '2024-09-20 12:45:00', '96385274177', 106, '85274196310'),
('2024-09-21', 85.00, 'Brownie Vegano', 'Lucas Almeida', '2024-09-21 12:00:00', '96385274177', 107, '96385274120');

-- Inserir dados na tabela inclui
INSERT INTO inclui (quantidade, PK_doces, data_pedido, pedido_funcionario_cpf_funcionario, pedido_cliente_cpf_cliente)
VALUES
(3, 1, '2024-09-15', '96385274177', '12345678901'),
(2, 2, '2024-09-16', '96385274177', '98765432100'),
(5, 3, '2024-09-17', '96385274177', '45678912345'),
(4, 4, '2024-09-18', '96385274177', '32165498700'),
(3, 5, '2024-09-19', '96385274177', '74185296314'),
(1, 6, '2024-09-20', '96385274177', '85274196310'),
(2, 7, '2024-09-21', '96385274177', '96385274120');

-- Inserir dados na tabela telefone
INSERT INTO telefone (numero, cliente_cpf_cliente)
VALUES
('11987654321', '12345678901'),
('21987654321', '98765432100'),
('31987654321', '45678912345'),
('41987654321', '32165498700'),
('51987654321', '74185296314'),
('61987654321', '85274196310'),
('71987654321', '96385274120');

-- TERCEIRA PARTE - DQL

-- Consultando preços dos doces entre 6 e 7 reais
-- Cláusula BETWEEN

SELECT descricao, preco 
FROM doces
WHERE preco BETWEEN 6 AND 7;

-- Consultando clientes de duas cidades específicas
-- Cláusula IN/NOT IN

SELECT * 
FROM cliente
WHERE cidade IN ('Fortaleza', 'Salvador');

-- Consultando pedidos onde não houve entregador
-- IS NULL/IS NOT NULL

SELECT *
FROM pedido
WHERE entregador IS NULL;

-- Ordenando os preços dos produtos, do menor para o maior
-- Cláusula ORDER BY

SELECT *
FROM doces
ORDER BY preco ASC;

-- Consultando o cliente mais velho do sexo feminino
-- Cláusula MIN/MAX

SELECT MAX(valor) AS 'Pedido mais caro'
FROM pedido;

-- Contando quantos clientes são do sexo masculino e do feminino
-- Cláusulas COUNT e GROUP BY

SELECT sexo, COUNT(sexo) AS 'Quantidade'
FROM cliente
GROUP BY sexo;

-- Consultando clientes que têm Silva no nome
-- Cláusula LIKE
SELECT nome 
FROM cliente
WHERE nome LIKE '%Silva%';

-- Buscando clientes que fizeram pedidos de valor mais baixo do que 60 reais
-- Cláusula JOIN + HAVING

SELECT C.cpf_cliente, C.nome, P.cliente_cpf_cliente, P.valor
FROM cliente C
INNER JOIN pedido P
ON C.cpf_cliente = P.cliente_cpf_cliente
HAVING P.valor < 60
ORDER BY C.cpf_cliente, P.cliente_cpf_cliente; 	

SELECT * FROM pedido;

