-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 21-Out-2026 às 21:22
-- Versão do servidor: 10.4.22-MariaDB
-- versão do PHP: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `estudio_tatuagem`
--
CREATE DATABASE IF NOT EXISTS `estudio_tatuagem` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `estudio_tatuagem`;

-- --------------------------------------------------------

--
-- Estrutura da tabela `agendamento`
--

CREATE TABLE `agendamento` (
  `idagendamento` int(11) NOT NULL,
  `idcliente` int(11) NOT NULL,
  `idtatuador` int(11) NOT NULL,
  `dataagendamento` date NOT NULL,
  `horaagendamento` time NOT NULL,
  `descricaotatuagem` text DEFAULT NULL,
  `desenhoaprovado` varchar(255) DEFAULT NULL,
  `valortatuagem` decimal(10,2) DEFAULT NULL,
  `status` enum('pendente','confirmado','concluido','cancelado') NOT NULL DEFAULT 'pendente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `agendamento`
--

INSERT INTO `agendamento` (`idagendamento`, `idcliente`, `idtatuador`, `dataagendamento`, `horaagendamento`, `descricaotatuagem`, `desenhoaprovado`, `valortatuagem`, `status`) VALUES
(1, 1, 1, '2026-10-22', '16:00:00', 'Fenix nas costas segurando um arco', '1_decalque-castle.jpg', '480.00', 'confirmado'),
(3, 10, 2, '2026-09-09', '08:10:00', 'Estrelas no pé.', '3_estrelas.jpg', '200.00', 'confirmado'),
(6, 2, 3, '2026-05-08', '17:00:00', 'Dragão oriental braço.', '6_oriental.jpg', '500.00', 'confirmado'),
(8, 1, 2, '2026-03-12', '14:09:00', 'Frase costas', '8_frasecostas.jpg', '300.00', 'cancelado'),
(10, 1, 2, '2026-09-02', '07:49:00', 'lettering ', '10_lettering.jpg', '200.00', 'pendente'),
(11, 1, 3, '2026-10-13', '11:02:00', 'Fechamento canela.', '11_fechamentocanela.jpg', '700.00', 'pendente'),
(12, 4, 6, '2026-10-12', '05:31:00', 'Raposa de nove caudas.', '12_9caudas.jpg', '300.00', 'concluido'),
(13, 5, 9, '2026-11-28', '15:00:00', 'Cerejeira ombro ', '13_tatuagem-oriental.jpg', '600.00', 'pendente'),
(15, 5, 4, '2026-02-19', '12:20:00', 'Borboleta na coxa.', '15_tatto-borboleta.jpg', '320.00', 'pendente'),
(16, 1, 8, '2026-05-13', '07:30:00', 'Frase, pescoço/ombro.', '16_frase.avif', '270.00', 'confirmado'),
(17, 6, 10, '2026-10-21', '14:50:00', NULL, '17_dragao.jpg', '300.00', 'pendente'),
(18, 17, 10, '2026-10-07', '18:54:00', 'Flores no Ombro.', '18_flores.jpg', '320.00', 'pendente'),
(19, 19, 8, '2027-01-22', '15:59:00', 'Frase e anjo no ombro.', '19_fraseanjo.jpg', '600.00', 'pendente');

-- --------------------------------------------------------

--
-- Estrutura da tabela `cliente`
--

CREATE TABLE `cliente` (
  `idcliente` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `datacadastro` date DEFAULT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `cliente`
--

INSERT INTO `cliente` (`idcliente`, `nome`, `cpf`, `telefone`, `datacadastro`, `cidade`, `uf`) VALUES
(1, 'Ana Silva', '44444444444', '11988880001', '2024-01-15', 'São Paulo', 'SP'),
(2, 'Bruno Costa', '55555555555', '31988880002', '2024-03-22', 'Belo Horizonte', 'MG'),
(4, 'Eduarda Ferreira', '66699988852', '11855669933', '2026-10-20', 'Santos', 'SP'),
(5, 'Rafaela Montes', '4445559966', '11596325698', '2026-10-20', 'Rio Grande do Sul', 'RS'),
(6, 'Emilly Campos', '33366695588', '11966587400', '2026-10-21', 'São José dos Campos', 'SP'),
(7, 'Paulo Yago', '66699988452', '11963526688', '2026-10-21', 'Minas Gerais', 'MG'),
(8, 'Fernanda Castro', '66600077785', '11963526388', '2026-10-21', 'São Vicente', 'SP'),
(9, 'Kaio Rissi', '33366674988', '11446377888', '2026-10-21', 'Teresina', 'PI'),
(10, 'Richard Fagundes', '36999988852', '11966587488', '2026-10-21', 'Pinheiros', 'SP'),
(11, 'Cindy Paula', '66699223885', '11444777877', '2026-10-21', 'Fortaleza', 'CE'),
(12, 'Ivan Pires', '66691188852', '11444777800', '2026-10-21', 'Praia Grande', 'SP'),
(13, 'Sthefany Augusta', '11155588833', '11966587422', '2026-10-21', 'Salvador', 'BA'),
(14, 'Lydia Soares', '33366699911', '11966517400', '2026-10-21', 'Brasilia', 'DF'),
(15, 'Otávio Bragança', '33366699980', '11444776888', '2026-10-21', 'Rio Verde', 'GO'),
(16, 'Tainá Marajó', '11155588810', '11963526683', '2026-10-21', 'Bonito', 'MS'),
(17, 'Amanda Schimitz', '33366699989', '11963526288', '2026-10-21', 'Blumenau', 'SC'),
(18, 'Letícia Valadares', '11155588866', '11966587409', '2026-10-21', 'Ouro Preto', 'MG'),
(19, 'Bernardo Dornelles', '33376699988', '11444777886', '2026-10-21', 'Londrina', 'PR'),
(20, 'Thiago Gulin', '11151188877', '11966587411', '2026-10-21', 'Olinda', 'PE');

-- --------------------------------------------------------

--
-- Estrutura da tabela `estilo`
--

CREATE TABLE `estilo` (
  `idestilo` int(11) NOT NULL,
  `descricao` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `estilo`
--

INSERT INTO `estilo` (`idestilo`, `descricao`) VALUES
(1, 'Blackwork'),
(2, 'Aquarela'),
(3, 'Realismo'),
(4, 'Old School'),
(5, 'Oriental'),
(6, 'Fine Line '),
(9, 'Tribal'),
(10, 'Pontilhismo'),
(12, 'Geométrico'),
(14, 'New Traditional'),
(15, 'Glitch'),
(16, 'Tinta branca'),
(17, 'SINGLE LINE');

-- --------------------------------------------------------

--
-- Estrutura da tabela `senioridade`
--

CREATE TABLE `senioridade` (
  `idsenioridade` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `senioridade`
--

INSERT INTO `senioridade` (`idsenioridade`, `nome`) VALUES
(1, 'Júnior'),
(2, 'Pleno'),
(3, 'Sênior'),
(5, 'Executivo');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tatuador`
--

CREATE TABLE `tatuador` (
  `idtatuador` int(11) NOT NULL,
  `nometatuador` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `datacontratacao` date DEFAULT NULL,
  `idsenioridade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `tatuador`
--

INSERT INTO `tatuador` (`idtatuador`, `nometatuador`, `cpf`, `email`, `telefone`, `datacontratacao`, `idsenioridade`) VALUES
(1, 'Lucas Mendes', '11111111111', 'lucas@estudio.com', '11999990001', '2026-10-09', 3),
(2, 'Carla Souza', '22222222222', 'carla@estudio.com', '11999990002', '2022-06-15', 2),
(3, 'Pedro Lima', '33333333333', 'pedro@estudio.com', '11999990003', '2024-01-10', 1),
(4, 'Jorge Mateus', '22266639633', 'jorgetatto@gmail.com', '11945853699', '2026-10-20', 2),
(6, 'Cassandra Clark', '12345678900', 'cassstudiio@email.com', '11999999999', '2026-10-20', 2),
(7, 'Eduarda Mendes', '12345678985', 'eduardamendes322@gmail.com', '11956985233', '2026-10-20', 2),
(8, 'Murillo Gomez', '22233369655', 'muro@gmail.com', '11589654777', '2026-10-20', 3),
(9, 'Ryan Hugo', '33369656988', 'rhugo@estudio.com', '33687459632', '2026-10-20', 1),
(10, 'Quíron Coper', '11155588877', 'quiron@estudio.com', '11444777888', '2026-10-21', 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tatuador_estilo`
--

CREATE TABLE `tatuador_estilo` (
  `idtatuador` int(11) NOT NULL,
  `idestilo` int(11) NOT NULL,
  `dataestilo` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `tatuador_estilo`
--

INSERT INTO `tatuador_estilo` (`idtatuador`, `idestilo`, `dataestilo`) VALUES
(1, 1, '2026-10-09'),
(1, 2, '2026-10-09'),
(1, 3, '2026-10-09'),
(2, 2, '2022-06-15'),
(3, 4, '2024-01-10'),
(4, 4, '2026-10-19'),
(6, 1, '2026-10-19'),
(6, 2, '2026-10-19'),
(7, 5, '2026-10-19'),
(7, 9, '2026-10-19'),
(7, 10, '2026-10-19'),
(8, 1, '2026-10-19'),
(8, 4, '2026-10-19'),
(8, 5, '2026-10-19'),
(8, 9, '2026-10-19'),
(9, 6, '2026-10-19'),
(9, 10, '2026-10-19'),
(9, 16, '2026-10-19'),
(10, 2, '2026-10-21'),
(10, 3, '2026-10-21'),
(10, 4, '2026-10-21'),
(10, 17, '2026-10-21');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo` enum('admin','funcionario','cliente') NOT NULL DEFAULT 'funcionario',
  `idcliente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`idusuario`, `nome`, `email`, `senha`, `tipo`, `idcliente`) VALUES
(1, 'addie', 'addielarue@gmail.com', '$2b$12$btrktkxBD.GCBIBxs0lUEent7kU9ql8ElVXnzRA8vZdzcjLddc4Eq', 'funcionario', NULL),
(3, 'Anna Loise', 'loiseanna@gmail.com', '$2b$12$6EvCNwq.dY8TVOMdj62xMuALi0p.88iEd45J8woIQJ/0dMbIWIxuO', 'funcionario', NULL),
(4, 'monica', 'monicag@gmail.com', '$2b$12$.NCDH7ZTMamHVqD8L50/yet3iOzERMhN0H94ubuzYyHgh.pdrUDIW', 'funcionario', NULL),
(7, 'mariane', 'marianecampos@gmail.com', '$2b$12$GUmKNCWy6Gg5.pMkLtSFWucFuNJc.vALJ76EWS4ykT5Nf0C1mbhr2', 'funcionario', NULL),
(12, 'eduarda', 'eduardamendes322@gmail.com', '$2b$12$sItMsABMbcLfNf2F5IeezenyzqdflOeL03LYLeHmsPnsOvP.gkqJy', 'funcionario', NULL),
(13, 'Administrador', 'admin@estudio.com', '$2b$12$UTEjRaoW7c6QNv.TZrKP2uyTi5vWbujsxBvQusZ5QKZrWh7dwbRzi', 'admin', NULL),
(15, 'guilherme', 'guilherme@gmail.com', '$2b$12$atBdrrfubLd7a1XLUDk7Sups8f81lf1.lxvBX7lwqvnRPGmhqd5dS', 'funcionario', NULL),
(16, 'joe', 'joe@gmail.com', '$2b$12$PJpPcdCuKvp7Hgz0K9dgBOCSQr7jq8yHTeGNimXYtjYae0zp/Nc5C', 'funcionario', NULL),
(17, 'Giovani Rocha', 'girocha@estudio.com', '$2b$12$Sf/jFgtr2hlJWJ3QO/DrU.MP58A8wTjBkak29coHYeyqorzEFChgy', 'funcionario', NULL),
(18, 'João Gomes', 'joaogomes@gmail.com', '$2b$12$KO76v7ezFxhhlLGc1btnuuKcWsX0oEf0/XO9qOEFlq.eqq7jpySOa', 'funcionario', NULL);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `agendamento`
--
ALTER TABLE `agendamento`
  ADD PRIMARY KEY (`idagendamento`),
  ADD KEY `idcliente` (`idcliente`),
  ADD KEY `idtatuador` (`idtatuador`);

--
-- Índices para tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idcliente`),
  ADD UNIQUE KEY `cpf` (`cpf`);

--
-- Índices para tabela `estilo`
--
ALTER TABLE `estilo`
  ADD PRIMARY KEY (`idestilo`);

--
-- Índices para tabela `senioridade`
--
ALTER TABLE `senioridade`
  ADD PRIMARY KEY (`idsenioridade`);

--
-- Índices para tabela `tatuador`
--
ALTER TABLE `tatuador`
  ADD PRIMARY KEY (`idtatuador`),
  ADD UNIQUE KEY `cpf` (`cpf`),
  ADD KEY `idsenioridade` (`idsenioridade`);

--
-- Índices para tabela `tatuador_estilo`
--
ALTER TABLE `tatuador_estilo`
  ADD PRIMARY KEY (`idtatuador`,`idestilo`),
  ADD KEY `idestilo` (`idestilo`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idcliente` (`idcliente`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agendamento`
--
ALTER TABLE `agendamento`
  MODIFY `idagendamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `estilo`
--
ALTER TABLE `estilo`
  MODIFY `idestilo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `senioridade`
--
ALTER TABLE `senioridade`
  MODIFY `idsenioridade` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `tatuador`
--
ALTER TABLE `tatuador`
  MODIFY `idtatuador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `agendamento`
--
ALTER TABLE `agendamento`
  ADD CONSTRAINT `agendamento_ibfk_1` FOREIGN KEY (`idcliente`) REFERENCES `cliente` (`idcliente`),
  ADD CONSTRAINT `agendamento_ibfk_2` FOREIGN KEY (`idtatuador`) REFERENCES `tatuador` (`idtatuador`);

--
-- Limitadores para a tabela `tatuador`
--
ALTER TABLE `tatuador`
  ADD CONSTRAINT `tatuador_ibfk_1` FOREIGN KEY (`idsenioridade`) REFERENCES `senioridade` (`idsenioridade`);

--
-- Limitadores para a tabela `tatuador_estilo`
--
ALTER TABLE `tatuador_estilo`
  ADD CONSTRAINT `tatuador_estilo_ibfk_1` FOREIGN KEY (`idtatuador`) REFERENCES `tatuador` (`idtatuador`),
  ADD CONSTRAINT `tatuador_estilo_ibfk_2` FOREIGN KEY (`idestilo`) REFERENCES `estilo` (`idestilo`);

--
-- Limitadores para a tabela `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idcliente`) REFERENCES `cliente` (`idcliente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
