CREATE DATABASE IF NOT EXISTS dataguard DEFAULT CHARACTER SET utf8;

USE dataguard;

-- Tabela parametros_monitoramento
CREATE TABLE IF NOT EXISTS parametrosMonitoramento (
  idParametrosMonitoramento INT PRIMARY KEY AUTO_INCREMENT,
  minCpu FLOAT NOT NULL,
  maxCpu FLOAT NOT NULL,
  minDisco FLOAT NOT NULL,
  maxDisco FLOAT NOT NULL,
  minRam FLOAT NOT NULL,
  maxRam FLOAT NOT NULL,
  minQtdDispositivosConectados INT NOT NULL,
  maxQtdDispositivosConectados INT NOT NULL,
  minLatenciaRede FLOAT NOT NULL,
  maxLatenciaRede FLOAT NOT NULL
);

-- Tabela instituicao
CREATE TABLE IF NOT EXISTS instituicao (
  idInstitucional INT PRIMARY KEY AUTO_INCREMENT,
  nomeInstitucional VARCHAR(50) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefone VARCHAR(14) NOT NULL,
  cep CHAR(8) NOT NULL,
  numeroEndereco VARCHAR(10) NOT NULL,
  complemento VARCHAR(50) NULL,
  fkParametrosMonitoramento INT NOT NULL,
  FOREIGN KEY (fkParametrosMonitoramento) REFERENCES parametrosMonitoramento (idParametrosMonitoramento)
);

-- Tabela usuario
CREATE TABLE IF NOT EXISTS usuario (
  idUsuario INT AUTO_INCREMENT,
  fkInstitucional INT NOT NULL,
  nome VARCHAR(30) NOT NULL ,
  email VARCHAR(100) unique,
  senha VARCHAR(30) NOT NULL,
  telefone VARCHAR(14) NULL,
  PRIMARY KEY (idUsuario, fkInstitucional),
  FOREIGN KEY (fkInstitucional) REFERENCES instituicao (idInstitucional)
);

-- Tabela acesso
CREATE TABLE IF NOT EXISTS acesso (
  idAcesso INT PRIMARY KEY AUTO_INCREMENT,
  tipoAcesso ENUM('AdminEigtech', 'Admin', 'Técnico') NOT NULL
);

-- Tabela acessoUsuario
CREATE TABLE IF NOT EXISTS acessoUsuario (
  idAcessoUsuario INT AUTO_INCREMENT,
  fkUsuario INT NOT NULL,
  fkInstitucional INT NOT NULL,
  fkAcesso INT NOT NULL,
  dataAcessoUsuario DATE NOT NULL,
  PRIMARY KEY (idAcessoUsuario, fkUsuario, fkInstitucional, fkAcesso),
  FOREIGN KEY (fkUsuario) REFERENCES usuario (idUsuario),
  FOREIGN KEY (fkInstitucional) REFERENCES usuario (fkInstitucional),
  FOREIGN KEY (fkAcesso) REFERENCES acesso (idAcesso)
);

-- Tabela laboratorio
CREATE TABLE IF NOT EXISTS laboratorio (
  idLaboratorio INT AUTO_INCREMENT,
  fkInstitucional INT NOT NULL,
  nomeSala VARCHAR(30) NOT NULL,
  numeroSala VARCHAR(3) NOT NULL,
  fkResponsavel INT NOT NULL,
  PRIMARY KEY (idLaboratorio, fkInstitucional),
  FOREIGN KEY (fkInstitucional) REFERENCES instituicao (idInstitucional),
  FOREIGN KEY (fkResponsavel) REFERENCES usuario (idUsuario)
);



-- Tabela maquina
CREATE TABLE IF NOT EXISTS maquina (
  idMaquina INT PRIMARY KEY AUTO_INCREMENT,
  numeroDeSerie VARCHAR(30) unique,
  ipMaquina VARCHAR(12) NOT NULL,
  sistemaOperacional VARCHAR(30) NOT NULL,
  status TINYINT DEFAULT 1 NOT NULL, CONSTRAINT chk_status CHECK (status IN (0, 1)),
  dataCadastro VARCHAR(45) NOT NULL,
  dataDesativamento VARCHAR(45) NULL,
  fkLaboratorio INT,
  fkInstitucional INT NOT NULL,
  FOREIGN KEY (fkLaboratorio) REFERENCES laboratorio (idLaboratorio),
  FOREIGN KEY (fkInstitucional) REFERENCES laboratorio (fkInstitucional)
);


