CREATE TABLE page (
  page_id int(11) NOT NULL,
  page_title text COLLATE utf8_general_ci,
  text_id int(11) DEFAULT NULL,
  PRIMARY KEY (page_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE text (
  page_id int(11) NOT NULL,
  content text COLLATE utf8_general_ci,
  text_id int(11) NOT NULL,
  PRIMARY KEY (text_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE schema_migrations (
  version varchar(255) NOT NULL,
  UNIQUE KEY unique_schema_migrations (version)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

