INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_gouvernement', 'Gouvernement', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_gouvernement', 'Gouvernement', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_gouvernement', 'Gouvernement', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('gouvernement','Gouvernement')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('gouvernement',0,'recruit','Recrue',20,'{}','{}'),
	('gouvernement',1,'officer','Experimente',40,'{}','{}'),
	('gouvernement',2,'sergeant','Chef de la sécuriter',60,'{}','{}'),
	('gouvernement',3,'lieutenant','Secretiaire',85,'{}','{}'),
	('gouvernement',4,'juge','Juge',100,'{}','{}'),
    ('gouvernement',5,'mini','Ministre',100,'{}','{}'),
    ('gouvernement',6,'vpresi','Vice-President',100,'{}','{}'),
    ('gouvernement',7,'boss','President',100,'{}','{}')
      
;
