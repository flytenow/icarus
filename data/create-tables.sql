# Returns a word with the first letter capitalized.
DROP FUNCTION IF EXISTS WordCase;
DELIMITER $$
CREATE FUNCTION WordCase(input VARCHAR(255)) RETURNS VARCHAR(255) DETERMINISTIC
  BEGIN
    DECLARE length INT;
    DECLARE iter INT;

    SET length = CHAR_LENGTH(input);
    SET input = LOWER(input);
    SET iter = 0;

    WHILE (iter < length) DO
      IF (MID(input, iter, 1) = ' ' OR MID(input, iter, 1) = '-' OR iter = 0) THEN
        IF (iter < length) THEN
          SET input = CONCAT(
              LEFT(input, iter),
              UPPER(MID(input, iter + 1, 1)),
              RIGHT(input, length - iter - 1)
          );
        END IF;
      END IF;
      SET iter = iter + 1;
    END WHILE;

    RETURN input;
  END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS ChooseBetter;
DELIMITER $$
CREATE FUNCTION ChooseBetter(`left` VARCHAR(255), `right` VARCHAR(255)) RETURNS VARCHAR(255) DETERMINISTIC
  BEGIN
    IF `left` IS NULL THEN
      IF `right` IS NULL THEN
        RETURN NULL;
      ELSE
        RETURN `right`;
      END IF;
    ELSE
      IF `right` IS NULL THEN
        RETURN `left`;
      ELSE
        RETURN IF(CHAR_LENGTH(`left`) > CHAR_LENGTH(`right`), `left`, `right`);
      END IF;
    END IF;
  END;
$$
DELIMITER ;

