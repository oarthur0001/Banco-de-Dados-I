-- Create Schema / Database
CREATE DATABASE IF NOT EXISTS `mercado_dia_a_dia` DEFAULT CHARACTER SET utf8mb4 ;
USE `mercado_dia_a_dia` ;

-- ========================================================
-- MÓDULO 1: GESTÃO DE RH E ACESSOS AO SISTEMA (4 Tabelas)
-- ========================================================

-- 1. DEPARTAMENTO
CREATE TABLE IF NOT EXISTS `DEPARTAMENTO` (
  `id_departamento` INT NOT NULL AUTO_INCREMENT,
  `nome_departamento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_departamento`)
) ENGINE = InnoDB;

-- 2. CARGO
CREATE TABLE IF NOT EXISTS `CARGO` (
  `id_cargo` INT NOT NULL AUTO_INCREMENT,
  `titulo_cargo` VARCHAR(45) NOT NULL,
  `salario_base` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_cargo`)
) ENGINE = InnoDB;

-- 3. FUNCIONARIO (Relacionamento Não-Identificador com CARGO e DEPARTAMENTO)
CREATE TABLE IF NOT EXISTS `FUNCIONARIO` (
  `id_funcionario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cpf` VARCHAR(14) NOT NULL,
  `data_admissao` DATE NOT NULL,
  `id_cargo` INT NOT NULL,
  `id_departamento` INT NOT NULL,
  PRIMARY KEY (`id_funcionario`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC),
  INDEX `fk_FUNCIONARIO_CARGO_idx` (`id_cargo` ASC),
  INDEX `fk_FUNCIONARIO_DEPARTAMENTO_idx` (`id_departamento` ASC),
  CONSTRAINT `fk_FUNCIONARIO_CARGO`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `CARGO` (`id_cargo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_FUNCIONARIO_DEPARTAMENTO`
    FOREIGN KEY (`id_departamento`)
    REFERENCES `DEPARTAMENTO` (`id_departamento`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- 4. USUARIO_SISTEMA (Relacionamento 1:1 com FUNCIONARIO - id_funcionario é PK e FK)
CREATE TABLE IF NOT EXISTS `USUARIO_SISTEMA` (
  `id_funcionario` INT NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `senha_hash` VARCHAR(255) NOT NULL,
  `ativo` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_funcionario`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC),
  CONSTRAINT `fk_USUARIO_SISTEMA_FUNCIONARIO`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `FUNCIONARIO` (`id_funcionario`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ========================================================
-- MÓDULO 2: CATÁLOGO DE PRODUTOS E FORNECEDORES (3 Tabelas)
-- ========================================================

-- 5. FORNECEDOR
CREATE TABLE IF NOT EXISTS `FORNECEDOR` (
  `id_fornecedor` INT NOT NULL AUTO_INCREMENT,
  `razao_social` VARCHAR(100) NOT NULL,
  `cnpj` VARCHAR(18) NOT NULL,
  `telefone` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`id_fornecedor`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC)
) ENGINE = InnoDB;

