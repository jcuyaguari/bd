psql --username=freecodecamp --dbname=postgres
CREATE DATABASE universe;
\c universe


CREATE TABLE galaxy (
  galaxy_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  galaxy_type TEXT,
  age_in_millions_of_years INT NOT NULL,
  has_life BOOLEAN NOT NULL
);


CREATE TABLE star (
  star_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  galaxy_id INT REFERENCES galaxy(galaxy_id) NOT NULL,
  star_type TEXT,
  age_in_millions_of_years INT NOT NULL,
  is_spherical BOOLEAN NOT NULL
);

CREATE TABLE planet (
  planet_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  star_id INT REFERENCES star(star_id) NOT NULL,
  planet_type TEXT,
  distance_from_star INT NOT NULL,
  has_life BOOLEAN NOT NULL
);

CREATE TABLE moon (
  moon_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  planet_id INT REFERENCES planet(planet_id) NOT NULL,
  size_in_km NUMERIC(10,2),
  is_spherical BOOLEAN NOT NULL
);

CREATE TABLE satellite (
  satellite_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  planet_id INT REFERENCES planet(planet_id),
  mass_in_kg NUMERIC(15,2),
  active BOOLEAN NOT NULL
);

INSERT INTO galaxy (name, galaxy_type, age_in_millions_of_years, has_life) VALUES
('Milky Way', 'Spiral', 13600, TRUE),
('Andromeda', 'Spiral', 10000, FALSE),
('Triangulum', 'Spiral', 7000, FALSE),
('Whirlpool', 'Spiral', 13000, FALSE),
('Sombrero', 'Elliptical', 9000, FALSE),
('Cartwheel', 'Lenticular', 8000, FALSE);

INSERT INTO star (name, galaxy_id, star_type, age_in_millions_of_years, is_spherical) VALUES
('Sun', 1, 'G-type', 4600, TRUE),
('Sirius', 2, 'A-type', 300, TRUE),
('Betelgeuse', 3, 'M-type', 8000, TRUE),
('Vega', 4, 'A-type', 500, TRUE),
('Rigel', 5, 'B-type', 10000, TRUE),
('Proxima Centauri', 1, 'M-type', 4500, TRUE);

INSERT INTO planet (name, star_id, planet_type, distance_from_star, has_life) VALUES
('Mercury', 1, 'Terrestrial', 58, FALSE),
('Venus', 1, 'Terrestrial', 108, FALSE),
('Earth', 1, 'Terrestrial', 150, TRUE),
('Mars', 1, 'Terrestrial', 228, FALSE),
('Jupiter', 1, 'Gas Giant', 778, FALSE),
('Saturn', 1, 'Gas Giant', 1430, FALSE),
('Neptune', 1, 'Ice Giant', 4500, FALSE),
('Kepler-452b', 2, 'Super-Earth', 1400, FALSE),
('Proxima b', 6, 'Exoplanet', 4, TRUE),
('Alpha Centauri Bb', 6, 'Exoplanet', 70, FALSE),
('TRAPPIST-1e', 3, 'Exoplanet', 40, FALSE),
('Luyten b', 4, 'Exoplanet', 12, TRUE);

INSERT INTO moon (name, planet_id, size_in_km, is_spherical) VALUES
('Moon', 3, 3474.2, TRUE),
('Phobos', 4, 22.4, TRUE),
('Deimos', 4, 12.4, TRUE),
('Io', 5, 3643.2, TRUE),
('Europa', 5, 3121.6, TRUE),
('Ganymede', 5, 5262.4, TRUE),
('Callisto', 5, 4820.6, TRUE),
('Titan', 6, 5149.5, TRUE),
('Enceladus', 6, 504.2, TRUE),
('Mimas', 6, 396.4, TRUE),
('Tethys', 6, 1062.2, TRUE),
('Dione', 6, 1122.0, TRUE),
('Rhea', 6, 1527.6, TRUE),
('Oberon', 7, 1522.8, TRUE),
('Titania', 7, 1577.8, TRUE),
('Ariel', 7, 1157.8, TRUE),
('Umbriel', 7, 1169.4, TRUE),
('Triton', 8, 2706.8, TRUE),
('Nereid', 8, 340.0, TRUE),
('Charon', 9, 1212.0, TRUE);

INSERT INTO satellite (name, planet_id, mass_in_kg, active) VALUES
('Hubble', 3, 11100.50, TRUE),
('Voyager 1', 5, 825.40, FALSE),
('Cassini', 6, 5712.00, FALSE);