# Attempts to merge duplicate entries.
DROP PROCEDURE IF EXISTS MergeEvents;
DELIMITER $$
CREATE PROCEDURE MergeEvents() DETERMINISTIC
  BEGIN
    DECLARE v_finished INT DEFAULT 0;
    DECLARE `left` INT DEFAULT 0;
    DECLARE `right` INT DEFAULT 0;
    DECLARE count INT DEFAULT 0;

    DECLARE dupCursor CURSOR FOR
      SELECT e.id, temp.id FROM events e
        INNER JOIN (
                     SELECT `id`, `aircraft-reg-number`, date, COUNT(*)
                     FROM events
                     GROUP BY `aircraft-reg-number`, date
                     HAVING COUNT(*) > 1) temp
          ON temp.`aircraft-reg-number` = e.`aircraft-reg-number` AND temp.date = e.date
      WHERE e.id <> temp.id
      ORDER BY e.`aircraft-reg-number`, e.date;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

    OPEN dupCursor;

    processDup: LOOP
      FETCH dupCursor INTO `left`, `right`;

      IF v_finished = 1 THEN
        LEAVE processDup;
      END IF;

      SET @investigationType = ChooseBetter((SELECT `investigation-type` FROM events WHERE `id` = `left`),
                                            (SELECT `investigation-type` FROM events WHERE `id` = `right`));
      SET @reportStatus = ChooseBetter((SELECT `report-status` FROM events WHERE `id` = `left`),
                                       (SELECT `report-status` FROM events WHERE `id` = `right`));
      SET @date = ChooseBetter((SELECT `date` FROM events WHERE `id` = `left`),
                               (SELECT `date` FROM events WHERE `id` = `right`));
      SET @city = ChooseBetter((SELECT `city` FROM events WHERE `id` = `left`),
                               (SELECT `city` FROM events WHERE `id` = `right`));
      SET @state = ChooseBetter((SELECT `state` FROM events WHERE `id` = `left`),
                                (SELECT `state` FROM events WHERE `id` = `right`));
      SET @airportName = ChooseBetter((SELECT `airport-name` FROM events WHERE `id` = `left`),
                                      (SELECT `airport-name` FROM events WHERE `id` = `right`));
      SET @airportCode = ChooseBetter((SELECT `airport-code` FROM events WHERE `id` = `left`),
                                      (SELECT `airport-code` FROM events WHERE `id` = `right`));
      SET @latitude = ChooseBetter((SELECT `latitude` FROM events WHERE `id` = `left`),
                                   (SELECT `latitude` FROM events WHERE `id` = `right`));
      SET @longitude = ChooseBetter((SELECT `longitude` FROM events WHERE `id` = `left`),
                                    (SELECT `longitude` FROM events WHERE `id` = `right`));
      SET @fatalities = ChooseBetter((SELECT `fatalities` FROM events WHERE `id` = `left`),
                                     (SELECT `fatalities` FROM events WHERE `id` = `right`));
      SET @injuries = ChooseBetter((SELECT `injuries` FROM events WHERE `id` = `left`),
                                   (SELECT `injuries` FROM events WHERE `id` = `right`));
      SET @uninjured = ChooseBetter((SELECT `uninjured` FROM events WHERE `id` = `left`),
                                    (SELECT `uninjured` FROM events WHERE `id` = `right`));
      SET @aircraftRegNumber = ChooseBetter((SELECT `aircraft-reg-number` FROM events WHERE `id` = `left`),
                                            (SELECT `aircraft-reg-number` FROM events WHERE `id` = `right`));
      SET @aircraftCategory = ChooseBetter((SELECT `aircraft-category` FROM events WHERE `id` = `left`),
                                           (SELECT `aircraft-category` FROM events WHERE `id` = `right`));
      SET @aircraftMake = ChooseBetter((SELECT `aircraft-make` FROM events WHERE `id` = `left`),
                                       (SELECT `aircraft-make` FROM events WHERE `id` = `right`));
      SET @aircraftModel = ChooseBetter((SELECT `aircraft-model` FROM events WHERE `id` = `left`),
                                        (SELECT `aircraft-model` FROM events WHERE `id` = `right`));
      SET @aircraftSeries = ChooseBetter((SELECT `aircraft-series` FROM events WHERE `id` = `left`),
                                         (SELECT `aircraft-series` FROM events WHERE `id` = `right`));
      SET @amateurBuilt = ChooseBetter((SELECT `amateur-built` FROM events WHERE `id` = `left`),
                                       (SELECT `amateur-built` FROM events WHERE `id` = `right`));
      SET @engineCount = ChooseBetter((SELECT `engine-count` FROM events WHERE `id` = `left`),
                                      (SELECT `engine-count` FROM events WHERE `id` = `right`));
      SET @engineType = ChooseBetter((SELECT `engine-type` FROM events WHERE `id` = `left`),
                                     (SELECT `engine-type` FROM events WHERE `id` = `right`));
      SET @aircraftDamage = ChooseBetter((SELECT `aircraft-damage` FROM events WHERE `id` = `left`),
                                         (SELECT `aircraft-damage` FROM events WHERE `id` = `right`));
      SET @operator = ChooseBetter((SELECT `operator` FROM events WHERE `id` = `left`),
                                   (SELECT `operator` FROM events WHERE `id` = `right`));
      SET @farDesc = ChooseBetter((SELECT `far-desc` FROM events WHERE `id` = `left`),
                                  (SELECT `far-desc` FROM events WHERE `id` = `right`));
      SET @pilotCertification = ChooseBetter((SELECT `pilot-certification` FROM events WHERE `id` = `left`),
                                             (SELECT `pilot-certification` FROM events WHERE `id` = `right`));
      SET @pilotTotalHours = ChooseBetter((SELECT `pilot-total-hours` FROM events WHERE `id` = `left`),
                                          (SELECT `pilot-total-hours` FROM events WHERE `id` = `right`));
      SET @pilotMakeModelHours = ChooseBetter((SELECT `pilot-make-model-hours` FROM events WHERE `id` = `left`),
                                              (SELECT `pilot-make-model-hours` FROM events WHERE `id` = `right`));
      SET @flightPhase = ChooseBetter((SELECT `flight-phase` FROM events WHERE `id` = `left`),
                                      (SELECT `flight-phase` FROM events WHERE `id` = `right`));
      SET @flightType = ChooseBetter((SELECT `flight-type` FROM events WHERE `id` = `left`),
                                     (SELECT `flight-type` FROM events WHERE `id` = `right`));
      SET @flightPlanFiledCode = ChooseBetter((SELECT `flight-plan-filed-code` FROM events WHERE `id` = `left`),
                                              (SELECT `flight-plan-filed-code` FROM events WHERE `id` = `right`));
      SET @weatherConditions = ChooseBetter((SELECT `weather-conditions` FROM events WHERE `id` = `left`),
                                            (SELECT `weather-conditions` FROM events WHERE `id` = `right`));

      INSERT INTO `events`
      (`source`, `investigation-type`, `report-status`, `date`, `city`, `state`, `airport-name`,
       `airport-code`, `latitude`, `longitude`, `fatalities`, `injuries`, `uninjured`, `aircraft-reg-number`,
       `aircraft-category`, `aircraft-make`, `aircraft-model`, `aircraft-series`, `amateur-built`,
       `engine-count`, `engine-type`, `aircraft-damage`, `operator`, `far-desc`, `pilot-certification`,
       `pilot-total-hours`, `pilot-make-model-hours`, `flight-phase`, `flight-type`, `flight-plan-filed-code`,
       `weather-conditions`)
      VALUES ('BOTH', @investigationType, @reportStatus, @date, @city, @state, @airportName, @airportCode, @latitude,
              @longitude, @fatalities, @injuries, @uninjured, @aircraftRegNumber, @aircraftCategory, @aircraftMake,
              @aircraftModel, @aircraftSeries, @amateurBuilt, @engineCount, @engineType, @aircraftDamage, @operator,
              @farDesc, @pilotCertification, @pilotTotalHours, @pilotMakeModelHours, @flightPhase, @flightType,
              @flightPlanFiledCode, @weatherConditions);

      DELETE FROM `events` WHERE `id` = `left` OR `id` = `right`;
      SET count = count + 1;
    END LOOP processDup;
    CLOSE dupCursor;
    SELECT CONCAT(CONCAT('Merged ', count), ' Events');
  END;
