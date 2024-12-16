#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include "App.h"
#include <libpq-fe.h>
#include "dao.h"
#include <nlohmann/json.hpp>

// Use the nlohmann::json namespace for convenience
using json = nlohmann::json;
using namespace Dao;

int main() {
    const auto* use_dockerized_postgres = std::getenv("USE_DOCKERIZED_POSTGRES");
    if (use_dockerized_postgres) {
        fprintf(stdout, "Sleeping for 3 seconds...\n");
        usleep(3000000);
    } 

    const auto* psql_conn_str = std::getenv("POSTGRES_CONNECTION_STRING");
    // Creating object and calling parameterized constructor
    Dao::MetricsDao metricsDao(psql_conn_str);

    uWS::App()
        .get("/metrics", [&metricsDao](auto *res, auto *req){
            res->writeHeader("Content-Type", "application/json; charset=utf-8");
            auto metrics = metricsDao.fetchMetrics();            
            auto metricsJSON = json::array();  // Start with an empty JSON array
            for (const auto & el : metrics) {                
                 metricsJSON.push_back(json{
                    {"id", el.id},
                    {"name", el.name},
                    {"unit", el.unit},
                    {"description", el.description},
                    {"created_at", el.created_at}
                });
            }
            res->end(metricsJSON.dump());
        })
        .listen(9000, [](auto *token) {
            if (token) {
                fprintf(stdout, "Listening on port 9000\n");
            } else {
                fprintf(stderr, "Failed to listen on port 9000\n");
            }
        })
        .run();
    return 0;
}