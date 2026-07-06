-- Script de création de la base de données du projet
-- Basé sur le MCD : UTILISATEUR, ARTISTE, AVIS, SUIVI

CREATE DATABASE IF NOT EXISTS projet_slam CHARACTER SET utf8mb4;
USE projet_slam;

-- ------------------------------------------------------
-- Table UTILISATEUR
-- ------------------------------------------------------
CREATE TABLE utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pseudo VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------
-- Table ARTISTE
-- statut : 'valide' (visible publiquement) ou 'en_attente' (suggestion à valider par l'admin)
-- propose_par : utilisateur qui a suggéré l'artiste (NULL si ajouté directement par l'admin)
-- ------------------------------------------------------
CREATE TABLE artiste (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    lien_reseau VARCHAR(255),
    statut ENUM('valide', 'en_attente') DEFAULT 'en_attente',
    propose_par INT NULL,
    date_ajout DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (propose_par) REFERENCES utilisateur(id) ON DELETE SET NULL
);

-- ------------------------------------------------------
-- Table AVIS
-- note : entre 1 et 5 (système d'étoiles)
-- un utilisateur ne peut laisser qu'un seul avis par artiste (contrainte unique)
-- ------------------------------------------------------
CREATE TABLE avis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    artiste_id INT NOT NULL,
    note TINYINT NOT NULL CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (artiste_id) REFERENCES artiste(id) ON DELETE CASCADE,
    UNIQUE (user_id, artiste_id)
);

-- ------------------------------------------------------
-- Table SUIVI (table de liaison many-to-many : un utilisateur suit un artiste)
-- ------------------------------------------------------
CREATE TABLE suivi (
    user_id INT NOT NULL,
    artiste_id INT NOT NULL,
    date_suivi DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, artiste_id),
    FOREIGN KEY (user_id) REFERENCES utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (artiste_id) REFERENCES artiste(id) ON DELETE CASCADE
);

-- ------------------------------------------------------
-- Quelques données de test (optionnel, pratique pour développer sans tout recréer à la main)
-- ------------------------------------------------------
INSERT INTO utilisateur (pseudo, email, mot_de_passe) VALUES
('Maria', 'maria@test.com', '$2y$10$exempledehashagenerepasavecpasswordhash'),
('Steven', 'steven@test.com', '$2y$10$exempledehashagenerepasavecpasswordhash');

INSERT INTO artiste (nom, description, lien_reseau, statut) VALUES
('KornArt', 'Artiste spécialisé dans les décors 2D stylisés.', 'https://instagram.com/kornart', 'valide'),
('Guweizz', 'Illustrateur de personnages, style semi-réaliste.', 'https://twitter.com/guweizz', 'valide'),
('Datcravat', 'Character design et concept art.', 'https://artstation.com/datcravat', 'valide'),
('SamDoesArt', 'Illustrations colorées et dynamiques.', 'https://instagram.com/samdoesart', 'valide');