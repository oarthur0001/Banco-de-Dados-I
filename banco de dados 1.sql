CREATE DATABASE IF NOT EXISTS petshop;
USE petshop;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(200)
);

CREATE TABLE pet (
    id_pet INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    nome VARCHAR(100),
    especie VARCHAR(50),
    raca VARCHAR(50),
    idade TINYINT
);

CREATE TABLE servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(100),
    descricao TEXT,
    preco DECIMAL(10,2)
);

CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cargo VARCHAR(50),
    telefone VARCHAR(20)
);

CREATE TABLE agendamento (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pet INT,
    id_servico INT,
    id_func INT,
    data_hora DATETIME
);