-- 6. CATEGORIA
CREATE TABLE IF NOT EXISTS `CATEGORIA` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nome_categoria` VARCHAR(45) NOT NULL,
  `descricao` TEXT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE = InnoDB;

-- 7. PRODUTO (Relacionamento Não-Identificador com CATEGORIA e FORNECEDOR)
CREATE TABLE IF NOT EXISTS `PRODUTO` (
  `id_produto` INT NOT NULL AUTO_INCREMENT,
  `codigo_barras` VARCHAR(45) NOT NULL,
  `nome_produto` VARCHAR(100) NOT NULL,
  `preco_venda` DECIMAL(10,2) NOT NULL,
  `id_categoria` INT NOT NULL,
  `id_fornecedor` INT NOT NULL,
  PRIMARY KEY (`id_produto`),
  UNIQUE INDEX `codigo_barras_UNIQUE` (`codigo_barras` ASC),
  INDEX `fk_PRODUTO_CATEGORIA_idx` (`id_categoria` ASC),
  INDEX `fk_PRODUTO_FORNECEDOR_idx` (`id_fornecedor` ASC),
  CONSTRAINT `fk_PRODUTO_CATEGORIA`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `CATEGORIA` (`id_categoria`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUTO_FORNECEDOR`
    FOREIGN KEY (`id_fornecedor`)
    REFERENCES `FORNECEDOR` (`id_fornecedor`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- ========================================================
-- MÓDULO 3: ESTOQUE E LOCALIZAÇÃO FÍSICA (2 Tabelas)
-- ========================================================

-- 8. LOCAL_ESTOQUE
CREATE TABLE IF NOT EXISTS `LOCAL_ESTOQUE` (
  `id_local` INT NOT NULL AUTO_INCREMENT,
  `corredor` VARCHAR(10) NOT NULL,
  `prateleira` VARCHAR(10) NOT NULL,
  `setor` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_local`)
) ENGINE = InnoDB;

-- 9. ESTOQUE (PK Composta e Relacionamento Identificador com PRODUTO e LOCAL_ESTOQUE)
CREATE TABLE IF NOT EXISTS `ESTOQUE` (
  `id_produto` INT NOT NULL,
  `id_local` INT NOT NULL,
  `quantidade_disponivel` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_produto`, `id_local`),
  INDEX `fk_ESTOQUE_LOCAL_ESTOQUE_idx` (`id_local` ASC),
  CONSTRAINT `fk_ESTOQUE_PRODUTO`
    FOREIGN KEY (`id_produto`)
    REFERENCES `PRODUTO` (`id_produto`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ESTOQUE_LOCAL_ESTOQUE`
    FOREIGN KEY (`id_local`)
    REFERENCES `LOCAL_ESTOQUE` (`id_local`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- ========================================================
-- MÓDULO 4: CAMPANHAS DE PROMOÇÃO (2 Tabelas)
-- ========================================================

-- 10. PROMOCAO
CREATE TABLE IF NOT EXISTS `PROMOCAO` (
  `id_promocao` INT NOT NULL AUTO_INCREMENT,
  `titulo_promocao` VARCHAR(100) NOT NULL,
  `data_inicio` DATETIME NOT NULL,
  `data_fim` DATETIME NOT NULL,
  PRIMARY KEY (`id_promocao`)
) ENGINE = InnoDB;

-- 11. PRODUTO_PROMOCAO (PK Composta N:N - PRODUTO + PROMOCAO)
CREATE TABLE IF NOT EXISTS `PRODUTO_PROMOCAO` (
  `id_produto` INT NOT NULL,
  `id_promocao` INT NOT NULL,
  `preco_promocional` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_produto`, `id_promocao`),
  INDEX `fk_PRODUTO_PROMOCAO_PROMOCAO_idx` (`id_promocao` ASC),
  CONSTRAINT `fk_PRODUTO_PROMOCAO_PRODUTO`
    FOREIGN KEY (`id_produto`)
    REFERENCES `PRODUTO` (`id_produto`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_PRODUTO_PROMOCAO_PROMOCAO`
    FOREIGN KEY (`id_promocao`)
    REFERENCES `PROMOCAO` (`id_promocao`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ========================================================
-- MÓDULO 5: VENDAS, CLIENTES E FATURAMENTO (3 Tabelas)
-- ========================================================

-- 12. CLIENTE
CREATE TABLE IF NOT EXISTS `CLIENTE` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cpf` VARCHAR(14) NULL,
  `pontos_fidelidade` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC)
) ENGINE = InnoDB;

