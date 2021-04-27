create table workout_level(
workout_level_id number(11) not null primary key,
 naam VARCHAR(60)
);

create table diet(
 diet_id number(11) not null primary kwy,
 naam varchar(50) not null,
 beschrijving varchar(100)
);

create table exercise
(
exercise_id number(11) not null primary key,
naam varchar(60),
lichaamdeel varchar(60),
graad number(11)
);

create table gebruiker
(
gebruiker_id number(11) not null primary key,
naam varchar2(60),
adress varchar2(60),
geboortedatum date,
bmi float(7),
weight float(6),
diet_id number(11),
constraint fk_gdiet_link foreign key (diet_id) REFERENCES diet(diet_id)
);

create table workout
(
workout_id number(11) not null primary key,
naam varchar(60),
categorie varchar(60),
exercise_id number(11) not null,
workout_level_id number(11) not NULL,
CONSTRAINT fk_wwl_link foreign key (workout_level_id) REFERENCES workout_level(workout_level_id),
CONSTRAINT fk_we_link foreign key (exercise_id) REFERENCES exercise(exercise_id)
);

create table gebruiker_workout
(
gebruiker_workout_id number(11) not null primary key,
gebruiker_id number(11) not null,
workout_id number(11) not null,
CONSTRAINT fk_gw_link foreign key (gebruiker_id) REFERENCES gebruiker(gebruiker_id),
CONSTRAINT fk_wg_link foreign key (workout_id) REFERENCES workout(workout_id)
);	NOtAnotherWorkoutApp	1618673370326	Script	1	2.336


De volgende zijn views
View 1: WORKOUT_WITH_LEVELS
SELECT workout.workout_id, workout.workout_naam, workout_level.workout_level_id, workout_level.level_naam
FROM workout
RIGHT JOIN workout_level ON workout.workout_level_id = workout_level.workout_level_id
ORDER BY workout.workout_naam

View 2: WORKOUT_WITH_EXERCISES
SELECT workout.workout_id, workout.workout_naam, exercise.exercise_naam
FROM workout
RIGHT JOIN exercise ON workout.exercise_id= exercise.exercise_id
ORDER BY workout.workout_naam

View 3:GEBRUIKERS_DEMOGRAPHIC_YOUTH
SELECT gebruiker_naam, ROUND((SYSDATE - TO_DATE(geboortedatum))/365.25, 5) AS AGE 
from gebruiker
WHERE ROUND((SYSDATE - TO_DATE(geboortedatum))/365.25, 5) BETWEEN 16 AND 24

View 4: GEBRUIKER_WITH_DIET
SELECT gebruiker.gebruiker_id, gebruiker.gebruiker_naam, diet.diet_naam
FROM gebruiker
RIGHT JOIN diet ON gebruiker.diet_id = diet.diet_id
ORDER BY diet.diet_naam

View 5: GEBRUIKER_DEMPGRAPHIC_ADULT
SELECT gebruiker_naam, ROUND((SYSDATE - TO_DATE(geboortedatum))/365.25, 5) AS AGE 
from gebruiker
WHERE ROUND((SYSDATE - TO_DATE(geboortedatum))/365.25, 5) BETWEEN 25 AND 64

View 6: GEBRUIKER_DEMOGRAPHIC_SENIOR
SELECT gebruiker_naam, ROUND((SYSDATE - TO_DATE(geboortedatum))/365.25, 5) AS AGE 
from gebruiker
WHERE ROUND((SYSDATE - TO_DATE(geboortedatum))/365.25, 5) >= 65


