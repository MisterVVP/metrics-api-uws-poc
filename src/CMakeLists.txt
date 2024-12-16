add_executable(metrics-hub-cpp main.cpp dao.cpp dao.h)

target_include_directories(metrics-hub-cpp PRIVATE "${uwebsockets_SOURCE_DIR}/src" "${uwebsockets_SOURCE_DIR}/uSockets/src")

target_link_libraries(metrics-hub-cpp PRIVATE "${uwebsockets_SOURCE_DIR}/uSockets/uSockets.a" ZLIB::ZLIB PostgreSQL::PostgreSQL nlohmann_json::nlohmann_json)
