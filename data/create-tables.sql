# Returns a word with the first letter capitalized.
DROP FUNCTION IF EXISTS WordCase;
DELIMITER $$
CREATE FUNCTION WordCase(string VARCHAR(255)) RETURNS VARCHAR(255)
  DETERMINISTIC
BEGIN
  DECLARE result VARCHAR(255);
  SET result = CONCAT(UCASE(LEFT(TRIM(NULLIF(string, '')), 1)), LCASE(SUBSTRING(TRIM(NULLIF(string, '')), 2)));
  RETURN result;
END;
$$
DELIMITER ;

# Create FAA events table and import data.
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

# Create NTSB table and import data.
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

# Create events table.
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

# Copy FAA data into events table.
INSERT INTO `events`
  (`source`, `investigation-type`, `report-status`, `date`, `city`, `state`, `airport-name`, `airport-code`,
   `latitude`, `longitude`, `fatalities`, `injuries`, `uninjured`, `aircraft-reg-number`, `aircraft-category`, 
   `aircraft-make`, `aircraft-model`, `aircraft-series`, `amateur-built`, `engine-count`, `engine-type`,
   `aircraft-damage`, `operator`, `far-desc`, `pilot-certification`, `pilot-total-hours`, `pilot-make-model-hours`, 
   `flight-phase`, `flight-type`, `flight-plan-filed-code`, `weather-conditions`)
  SELECT 'FAA', # source
         UCASE(`event-type`), # investigation-type 
         NULL, # report-status
         `date`, # date
         WordCase(`city`), # city
         UCASE(`state`), # state
         WordCase(`airport`), # airport-name
         NULL, # airport-code
         NULL, # latitude
         NULL, # longitude
         `fatalities`, # fatalities
         `injuries`, # injuries
         NULL, # uninjured
         UCASE(`aircraft-reg-number`), # aircraft-reg-number
         NULL, # aircraft-category
         WordCase(`aircraft-make`), # aircraft-make 
         UCASE(`aircraft-model`), # aircraft-model
         UCASE(`aircraft-series`), # aircraft-series
         NULL, # amatuer-built
         `engine-count`, # engine-count
         NULL, # engine-type
         UCASE(`aircraft-damage`), # aircraft-damage
         WordCase(`operator`), # operator
         UCASE(`flight-conduct-code`), # far-desc
         UCASE(`pilot-certification`), # pilot-certification
         `pilot-total-hours`, # pilot-total-hours
         `pilot-make-model-hours`, # pilot-make-model-hours
         WordCase(`flight-phase`), # flight-phase
         UCASE(`primary-flight-type`), # flight-type
         UCASE(`flight-plan-filed-code`), # flight-plan-filed-code
         NULL # weather-conditions
    FROM `events-faa`
    ORDER BY `report-number` ASC;

# Copy NTSB data into events table.
INSERT INTO `events`
  (`source`, `investigation-type`, `report-status`, `date`, `city`, `state`, `airport-name`, `airport-code`,
   `latitude`, `longitude`, `fatalities`, `injuries`, `uninjured`, `aircraft-reg-number`, `aircraft-category`, 
   `aircraft-make`, `aircraft-model`, `aircraft-series`, `amateur-built`, `engine-count`, `engine-type`,
   `aircraft-damage`, `operator`, `far-desc`, `pilot-certification`, `pilot-total-hours`, `pilot-make-model-hours`, 
   `flight-phase`, `flight-type`, `flight-plan-filed-code`, `weather-conditions`)
  SELECT 'NTSB', # source
         UCASE(`investigation-type`), # investigation-type
         UCASE(`report-status`), # report-status
         `event-date`, # date
         NULL, # city
         NULL, # state
         WordCase(`airport-name`), # airport-name
         UCASE(`airport-code`), # airport-code
         `latitude`, # latitude
         `longitude`, # longitude
         `injuries-fatal`, # fatalities
         (`injuries-serious` + `injuries-minor`), # injuries
         `uninjured`, # uninjured
         UCASE(`aircraft-reg-number`), # aircraft-reg-number
         WordCase(`aircraft-category`), # aircraft-category
         WordCase(`aircraft-make`), # aircraft-make
         UCASE(`aircraft-model`), # aircraft-model
         NULL, # aircraft-series
         UCASE(`amateur-built`), # amateur-built 
         `engine-count`, # engine-count
         WordCase(`engine-type`), # engine-type
         UCASE(`aircraft-damage`), # aircraft-damage
         WordCase(`air-carrier`), # operator
         UCASE(`far-desc`), # far-desc
         NULL, # pilot-certification
         NULL, # pilot-total-hours
         NULL, # pilot-make-model-hours
         WordCase(`broad-flight-phase`), # flight-phase
         UCASE(`flight-purpose`), # flight-type
         NULL, # flight-plan-filed-code
         UCASE(`weather-conditions`) # weather-conditions
    FROM `events-ntsb`
    ORDER BY `id` ASC;