-- 13. NOTA_FISCAL (Relacionamento Não-Identificador com FUNCIONARIO [obrigatório] e CLIENTE [opcional])
CREATE TABLE IF NOT EXISTS `NOTA_FISCAL` (
  `id_nota_fiscal` INT NOT NULL AUTO_INCREMENT,
  `numero_nf` VARCHAR(45) NOT NULL,
  `data_emissao` DATETIME NOT NULL,
  `valor_total` DECIMAL(10,2) NOT NULL,
  `id_funcionario` INT NOT NULL,
  `id_cliente` INT NULL,
  PRIMARY KEY (`id_nota_fiscal`),
  INDEX `fk_NOTA_FISCAL_FUNCIONARIO_idx` (`id_funcionario` ASC),
  INDEX `fk_NOTA_FISCAL_CLIENTE_idx` (`id_cliente` ASC),
  CONSTRAINT `fk_NOTA_FISCAL_FUNCIONARIO`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `FUNCIONARIO` (`id_funcionario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_NOTA_FISCAL_CLIENTE`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `CLIENTE` (`id_cliente`)
    ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- 14. ITEM_NOTA_FISCAL (PK Composta Identificadora: id_nota_fiscal + id_item_seq)
CREATE TABLE IF NOT EXISTS `ITEM_NOTA_FISCAL` (
  `id_nota_fiscal` INT NOT NULL,
  `id_item_seq` INT NOT NULL,
  `id_produto` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `subtotal` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_nota_fiscal`, `id_item_seq`),
  INDEX `fk_ITEM_NOTA_FISCAL_PRODUTO_idx` (`id_produto` ASC),
  CONSTRAINT `fk_ITEM_NOTA_FISCAL_NOTA_FISCAL`
    FOREIGN KEY (`id_nota_fiscal`)
    REFERENCES `NOTA_FISCAL` (`id_nota_fiscal`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ITEM_NOTA_FISCAL_PRODUTO`
    FOREIGN KEY (`id_produto`)
    REFERENCES `PRODUTO` (`id_produto`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- ========================================================
-- MÓDULO 6: COMPRAS E ABASTECIMENTO (2 Tabelas)
-- ========================================================

-- 15. PEDIDO_COMPRA (Relacionamento Não-Identificador com FORNECEDOR e FUNCIONARIO)
CREATE TABLE IF NOT EXISTS `PEDIDO_COMPRA` (
  `id_pedido_compra` INT NOT NULL AUTO_INCREMENT,
  `data_pedido` DATETIME NOT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
  `id_fornecedor` INT NOT NULL,
  `id_funcionario` INT NOT NULL,
  PRIMARY KEY (`id_pedido_compra`),
  INDEX `fk_PEDIDO_COMPRA_FORNECEDOR_idx` (`id_fornecedor` ASC),
  INDEX `fk_PEDIDO_COMPRA_FUNCIONARIO_idx` (`id_funcionario` ASC),
  CONSTRAINT `fk_PEDIDO_COMPRA_FORNECEDOR`
    FOREIGN KEY (`id_fornecedor`)
    REFERENCES `FORNECEDOR` (`id_fornecedor`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDO_COMPRA_FUNCIONARIO`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `FUNCIONARIO` (`id_funcionario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- 16. ITEM_PEDIDO_COMPRA (PK Composta N:N - id_pedido_compra + id_produto)
CREATE TABLE IF NOT EXISTS `ITEM_PEDIDO_COMPRA` (
  `id_pedido_compra` INT NOT NULL,
  `id_produto` INT NOT NULL,
  `quantidade_solicitada` INT NOT NULL,
  `preco_custo_unitario` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_pedido_compra`, `id_produto`),
  INDEX `fk_ITEM_PEDIDO_COMPRA_PRODUTO_idx` (`id_produto` ASC),
  CONSTRAINT `fk_ITEM_PEDIDO_COMPRA_PEDIDO_COMPRA`
    FOREIGN KEY (`id_pedido_compra`)
    REFERENCES `PEDIDO_COMPRA` (`id_pedido_compra`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ITEM_PEDIDO_COMPRA_PRODUTO`
    FOREIGN KEY (`id_produto`)
    REFERENCES `PRODUTO` (`id_produto`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;