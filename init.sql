-- Create Metrics Table if it does not exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'metrics') THEN
        CREATE TABLE metrics (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            unit TEXT NOT NULL,
            description TEXT,
            created_at TIMESTAMP DEFAULT NOW()
        );
    END IF;
END $$;

-- Create Sensor Types Table if it does not exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'sensor_types') THEN
        CREATE TABLE sensor_types (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            description TEXT,
            created_at TIMESTAMP DEFAULT NOW()
        );
    END IF;
END $$;

-- Create Sensors Table if it does not exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'sensors') THEN
        CREATE TABLE sensors (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            type INT NOT NULL REFERENCES sensor_types(id),
            location TEXT,
            status BOOLEAN DEFAULT TRUE,
            created_at TIMESTAMP DEFAULT NOW()
        );
    END IF;
END $$;

-- Create Sensor Readings Table if it does not exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'sensor_readings') THEN
        CREATE TABLE sensor_readings (
            id SERIAL PRIMARY KEY,
            metric_id INT NOT NULL REFERENCES metrics(id),
            sensor_id INT NOT NULL REFERENCES sensors(id),
            value NUMERIC NOT NULL,
            timestamp TIMESTAMP NOT NULL
        );
    END IF;
END $$;

-- Insert Metric Types if not exists
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM metrics WHERE name = 'temperature') THEN
        INSERT INTO metrics (name, unit, description) VALUES
        ('temperature', '°C', 'Measures ambient temperature'),
        ('humidity', '%', 'Measures relative humidity'),
        ('cpu', '%', 'CPU usage of a system'),
        ('co2', 'ppm', 'CO2 concentration in the air');
    END IF;
END $$;

-- Insert Sensor Types if not exists
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM sensor_types WHERE name = 'Temperature Sensor') THEN
        INSERT INTO sensor_types (name, description) VALUES
        ('Temperature Sensor', 'Measures temperature'),
        ('Humidity Sensor', 'Measures humidity levels'),
        ('System Monitor', 'Monitors CPU, RAM, etc.');
    END IF;
END $$;

-- Insert Sensors if not exists
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM sensors WHERE name = 'sensor_1') THEN
        INSERT INTO sensors (name, type, location) VALUES
        ('sensor_1', 1, 'Room A'),
        ('sensor_2', 2, 'Room B'),
        ('sensor_3', 3, 'Server Room');
    END IF;
END $$;

-- Insert Sensor Readings if not exists
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM sensor_readings WHERE value = 22.5 AND timestamp = '2024-12-15 10:00:00') THEN
        INSERT INTO sensor_readings (metric_id, sensor_id, value, timestamp) VALUES
        (1, 1, 22.5, '2024-12-15 10:00:00'),
        (2, 2, 60.0, '2024-12-15 10:05:00'),
        (3, 3, 30.2, '2024-12-15 10:10:00'),
        (1, 1, 23.0, '2024-12-15 11:00:00'),
        (2, 2, 55.0, '2024-12-15 11:05:00');
    END IF;
END $$;
