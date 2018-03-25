CREATE TABLE time_seq (
   id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
   unit_id      INT NOT NULL,
   device_id    INT NOT NULL,
   data         DECIMAL(10,3) NOT NULL,
   created      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY  (id)
)
