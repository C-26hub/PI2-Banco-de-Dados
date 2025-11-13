-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Lote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lote` (
  `idLote` INT NOT NULL,
  `tipoSemente` VARCHAR(45) NOT NULL,
  `quantidadekg` DECIMAL(10,2) NOT NULL CHECK (quantidadekg >= 0),
  `dataAquisicao` DATETIME NOT NULL,
  `origem` VARCHAR(45) NOT NULL,
  `documentoAnexo` BLOB NOT NULL,
  `status` ENUM("Distribuição", "Concluído", "Planejamento") NOT NULL,
  PRIMARY KEY (`idLote`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Usuarios` (
  `idUsuario` INT NOT NULL,
  `CPF` VARCHAR(14) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `sobrenome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `status` ENUM("Ativo", "Inativo") NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  `nivelAcesso` ENUM("Gestor", "Técnico") NOT NULL,
  PRIMARY KEY (`idUsuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Beneficiarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Beneficiarios` (
  `idBeneficiario` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `sobrenome` VARCHAR(45) NOT NULL,
  `CPF` VARCHAR(14) NOT NULL,
  `telefone` INT NOT NULL,
  `status` ENUM("Ativo", "Inativo") NOT NULL,
  `associacao` VARCHAR(45) NULL,
  `Usuarios_idUsuario` INT NOT NULL,
  PRIMARY KEY (`idBeneficiario`),
  INDEX `fk_Beneficiarios_Usuarios1_idx` (`Usuarios_idUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_Beneficiarios_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuario`)
    REFERENCES `mydb`.`Usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Entrega` (
  `idEntrega` INT NOT NULL,
  `status` ENUM("Concluído", "Pendente") NOT NULL,
  `quantidadeEntregue` INT NOT NULL,
  `dataEntrega` DATETIME NOT NULL,
  `fotoComprovante` BLOB NOT NULL,
  `dataConfirmacao` DATETIME NOT NULL,
  `Beneficiarios_idBeneficiario` INT NOT NULL,
  `Lote_idLote` INT NOT NULL,
  PRIMARY KEY (`idEntrega`, `Beneficiarios_idBeneficiario`, `Lote_idLote`),
  INDEX `fk_Entrega_Beneficiarios1_idx` (`Beneficiarios_idBeneficiario` ASC) VISIBLE,
  INDEX `fk_Entrega_Lote1_idx` (`Lote_idLote` ASC) VISIBLE,
  CONSTRAINT `fk_Entrega_Beneficiarios1`
    FOREIGN KEY (`Beneficiarios_idBeneficiario`)
    REFERENCES `mydb`.`Beneficiarios` (`idBeneficiario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Entrega_Lote1`
    FOREIGN KEY (`Lote_idLote`)
    REFERENCES `mydb`.`Lote` (`idLote`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Endereco` (
  `rua` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `CEP` VARCHAR(9) NOT NULL,
  `Beneficiarios_idBeneficiario` INT NOT NULL,
  PRIMARY KEY (`Beneficiarios_idBeneficiario`),
  CONSTRAINT `fk_Endereco_Beneficiarios`
    FOREIGN KEY (`Beneficiarios_idBeneficiario`)
    REFERENCES `mydb`.`Beneficiarios` (`idBeneficiario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Observacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Observacao` (
  `idObservacao` INT NOT NULL,
  `descricao` VARCHAR(250) NOT NULL,
  `dataHora` DATETIME NOT NULL,
  `Usuarios_idUsuario` INT NOT NULL,
  PRIMARY KEY (`idObservacao`, `Usuarios_idUsuario`),
  INDEX `fk_Observacao_Usuarios1_idx` (`Usuarios_idUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_Observacao_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuario`)
    REFERENCES `mydb`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
