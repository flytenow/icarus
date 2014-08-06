DROP TABLE IF EXISTS `events-faa`;
CREATE TABLE `events-faa` (
  `report-number` VARCHAR(16) NOT NULL UNIQUE,
  `date` VARCHAR(10) DEFAULT NULL,
  `city` VARCHAR(32) DEFAULT NULL,
  `state` VARCHAR(2) DEFAULT NULL,
  `airport` VARCHAR(64) DEFAULT NULL,
  `event-type` VARCHAR(16) DEFAULT NULL,
  `aircraft-damage` VARCHAR(32) DEFAULT NULL,
  `flight-phase` VARCHAR(128) DEFAULT NULL,
  `aircraft-make` VARCHAR(64) DEFAULT NULL,
  `aircraft-model` VARCHAR(64) DEFAULT NULL,
  `aircraft-series` VARCHAR(64) DEFAULT NULL,
  `operator` VARCHAR(128) DEFAULT NULL,
  `primary-flight-type` VARCHAR(128) DEFAULT NULL,
  `flight-conduct-code` VARCHAR(64) DEFAULT NULL,
  `flight-plan-filed-code` VARCHAR(64) DEFAULT NULL,
  `aircraft-reg-number` VARCHAR(6) DEFAULT NULL,
  `fatalities` INT DEFAULT NULL,
  `injuries` INT DEFAULT NULL,
  `engine-make` VARCHAR(10) DEFAULT NULL,
  `engine-model` VARCHAR(32) DEFAULT NULL,
  `engine-group-code` VARCHAR(10) DEFAULT NULL,
  `engine-count` INT DEFAULT NULL,
  `pilot-certification` VARCHAR(64) DEFAULT NULL,
  `pilot-total-hours` INT DEFAULT NULL,
  `pilot-make-model-hours` INT DEFAULT NULL,
  PRIMARY KEY (`report-number`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;

LOAD DATA INFILE '/tmp/faa.txt' INTO TABLE `events-faa` 
  FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' 
  IGNORE 1 LINES
  (`asdf`)
  SET
    `report-number` = TRIM(NULLIF(@reportNumber, '')),
    `date` = TRIM(NULLIF(@date, '')),
    `city` = TRIM(NULLIF(@city, '')),
    `state` = TRIM(NULLIF(@state, '')),
    `airport` = TRIM(NULLIF(@airport, '')),
    `event-type` = TRIM(NULLIF(@eventType, '')),
    `aircraft-damage` = TRIM(NULLIF(@aircraftDamage, '')),
    `flight-phase` = TRIM(NULLIF(@flightPhase), ''),
    `aircraft-make` = TRIM(NULLIF(@aircraftMake, ''),


DROP TABLE IF EXISTS `events-ntsb`;
CREATE TABLE `events-ntsb` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `event-id` VARCHAR(16) NOT NULL,
  `investigation-type` VARCHAR(10) NOT NULL,
  `accident-number` VARCHAR(16) NOT NULL,
  `event-date` VARCHAR(10) DEFAULT NULL,
  `location` VARCHAR(128) DEFAULT NULL,
  `country` VARCHAR(64) DEFAULT NULL,
  `latitude` VARCHAR(16) DEFAULT NULL,
  `longitude` VARCHAR(16) DEFAULT NULL,
  `airport-code` VARCHAR(6) DEFAULT NULL,
  `airport-name` VARCHAR(64) DEFAULT NULL,
  `injury-severity` VARCHAR(16) DEFAULT NULL,
  `aircraft-damage` VARCHAR(32) DEFAULT NULL,
  `aircraft-category` VARCHAR(16) DEFAULT NULL,
  `aircraft-reg-number` VARCHAR(16) DEFAULT NULL,
  `aircraft-make` VARCHAR(64) DEFAULT NULL,
  `aircraft-model` VARCHAR(32) DEFAULT NULL,
  `amateur-built` VARCHAR(3) DEFAULT NULL,
  `engine-count` INT DEFAULT NULL,
  `engine-type` VARCHAR(32) DEFAULT NULL,
  `far-desc` VARCHAR(64) DEFAULT NULL,
  `schedule` VARCHAR(4) DEFAULT NULL,
  `flight-purpose` VARCHAR(64) DEFAULT NULL,
  `air-carrier` VARCHAR(128) DEFAULT NULL,
  `injuries-fatal` INT DEFAULT NULL,
  `injuries-serious` INT DEFAULT NULL,
  `injuries-minor` INT DEFAULT NULL,
  `uninjured` INT DEFAULT NULL,
  `weather-conditions` VARCHAR(3) DEFAULT NULL,
  `broad-flight-phase` VARCHAR(32) DEFAULT NULL,
  `report-status` VARCHAR(32) NOT NULL,
  `publication-date` VARCHAR(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;

ALTER TABLE `events-ntsb` AUTO_INCREMENT = 1;
LOAD DATA INFILE '/tmp/ntsb.txt' INTO TABLE `events-ntsb`
  FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n' IGNORE 1 LINES
  (@eventId, @investigationType, @accidentNumber, @eventDate, @location, @country, @latitude, @longitude,
   @airportCode, @airportName, @injurySeverity, @aircraftDamage, @aircraftCategory, @aircraftRegNumber,
   @aircraftMake, @aircraftModel, @amateurBuilt, @engineCount, @engineType, @farDesc, @schedule,
   @flightPurpose, @airCarrier, @injuriesFatal, @injuriesSerious, @injuriesMinor, @uninjured,
   @weatherConditions, @broadFlightPhase, @reportStatus, @publicationDate)
  SET
    `event-id` = TRIM(NULLIF(@eventId, '')),
    `investigation-type` = TRIM(NULLIF(@investigationType, '')),
    `accident-number` = TRIM(NULLIF(@accidentNumber, '')),
    `event-date` = TRIM(NULLIF(@eventDate, '')),
    `location` = TRIM(NULLIF(@location, '')),
    `country` = TRIM(NULLIF(@country, '')),
    `latitude` = TRIM(NULLIF(@latitude, '')),
    `longitude` = TRIM(NULLIF(@longitude, '')),
    `airport-code` = TRIM(NULLIF(@airportCode, '')),
    `airport-name` = TRIM(NULLIF(@airportName, '')),
    `injury-severity` = TRIM(NULLIF(@injurySeverity, '')),
    `aircraft-damage` = TRIM(NULLIF(@aircraftDamage, '')),
    `aircraft-category` = TRIM(NULLIF(@aircraftCategory, '')),
    `aircraft-reg-number` = TRIM(NULLIF(@aircraftRegNumber, '')),
    `aircraft-make` = TRIM(NULLIF(@aircraftMake, '')),
    `aircraft-model` = TRIM(NULLIF(@aircraftModel, '')),
    `amateur-built` = TRIM(NULLIF(@amateurBuilt, '')),
    `engine-count` = TRIM(NULLIF(@engineCount, '')),
    `engine-type` = TRIM(NULLIF(@engineType, '')),
    `far-desc` = TRIM(NULLIF(@farDesc, '')),
    `schedule` = TRIM(NULLIF(@schedule, '')),
    `flight-purpose` = TRIM(NULLIF(@flightPurpose, '')),
    `air-carrier` = TRIM(NULLIF(@airCarrier, '')),
    `injuries-fatal` = TRIM(NULLIF(@injuriesFatal, '')),
    `injuries-serious` = TRIM(NULLIF(@injuriesSerious, '')),
    `injuries-minor` = TRIM(NULLIF(@injuriesMinor, '')),
    `uninjured` = TRIM(NULLIF(@uninjured, '')),
    `weather-conditions` = TRIM(NULLIF(@weatherConditions, '')),
    `broad-flight-phase` = TRIM(NULLIF(@broadFlightPhase, '')),
    `report-status` = TRIM(NULLIF(@reportStatus, '')),
    `publication-date` = TRIM(NULLIF(@publicationDate, ''));