$$
DELIMITER ;

SET @deleted = 0;

# Create FAA events table and import data.
SELECT 'Importing FAA Data';
DROP TABLE IF EXISTS `events-faa`;
CREATE TABLE `events-faa` (
  `report-number` VARCHAR(16) NOT NULL UNIQUE,
  `date` VARCHAR(10) DEFAULT NULL,
  `city` VARCHAR(32) DEFAULT NULL,
  `state` VARCHAR(2) DEFAULT NULL,
  `airport` VARCHAR(64) DEFAULT NULL,
  `event-type` VARCHAR(16) NOT NULL,
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
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 2 LINES
(@reportNumber, @date, @city, @state, @airport, @eventType, @aircraftDamage, @flightPhase, @aircraftMake,
 @aircraftModel, @aircraftSeries, @operator, @primaryFlightType, @flightConductCode, @flightPlanFiledCode,
 @aircraftRegNumber, @fatalities, @injuries, @engineMake, @engineModel, @engineGroupCode, @engineCount,
 @pilotCertification, @pilotTotalHours, @pilotMakeModelHours)
SET
  `report-number` = TRIM(NULLIF(@reportNumber, '')),
  `date` = DATE_FORMAT(STR_TO_DATE(CONCAT(UCASE(LEFT(TRIM(NULLIF(@date, '')), 4)),
                                          LCASE(SUBSTRING(TRIM(NULLIF(@date, '')), 5))), '%d-%b-%y'), '%Y-%m-%d'),
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
  `aircraft-reg-number` = TRIM(NULLIF(@aircraftRegNumber, '')),
  `fatalities` = TRIM(NULLIF(@fatalities, '')),
  `injuries` = TRIM(NULLIF(@injuries, '')),
  `engine-make` = TRIM(NULLIF(@engineMake, '')),
  `engine-model` = TRIM(NULLIF(@engineModel, '')),
  `engine-group-code` = TRIM(NULLIF(@engineGroupCode, '')),
  `engine-count` = TRIM(NULLIF(@engineCount, '')),
  `pilot-certification` = TRIM(NULLIF(@pilotCertification, '')),
  `pilot-total-hours` = TRIM(NULLIF(@pilotTotalHours, '')),
  `pilot-make-model-hours` = TRIM(NULLIF(@pilotMakeModelHours, ''));

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events-faa` WHERE `event-type` IS NULL OR `event-type` = '');
DELETE FROM `events-faa` WHERE `event-type` IS NULL OR `event-type` = '';

# Create NTSB table and import data.
SELECT 'Importing NTSB Data';
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
  `location` = REPLACE(REPLACE(TRIM(NULLIF(@location, '')), ',,', ','), 'MACK,C', 'MACK C'),
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

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events-ntsb` WHERE `report-status` = 'PRELIMINARY');
DELETE FROM `events-ntsb` WHERE `report-status` = 'PRELIMINARY';

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events-ntsb` WHERE `event-date` LIKE '1948%'
    OR `event-date` LIKE '1962%' OR `event-date` LIKE '1974%' OR `event-date` LIKE '1977%');
DELETE FROM `events-ntsb` WHERE `event-date` LIKE '1948%' OR `event-date` LIKE '1962%'
    OR `event-date` LIKE '1974%' OR `event-date` LIKE '1977%';

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events-ntsb` WHERE `country` <> 'United States'
    OR `country` IS NULL);
