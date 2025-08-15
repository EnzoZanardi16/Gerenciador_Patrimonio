-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Patrimônio
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Patrimônio
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Patrimônio` DEFAULT CHARACTER SET utf8 ;
USE `Patrimônio` ;

-- -----------------------------------------------------
-- Table `Patrimônio`.`Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Patrimônio`.`Status` (
  `idStatus` INT NOT NULL AUTO_INCREMENT,
  `State_disp` ENUM('0', '1') NOT NULL,
  `State_origem` ENUM('0', '1') NOT NULL,
  PRIMARY KEY (`idStatus`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Patrimônio`.`Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Patrimônio`.`Usuarios` (
  `idUsuarios` INT NOT NULL AUTO_INCREMENT,
  `Usuario_nome` VARCHAR(100) NOT NULL,
  `Usuario_data` DATE NULL,
  PRIMARY KEY (`idUsuarios`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Patrimônio`.`Itens`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Patrimônio`.`Itens` (
  `num_patrimonio` INT NOT NULL AUTO_INCREMENT,
  `Item_nome` VARCHAR(100) NOT NULL,
  `Item_origem` VARCHAR(200) NOT NULL,
  `Itens_del` ENUM('0', '1') NOT NULL,
  `Status_idStatus` INT NOT NULL,
  `Usuarios_idUsuarios` INT NOT NULL,
  PRIMARY KEY (`num_patrimonio`),
  INDEX `fk_Itens_Status1_idx` (`Status_idStatus`),
  INDEX `fk_Itens_Usuarios1_idx` (`Usuarios_idUsuarios`),
  CONSTRAINT `fk_Itens_Status1`
    FOREIGN KEY (`Status_idStatus`)
    REFERENCES `Patrimonio`.`Status` (`idStatus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Itens_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuarios`)
    REFERENCES `Patrimônio`.`Usuarios` (`idUsuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Patrimônio`.`Movimentaçoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Patrimônio`.`Movimentaçoes` (
  `idMovimentaçoes` INT NOT NULL AUTO_INCREMENT,
  `Itens_num_patrimonio` INT NOT NULL,
  `Status_idStatus` INT NOT NULL,
  PRIMARY KEY (`idMovimentaçoes`),
  INDEX `fk_Movimentaçoes_Itens1_idx` (`Itens_num_patrimonio`),
  INDEX `fk_Movimentaçoes_Status1_idx` (`Status_idStatus`),
  CONSTRAINT `fk_Movimentaçoes_Itens1`
    FOREIGN KEY (`Itens_num_patrimonio`)
    REFERENCES `Patrimônio`.`Itens` (`num_patrimonio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Movimentaçoes_Status1`
    FOREIGN KEY (`Status_idStatus`)
    REFERENCES `Patrimônio`.`Status` (`idStatus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DELIMITER $$

CREATE TRIGGER trg_registrar_movimentacao
AFTER UPDATE ON Status
FOR EACH ROW
BEGIN
    -- Quando o status mudar de disponível (1) para indisponível (0)
    IF OLD.State_disp = '1' AND NEW.State_disp = '0' THEN
        INSERT INTO Movimentacoes (Itens_num_patrimonio, Status_idStatus)
        SELECT num_patrimonio, NEW.idStatus
        FROM Itens
        WHERE Status_idStatus = NEW.idStatus;
    END IF;

    -- Quando o status mudar de indisponível (0) para disponível (1)
    IF OLD.State_disp = '0' AND NEW.State_disp = '1' THEN
        INSERT INTO Movimentacoes (Itens_num_patrimonio, Status_idStatus)
        SELECT num_patrimonio, NEW.idStatus
        FROM Itens
        WHERE Status_idStatus = NEW.idStatus;
    END IF;
END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
