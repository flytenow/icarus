# FAA
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
  (@reportNumber, @date, @city, @state, @airport, @eventType, @aircraftDamage, @flightPhase, @aircraftMake,
   @aircraftModel, @aircraftSeries, @operator, @primaryFlightType, @flightConductCode, @flightPlanFiledCode,
   @aircraftRegNumber, @fatalities, @injuries, @engineMake, @engineModel, @engineGroupCode, @engineCount,
   @pilotCertification, @pilotTotalHours, @pilotMakeModelHours)
  SET
    `report-number` = TRIM(NULLIF(@reportNumber, '')),
    `date` = DATE_FORMAT(STR_TO_DATE(CONCAT(UCASE(LEFT(TRIM(NULLIF(@date, '')), 4)), LCASE(SUBSTRING(TRIM(NULLIF(@date, '')), 5))), '%d-%b-%y'), '%Y-%m-%d'),
    `city` = TRIM(NULLIF(@city, '')),
    `state` = TRIM(NULLIF(@state, '')),
    `airport` = TRIM(NULLIF(@airport, '')),
    `event-type` = TRIM(NULLIF(@eventType, '')),
    `aircraft-damage` = TRIM(NULLIF(@aircraftDamage, '')),
    `flight-phase` = TRIM(NULLIF(@flightPhase, '')),
    `aircraft-make` = TRIM(NULLIF(@aircraftMake, '')),
    `aircraft-model` = TRIM(NULLIF(@aircraftModel, '')),
    `aircraft-series` = TRIM(NULLIF(@aircraftSeries, '')),
    `operator` = TRIM(NULLIF(@operator, '')),
    `primary-flight-type` = TRIM(NULLIF(@primaryFlightType, '')),
    `flight-conduct-code` = TRIM(NULLIF(@flightConductCode, '')),
    `flight-plan-filed-code` = TRIM(NULLIF(@flightPlanFiledCode, '')),
    `aircraft-reg-number` = CONCAT('N', TRIM(NULLIF(@aircraftRegNumber, ''))),
    `fatalities` = TRIM(NULLIF(@fatalities, '')),
    `injuries` = TRIM(NULLIF(@injuries, '')),
    `engine-make` = TRIM(NULLIF(@engineMake, '')),
    `engine-model` = TRIM(NULLIF(@engineModel, '')),
    `engine-group-code` = TRIM(NULLIF(@engineGroupCode, '')),
    `engine-count` = TRIM(NULLIF(@engineCount, '')),
    `pilot-certification` = TRIM(NULLIF(@pilotCertification, '')),
    `pilot-total-hours` = TRIM(NULLIF(@pilotTotalHours, '')),
    `pilot-make-model-hours` = TRIM(NULLIF(@pilotMakeModelHours, ''));