DELETE FROM `events-ntsb` WHERE `country` <> 'United States' OR `country` IS NULL;

UPDATE `events-ntsb` SET `injuries-fatal` = IFNULL(`injuries-fatal`, 0),
  `injuries-serious` = IFNULL(`injuries-serious`, 0), `injuries-minor` = IFNULL(`injuries-minor`, 0),
  `uninjured` = IFNULL(`uninjured`, 0) WHERE NOT (`injuries-fatal` IS NULL AND `injuries-serious` IS NULL AND
    `injuries-minor` IS NULL AND `uninjured` IS NULL);

# Create events table.
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `source` VARCHAR(4) NOT NULL,
  `investigation-type` VARCHAR(10) NOT NULL,
  `report-status` VARCHAR(32) DEFAULT NULL,
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
SELECT 'Import FAA Data into Events';
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
    IF(`aircraft-reg-number` REGEXP '^[1-9][0-9]{0,4}$|^[1-9][0-9]{0,3}[A-HJ-NP-Z]$|^[1-9][0-9]{0,2}[A-HJ-NP-Z]{2}$',
       CONCAT('N', UCASE(`aircraft-reg-number`)), UCASE(`aircraft-reg-number`)), # aircraft-reg-number
    NULL, # aircraft-category
    WordCase(`aircraft-make`), # aircraft-make
    UCASE(`aircraft-model`), # aircraft-model
    UCASE(`aircraft-series`), # aircraft-series
    NULL, # amateur-built
    `engine-count`, # engine-count
    NULL, # engine-type
    UCASE(`aircraft-damage`), # aircraft-damage
    WordCase(`operator`), # operator
    NULLIF(UCASE(`flight-conduct-code`), 'UNKNOWN'), # far-desc
    UCASE(`pilot-certification`), # pilot-certification
    `pilot-total-hours`, # pilot-total-hours
    `pilot-make-model-hours`, # pilot-make-model-hours
    WordCase(`flight-phase`), # flight-phase
    NULLIF(UCASE(`primary-flight-type`), 'UNKNOWN'), # flight-type
    NULLIF(UCASE(`flight-plan-filed-code`), 'UNKNOWN'), # flight-plan-filed-code
    NULL # weather-conditions
  FROM `events-faa`
  ORDER BY `report-number` ASC;
DROP TABLE `events-faa`;

# Copy NTSB data into events table.
SELECT 'Import NTSB Data into Events';
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
    IF(INSTR(`location`, ',') = 0, # city
       WordCase(`location`),
       WordCase(TRIM(LEFT(`location`, INSTR(`location`, ',') - 1)))),
    IF(INSTR(`location`, ',') = 0, # state
       NULL,
       UCASE(TRIM(SUBSTRING(`location`, INSTR(`location`, ',') + 1)))),
    WordCase(`airport-name`), # airport-name
    UCASE(`airport-code`), # airport-code
    `latitude`, # latitude
    `longitude`, # longitude
    IFNULL(`injuries-fatal`, IF(`injury-severity` = 'Non-Fatal', 0, NULL)), # fatalities
    IF(`injuries-serious` IS NULL AND `injuries-minor` IS NULL, NULL, # injuries
       (IFNULL(`injuries-serious`, 0) + IFNULL(`injuries-minor`, 0))),
    `uninjured`, # uninjured
    UCASE(`aircraft-reg-number`), # aircraft-reg-number
    WordCase(NULLIF(`aircraft-category`, 'UNKNOWN')), # aircraft-category
    WordCase(`aircraft-make`), # aircraft-make
    UCASE(`aircraft-model`), # aircraft-model
    NULL, # aircraft-series
    UCASE(`amateur-built`), # amateur-built
    `engine-count`, # engine-count
    WordCase(`engine-type`), # engine-type
    UCASE(`aircraft-damage`), # aircraft-damage
    WordCase(`air-carrier`), # operator
    IF(INSTR(`far-desc`, ':') = 0, # far-desc
       NULLIF(UCASE(`far-desc`), 'UNKNOWN'),
       TRIM(SUBSTRING(UCASE(`far-desc`) FROM INSTR(UCASE(`far-desc`), ':') + 2))),
    NULL, # pilot-certification
    NULL, # pilot-total-hours
    NULL, # pilot-make-model-hours
    WordCase(`broad-flight-phase`), # flight-phase
    NULLIF(UCASE(`flight-purpose`), 'UNKNOWN'), # flight-type
    NULL, # flight-plan-filed-code
    UCASE(`weather-conditions`) # weather-conditions
  FROM `events-ntsb`
  ORDER BY `id` ASC;
