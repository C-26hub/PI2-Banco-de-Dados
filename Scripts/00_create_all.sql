-- ======================================
-- 1. CRIAÇÃO DO BANCO E DAS TABELAS (DDL)
-- ======================================

DROP DATABASE IF EXISTS ecosy;
CREATE DATABASE IF NOT EXISTS ecosy;
USE ecosy;

-- ============================
-- Tabela: Lote
-- ============================
CREATE TABLE Lote (
  idLote INT NOT NULL,
  tipoSemente VARCHAR(45) NOT NULL,
  quantidadekg DECIMAL(10,2) NOT NULL CHECK (quantidadekg >= 0),
  dataAquisicao DATETIME NOT NULL,
  origem VARCHAR(45) NOT NULL,
  documentoAnexo BLOB NOT NULL,
  status ENUM("Distribuição", "Concluído", "Planejamento") NOT NULL,
  PRIMARY KEY (idLote)
) ENGINE=InnoDB;

-- ============================
-- Tabela: Usuarios
-- ============================
CREATE TABLE Usuarios (
  idUsuario INT NOT NULL,
  CPF VARCHAR(14) NOT NULL,
  nome VARCHAR(45) NOT NULL,
  sobrenome VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  status ENUM("Ativo", "Inativo") NOT NULL,
  senha VARCHAR(45) NOT NULL,
  nivelAcesso ENUM("Gestor", "Técnico") NOT NULL,
  PRIMARY KEY (idUsuario)
) ENGINE=InnoDB;

-- ============================
-- Tabela: Beneficiarios
-- ============================
CREATE TABLE Beneficiarios (
  idBeneficiario INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  sobrenome VARCHAR(45) NOT NULL,
  CPF VARCHAR(14) NOT NULL,
  telefone INT NOT NULL,
  status ENUM("Ativo", "Inativo") NOT NULL,
  associacao VARCHAR(45),
  Usuarios_idUsuario INT NOT NULL,
  PRIMARY KEY (idBeneficiario),
  FOREIGN KEY (Usuarios_idUsuario) REFERENCES Usuarios(idUsuario)
) ENGINE=InnoDB;

-- ============================
-- Tabela: Entrega
-- ============================
CREATE TABLE Entrega (
  idEntrega INT NOT NULL,
  status ENUM("Concluído", "Pendente") NOT NULL,
  quantidadeEntregue INT NOT NULL,
  dataEntrega DATETIME NOT NULL,
  fotoComprovante BLOB NOT NULL,
  dataConfirmacao DATETIME NOT NULL,
  Beneficiarios_idBeneficiario INT NOT NULL,
  Lote_idLote INT NOT NULL,
  PRIMARY KEY (idEntrega, Beneficiarios_idBeneficiario, Lote_idLote),
  FOREIGN KEY (Beneficiarios_idBeneficiario) REFERENCES Beneficiarios(idBeneficiario) ON DELETE CASCADE,
  FOREIGN KEY (Lote_idLote) REFERENCES Lote(idLote) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================
-- Tabela: Endereco
-- ============================
CREATE TABLE Endereco (
  rua VARCHAR(45) NOT NULL,
  cidade VARCHAR(45) NOT NULL,
  estado VARCHAR(45) NOT NULL,
  CEP VARCHAR(9) NOT NULL,
  Beneficiarios_idBeneficiario INT NOT NULL,
  PRIMARY KEY (Beneficiarios_idBeneficiario),
  FOREIGN KEY (Beneficiarios_idBeneficiario) REFERENCES Beneficiarios(idBeneficiario)
) ENGINE=InnoDB;

-- ============================
-- Tabela: Observacao
-- ============================
CREATE TABLE Observacao (
  idObservacao INT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(250) NOT NULL,
  dataHora DATETIME NOT NULL,
  Usuarios_idUsuario INT NOT NULL,
  PRIMARY KEY (idObservacao, Usuarios_idUsuario),
  FOREIGN KEY (Usuarios_idUsuario) REFERENCES Usuarios(idUsuario)
) ENGINE=InnoDB;