# NTSB
DROP TABLE IF EXISTS `events-ntsb`;
CREATE TABLE `events-ntsb` (
  `id` INT NOT NULL AUTO_INCREMENT UNIQUE,
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
    `event-date` = DATE_FORMAT(STR_TO_DATE(TRIM(NULLIF(@eventDate, '')), '%m/%d/%Y'), '%Y-%m-%d'),
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

# EVENTS
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `source` VARCHAR(4) NOT NULL,
  `investigation-type` VARCHAR(10) NOT NULL,
  `report-status` VARCHAR(32) NOT NULL,
  `date` VARCHAR(10) DEFAULT NULL,
  `city` VARCHAR(32) DEFAULT NULL,
  `state` VARCHAR(2) DEFAULT NULL,
  `airport-name` VARCHAR(64) DEFAULT NULL,
  `airport-code` VARCHAR(6) DEFAULT NULL,
  `latitude` VARCHAR(16) DEFAULT NULL,
  `longitude` VARCHAR(16) DEFAULT NULL,
  `fatalities` INT DEFAULT NULL,
  `injuries` INT DEFAULT NULL,
  `uninjured` INT DEFAULT NULL,
  `aircraft-reg-number` VARCHAR(16) DEFAULT NULL,
  `aircraft-category` VARCHAR(16) DEFAULT NULL,
  `aircraft-make` VARCHAR(64) DEFAULT NULL,
  `aircraft-model` VARCHAR(64) DEFAULT NULL,
  `aircraft-series` VARCHAR(64) DEFAULT NULL,
  `amateur-built` VARCHAR(3) DEFAULT NULL,
  `engine-count` INT DEFAULT NULL,
  `engine-type` VARCHAR(32) DEFAULT NULL,
  `aircraft-damage` VARCHAR(32) DEFAULT NULL,
  `operator` VARCHAR(128) DEFAULT NULL,
  `far-desc` VARCHAR(64) DEFAULT NULL,
  `pilot-certification` VARCHAR(64) DEFAULT NULL,
  `pilot-total-hours` INT DEFAULT NULL,
  `pilot-make-model-hours` INT DEFAULT NULL,
  `flight-phase` VARCHAR(128) DEFAULT NULL,
  `flight-type` VARCHAR(128) DEFAULT NULL,
  `flight-plan-filed-code` VARCHAR(64) DEFAULT NULL,
  `weather-conditions` VARCHAR(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;

# FAA
INSERT INTO `events`
  (`source`, `investigation-type`, `report-status`, `date`, `city`, `state`, `airport-name`, `airport-code`,
   `latitude`, `longitude`, `fatalities`, `injuries`, `uninjured`, `aircraft-reg-number`, `aircraft-category`, 
   `aircraft-make`, `aircraft-model`, `aircraft-series`, `amateur-built`, `engine-count`, `engine-type`,
   `aircraft-damage`, `operator`, `far-desc`, `pilot-certification`, `pilot-total-hours`, `pilot-make-model-hours`, 
   `flight-phase`, `flight-type`, `flight-plan-filed-code`, `weather-conditions`)
  SELECT 'FAA', `event-type`, NULL, `date`, `city`, `state`, `airport`, NULL, NULL, NULL, `fatalities`,
         `injuries`, NULL, `aircraft-reg-number`, NULL, `aircraft-make`, `aircraft-model`, `aircraft-series`, 
         NULL, `engine-count`, NULL, `aircraft-damage`, `operator`, `flight-conduct-code`, `pilot-certification`, 
         `pilot-total-hours`, `pilot-make-model-hours`, `flight-phase`, `primary-flight-type`,
         `flight-plan-filed-code`, NULL
    FROM `events-faa`
    ORDER BY `report-number` ASC;

#NTSB
INSERT INTO `events`
  (`source`, `investigation-type`, `report-status`, `date`, `city`, `state`, `airport-name`, `airport-code`,
   `latitude`, `longitude`, `fatalities`, `injuries`, `uninjured`, `aircraft-reg-number`, `aircraft-category`, 
   `aircraft-make`, `aircraft-model`, `aircraft-series`, `amateur-built`, `engine-count`, `engine-type`,
   `aircraft-damage`, `operator`, `far-desc`, `pilot-certification`, `pilot-total-hours`, `pilot-make-model-hours`, 
   `flight-phase`, `flight-type`, `flight-plan-filed-code`, `weather-conditions`)
  SELECT 'NTSB', `investigation-type`, `report-status`, `event-date`, NULL, NULL, `airport-name`, `airport-code`,
        `latitude`, `longitude`, `injuries-fatal`, NULL, `uninjured`, `aircraft-reg-number`, `aircraft-category`, 
        `aircraft-make`, `aircraft-model`, NULL, `amateur-built`, `engine-count`, `engine-type`, `aircraft-damage`,
        `air-carrier`, `far-desc`, NULL, NULL,NULL , `broad-flight-phase`, `flight-purpose`, NULL, `weather-conditions`
    FROM `events-ntsb`
    ORDER BY `id` ASC;