-- Tabela componentes 
CREATE TABLE IF NOT EXISTS componenteMonitorado (
	idComponente INT AUTO_INCREMENT,
    fkMaquina INT,
    componente VARCHAR(50) NOT NULL, 
    tipo VARCHAR(50), 
    descricaoAdicional VARCHAR(50), 
    modelo VARCHAR(50), 
    marca VARCHAR(50), 
    capacidadeTotal FLOAT NOT NULL, 
    unidadeMedida ENUM('GB', 'MB', 'MS', 'GHz', 'INT') NOT NULL,
	FOREIGN KEY (fkMaquina) REFERENCES maquina (idMaquina),
    PRIMARY KEY (idComponente, fkMaquina)
);

-- Tabela medições
CREATE TABLE IF NOT EXISTS medicoes (
  idMonitoramento INT AUTO_INCREMENT,
  fkMaquina INT NOT NULL,
  fkComponente INT NOT NULL,
  valorConsumido FLOAT NOT NULL,
  dataHora DATETIME NOT NULL,
  PRIMARY KEY (idMonitoramento, fkMaquina, fkComponente),
  FOREIGN KEY (fkComponente) REFERENCES componenteMonitorado (idComponente),
  FOREIGN KEY (fkMaquina) REFERENCES componenteMonitorado (fkMaquina)
);

-- Tabela Alertas
CREATE TABLE IF NOT EXISTS Alertas (
  idAlertas INT AUTO_INCREMENT,
  tipo VARCHAR(45) NOT NULL,
  lido TINYINT  NOT NULL, CONSTRAINT chk_lido CHECK (lido IN (0, 1)),
  fkMonitoramento INT NOT NULL,
  fkComponente INT NOT NULL,
  fkMaquina INT NOT NULL,
  PRIMARY KEY (idAlertas, fkMonitoramento, fkComponente, fkMaquina),
  FOREIGN KEY (fkMonitoramento) REFERENCES medicoes (idMonitoramento),
  FOREIGN KEY (fkComponente) REFERENCES medicoes (fkComponente),
  FOREIGN KEY (fkMaquina) REFERENCES medicoes (fkMaquina)
); 
    
 -- Insert na tabela acesso  --
INSERT INTO acesso VALUES
	(null , 'AdminEigtech'),
	(null , 'Admin'),
	(null , 'Técnico');    

-- Inserindo dados na tabela parametrosMonitoramento
INSERT INTO parametrosMonitoramento (minCpu, maxCpu, minDisco, maxDisco, minRam, maxRam, minQtdDispositivosConectados, maxQtdDispositivosConectados, minLatenciaRede, maxLatenciaRede)
VALUES (10.0, 80.0, 20.0, 90.0, 30.0, 70.0, 5, 50, 1.0, 50.0);

-- Insert da nossa instituição (Eigtech) ao sistema
INSERT INTO instituicao VALUES
	(null , 'Eigtech' , '00000000000000' , 'eigtechsolutions@gmail.com' , '11912345678' , '01414001' , '595' , '5 minutos da estação Consolação' , 1);
    
INSERT INTO usuario VALUES
(null , 1 , 'Admim Eigtech' , 'eigtechsolutions@gmail.com' , '2023' , '11912345678');

INSERT INTO acessoUsuario VALUES
	(null, 1, 1, 1, '2023-11-01');
    
    -- Inserindo dados na tabela instituicao
INSERT INTO instituicao (nomeInstitucional, cnpj, email, telefone, cep, numeroEndereco, complemento, fkParametrosMonitoramento)
VALUES ('Instituicao 1', '12345678901234', 'instituicao1@example.com', '1234567890', '12345678', '123', 'Complemento 1', 1);

-- Inserindo dados na tabela usuario
INSERT INTO usuario (fkInstitucional, nome, email, senha, telefone)
VALUES (2, 'Enzo Stane', 'enzin@gmail.com', '2207', '987654321');

-- Inserindo dados na tabela acessoUsuario
INSERT INTO acessoUsuario (fkUsuario, fkInstitucional, fkAcesso, dataAcessoUsuario)
VALUES (2, 2, 2, '2023-11-02'), (2, 2, 3, '2023-11-02');

-- Inserindo dados na tabela laboratorio
INSERT INTO laboratorio (fkInstitucional, nomeSala, numeroSala, fkResponsavel)
VALUES (2, 'Laboratorio 1', '101', 2), (2, 'Laboratorio 2', '102', 2), (2, 'Laboratorio 3', '103', 2), (2, 'Laboratorio 4', '104', 2), (2, 'Laboratorio 5', '105', 1);