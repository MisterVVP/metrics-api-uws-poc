#pragma once
#include <vector>

namespace Dao
{
    struct Metrics {
        int id;
        std::string name;
        std::string unit;
        std::string description;
        std::string created_at;
    };
     
    class IDao {
        protected:
            PGconn *conn;
        public:    
            IDao(char const* psql_conn_str);
            ~IDao();
    };

    class MetricsDao : IDao {
        public:
            MetricsDao(char const* psql_conn_str) : IDao(psql_conn_str){};
            std::vector<Metrics> fetchMetrics();
    };
}
