# Metrics API demo
Simple API which is using uWebsockets and returning the data from PostgreSQL database.

## Quickstart (Docker)
Run code below in docker
```
docker-compose build
docker-compose up
```

Access API via
```
curl http://localhost:9000/metrics
```
or web browser

## Database schema
Abstract database schema can be found below

```mermaid
erDiagram
    metrics {
        INT id
        TEXT name
        TEXT unit
        TEXT description
        TIMESTAMP created_at
    }
    sensor_types {
        INT id
        TEXT name
        TEXT description
        TIMESTAMP created_at
    }
    sensors {
        INT id
        TEXT name
        INT type
        TEXT location
        BOOLEAN status
        TIMESTAMP created_at
    }
    sensor_readings {
        INT id
        INT metric_id
        INT sensor_id
        NUMERIC value
        TIMESTAMP timestamp
    }

    metrics ||--o{ sensor_readings : "metric_id"
    sensor_types ||--o{ sensors : "type"
    sensors ||--o{ sensor_readings : "sensor_id"
```