DROP TABLE `events-ntsb`;

# Clean remaining junk data.
SELECT 'Clean Junk Data';
UPDATE `events` SET `aircraft-reg-number` = NULL WHERE `aircraft-reg-number` LIKE 'UN%'
    OR `aircraft-reg-number` LIKE 'NONE';

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events` WHERE `date` IS NULL);
DELETE FROM `events` WHERE `date` IS NULL;

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events` WHERE `state` = 'AA' OR `state` = 'ON' OR `state` = 'FN'
    OR `state` = 'AO' OR `state` = 'PO' OR `state` = 'UN' OR `state` = 'SI' OR `state` = 'HO');
DELETE FROM `events` WHERE `state` = 'AA' OR `state` = 'ON' OR `state` = 'FN'
    OR `state` = 'AO' OR `state` = 'PO' OR `state` = 'UN' OR `state` = 'SI' OR `state` = 'HO';

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events` WHERE `far-desc` = 'AIR CARRIER/COMMERCIAL'
    OR `far-desc` = 'TRAVEL CLUB' OR `far-desc` = 'PARACHUTE JUMPING' OR `far-desc` = 'AIR TAXI/COMMUTER'
    OR `far-desc` = 'PILOT SCHOOLS' OR `far-desc` = 'AGRICULTURAL' OR `far-desc` = 'FOREIGN AIR CARRIER'
    OR `far-desc` = 'SCHEDULED AIRCRAFT/HELICOPTER' OR `far-desc` = 'ROTORCRAFT EXTERNAL LOAD OPERATIONS'
    OR `far-desc` = 'PART 125 OPERATOR' OR `far-desc` = 'AIR TAXI & COMMUTER'
    OR `far-desc` = 'PUBLIC USE' OR `far-desc` = 'AIR CARRIER' OR `far-desc` = 'ROTORCRAFT EXT. LOAD'
    OR `far-desc` = 'FOREIGN' OR `far-desc` = '20+ PAX,6000+ LBS' OR `far-desc` = 'ARMED FORCES'
    OR `far-desc` = 'NON-U.S., COMMERCIAL');
DELETE FROM `events` WHERE `far-desc` = 'AIR CARRIER/COMMERCIAL'
    OR `far-desc` = 'TRAVEL CLUB' OR `far-desc` = 'PARACHUTE JUMPING' OR `far-desc` = 'AIR TAXI/COMMUTER'
    OR `far-desc` = 'PILOT SCHOOLS' OR `far-desc` = 'AGRICULTURAL' OR `far-desc` = 'FOREIGN AIR CARRIER'
    OR `far-desc` = 'SCHEDULED AIRCRAFT/HELICOPTER' OR `far-desc` = 'ROTORCRAFT EXTERNAL LOAD OPERATIONS'
    OR `far-desc` = 'PART 125 OPERATOR' OR `far-desc` = 'AIR TAXI & COMMUTER'
    OR `far-desc` = 'PUBLIC USE' OR `far-desc` = 'AIR CARRIER' OR `far-desc` = 'ROTORCRAFT EXT. LOAD'
    OR `far-desc` = 'FOREIGN' OR `far-desc` = '20+ PAX,6000+ LBS' OR `far-desc` = 'ARMED FORCES'
    OR `far-desc` = 'NON-U.S., COMMERCIAL';

SET @deleted = @deleted + (SELECT COUNT(*) FROM `events` WHERE `flight-type` = 'PUBLIC USE'
    OR `flight-type` = 'ILLEGAL DRUG, STOLEN AIRCRAFT, ETC.' OR `flight-type` = 'AIR TAXI (NON-SCHEDULED)'
    OR `flight-type` = 'SCHEDULED AIR CARRIER' OR `flight-type` = 'FOR HIRE'
    OR `flight-type` = 'AERIAL APPLICATOR' OR `flight-type` = 'AIR TAXI (SCHEDULED- NOT COMMUTER)'
    OR `flight-type` = 'AIR TAXI OPERATOR- LARGE AIRCRAFT' OR `flight-type` = 'ALL CARGO CARRIERS'
    OR `flight-type` = 'AIR TAXI COMMUTER (SCHEDULED 5 OR MORE ROUNDTRIPS PER WEEK)'
    OR `flight-type` = 'SUPPLEMENTAL OR COMMERCIAL OPERATOR' OR `flight-type` = 'AIR DROP'
    OR `flight-type` = 'SKYDIVING' OR `flight-type` = 'FLIGHT TEST' OR `flight-type` = 'BANNER TOW'
    OR `flight-type` = 'PUBLIC AIRCRAFT - FEDERAL' OR `flight-type` = 'FERRY' OR `flight-type` = 'GLIDER TOW'
    OR `flight-type` = 'AIR RACE/SHOW' OR `flight-type` = 'EXTERNAL LOAD'
    OR `flight-type` = 'AERIAL APPLICATION' OR `flight-type` = 'FIRE FIGHTING'
    OR `flight-type` = 'PUBLIC AIRCRAFT - STATE' OR `flight-type` = 'PUBLIC AIRCRAFT - LOCAL'
    OR `flight-type` = 'INDUSTRIAL/SPECIAL');
DELETE FROM `events` WHERE `flight-type` = 'PUBLIC USE'
    OR `flight-type` = 'ILLEGAL DRUG, STOLEN AIRCRAFT, ETC.' OR `flight-type` = 'AIR TAXI (NON-SCHEDULED)'
    OR `flight-type` = 'SCHEDULED AIR CARRIER' OR `flight-type` = 'FOR HIRE'
    OR `flight-type` = 'AERIAL APPLICATOR' OR `flight-type` = 'AIR TAXI (SCHEDULED- NOT COMMUTER)'
    OR `flight-type` = 'AIR TAXI OPERATOR- LARGE AIRCRAFT' OR `flight-type` = 'ALL CARGO CARRIERS'
    OR `flight-type` = 'AIR TAXI COMMUTER (SCHEDULED 5 OR MORE ROUNDTRIPS PER WEEK)'
    OR `flight-type` = 'SUPPLEMENTAL OR COMMERCIAL OPERATOR' OR `flight-type` = 'AIR DROP'
    OR `flight-type` = 'SKYDIVING' OR `flight-type` = 'FLIGHT TEST' OR `flight-type` = 'BANNER TOW'
    OR `flight-type` = 'PUBLIC AIRCRAFT - FEDERAL' OR `flight-type` = 'FERRY' OR `flight-type` = 'GLIDER TOW'
    OR `flight-type` = 'AIR RACE/SHOW' OR `flight-type` = 'EXTERNAL LOAD'
    OR `flight-type` = 'AERIAL APPLICATION' OR `flight-type` = 'FIRE FIGHTING'
    OR `flight-type` = 'PUBLIC AIRCRAFT - STATE' OR `flight-type` = 'PUBLIC AIRCRAFT - LOCAL'
    OR `flight-type` = 'INDUSTRIAL/SPECIAL';

SET @deleted = @deleted +
    (SELECT COUNT(*) FROM `events` WHERE LEFT(`date`, 4) < 1982 OR LEFT(`date`, 4) >= YEAR(CURDATE()));
DELETE FROM `events` WHERE LEFT(`date`, 4) < 1982 OR LEFT(`date`, 4) >= YEAR(CURDATE());

SELECT CONCAT(CONCAT('Deleted ', @deleted), ' Rows');

SELECT 'Merge Duplicate Events';
CALL MergeEvents();
